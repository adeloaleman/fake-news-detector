### Migrate with Docker (recommended: no old R on the new server)

To avoid installing an older R (and all its packages) directly on the new Ubuntu 24 server, run the app in a **Docker container** that uses the same R version as your old server. Only Docker is installed on the host; R and the app live inside the container.

1. On the **old server**: note R version and R-packages versions
2. On the **new server**: install Docker only (no R, no Shiny Server):
  ```bash
   sudo apt update && sudo apt install -y docker.io
   docker --version
   sudo systemctl enable docker && sudo systemctl start docker
  ```
3. Put the app on the new server. Use the **Dockerfile** in this repo to deploy the app
4. From the app directory (where `Dockerfile` and `ui.R` are), use **one** of the two workflows below.

#### Option A: Full build (when you change apt/R packages or first time)

  ```bash
  cd ~/fake-news-detector
  docker build -t fake-news-detector-image .
  docker run -d -p 3838:3838 --name fake-news-detector-container fake-news-detector-image
  ```
  This can take ~30 minutes because it installs all system and R dependencies.

#### Test readtext first (avoid 30‑min rebuilds when fixing readtext)

Before running a full `docker build` (30+ min), **prove that readtext installs** using a small test image and a script you can edit and re-run **without rebuilding**:

1. **One-time:** build the readtext-test image (~2 min):
   ```bash
   cd ~/fake-news-detector
   docker build -f Dockerfile.readtext-test -t readtext-test .
   ```

2. **Every time you change the install sequence:** run the script (no rebuild; script is on your host, mounted into the container):
   ```bash
   docker run --rm -v "$(pwd):/app" -w /app readtext-test R -f scripts/install-readtext-test.R
   ```
   - If it fails, fix `scripts/install-readtext-test.R` (or add missing deps to the script), then run the same command again. No Docker build.
   - If it prints `readtext OK` and exits 0, the same sequence in the main Dockerfile should work; then run the full build.

3. **Only after the script succeeds:** run the full build:
   ```bash
   docker build -t fake-news-detector-image .
   ```

#### Test deps only (after changing R packages in the main Dockerfile)

To check that the full deps stage builds and loads:

```bash
docker build --target deps -t fake-news-deps .
docker run --rm fake-news-deps R -e "library(readxl); library(readtext); library(streamR); cat('Deps OK\n')"
```

#### Option B: Fast build (when you only change app code or the app-stage install)

  Use this so you don’t wait 30 minutes every time you tweak the app or the final install step.

  1. **Once** (or when you change apt / R packages in the main Dockerfile), build the dependency image:
     ```bash
     cd ~/fake-news-detector
     docker build --target deps -t fake-news-deps .
     ```
  2. For normal iteration (app code or `Dockerfile.app` changes only), build the app image in ~1–2 minutes:
     ```bash
     docker build -f Dockerfile.app -t fake-news-detector-image .
     docker run -d -p 3838:3838 --name fake-news-detector-container fake-news-detector-image
     ```

  Summary:
  - **First time or after changing deps:** run step 1, then step 2.
  - **Only app / RTextTools install changes:** run step 2 only.

#### Why the full build often takes 30 min again

- Changing **any line** in the main `Dockerfile` (including the app stage) can invalidate Docker’s cache depending on your Docker version and how the layers are stored. So a single edit may trigger a full rebuild.
- Using **Option B** avoids that: the heavy work lives in the `fake-news-deps` image; `Dockerfile.app` only adds your app and the prodlim/ipred/RTextTools step, so that build stays short.

5. Hit the app at `http://YOUR_SERVER_IP:3838` in a browser.
  ```bash
  curl -s -o /dev/null -w "%{http_code}" http://localhost:3838
  ```

  


#### Useful Docker commands

```bash
# List images
docker image ls

# Containers running
docker ps -a  # All containers
docker ps     # Running containers

# Logs
docker logs -f fake-news-detector-container

# Stop
docker stop fake-news-detector-container
# Remove the stopped one
docker rm fake-news-detector-container 

# Start again
docker start fake-news-detector-container

# Rebuild after changing app or Dockerfile (uses cache; only changed layers rebuild)
docker build -t fake-news-detector-image .
docker stop fake-news-detector-container
docker rm fake-news-detector-container
docker run -d -p 3838:3838 --name fake-news-detector-container fake-news-detector-image
```

  


### Nginx conf.

```bash
sudo certbot --nginx -d fake-news-detector.sinfrontera.net

sudo cp nginx-fake-news-detector.net /etc/nginx/sites-available/fake-news-detector.net
sudo ln -s /etc/nginx/sites-available/fake-news-detector.net /etc/nginx/sites-enabled/

sudo nginx -t && sudo systemctl reload nginx
```

