### Migrate with Docker (recommended: no old R on the new server)

To avoid installing an older R (and all its packages) directly on the new Ubuntu 24 server, run the app in a **Docker container** that uses the same R version as your old server. Only Docker is installed on the host; R and the app live inside the container.


```bash
cd ~/fake-news-detector
docker build -t fake-news-detector-image .
docker build -q -t fake-news-detector-image -f Dockerfile . # This is the same build but not all information is printed during building, only errors: -q: quiet 
docker build -t fake-news-detector-image . > build.log 2>&1

docker run -d -p 3838:3838 --name fake-news-detector-container fake-news-detector-image
```


Hit the app at `http://YOUR_SERVER_IP:3838` in a browser.
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

# Delete all containers
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

# Delete all images
docker rmi $(docker images -q)
# One-shot prune (images, containers, volumes, networks). If you truly want to wipe almost everything Docker created on your machine:
docker system prune -a --volumes
```

  


### Nginx conf.

```bash
sudo certbot --nginx -d fake-news-detector.sinfrontera.net

sudo cp nginx-fake-news-detector.net /etc/nginx/sites-available/fake-news-detector.net
sudo ln -s /etc/nginx/sites-available/fake-news-detector.net /etc/nginx/sites-enabled/

sudo nginx -t && sudo systemctl reload nginx
```

