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
# Containers running
docker ps

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
docker stop fake-news-detector-container 2>/dev/null; docker rm fake-news-detector-container 2>/dev/null
docker run -d -p 3838:3838 --name fake-news-detector-container fake-news-detector-image
```

  


### Nginx conf.

```bash
sudo certbot --nginx -d fake-news-detector.sinfrontera.net

sudo cp nginx-fake-news-detector.net /etc/nginx/sites-available/fake-news-detector.net
sudo ln -s /etc/nginx/sites-available/fake-news-detector.net /etc/nginx/sites-enabled/

sudo nginx -t && sudo systemctl reload nginx
```

