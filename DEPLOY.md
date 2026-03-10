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
4. From the app directory (where `Dockerfile` and `ui.R` are):
  ```bash
  cd ~/fake-news-detector
  docker build -t fake-news-detector-image .
  docker run -d -p 3838:3838 --name fake-news-detector-container fake-news-detector-image
  ```
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

# Rebuild after changing app or Dockerfile
docker stop fake-news-detector-container && docker rm fake-news-detector-container
docker build -t fake-news-detector-image .
docker run -d -p 3838:3838 --name fake-news-detector-container fake-news-detector-image
```

  


### Nginx conf.

```bash
sudo certbot --nginx -d fake-news-detector.sinfrontera.net

sudo cp nginx-fake-news-detector.net /etc/nginx/sites-available/fake-news-detector.net
sudo ln -s /etc/nginx/sites-available/fake-news-detector.net /etc/nginx/sites-enabled/

sudo nginx -t && sudo systemctl reload nginx
```

