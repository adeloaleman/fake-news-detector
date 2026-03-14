### Migrate with Docker (recommended: no old R on the new server)

To avoid installing an older R (and all its packages) directly on the new Ubuntu 24 server, run the app in a **Docker container** that uses the same R version as your old server. Only Docker is installed on the host; R and the app live inside the container.

```bash
cd ~/fake-news-detector

docker build -t fake-news-image .

# Or
docker build -q -t fake-news-image -f Dockerfile .   # This is the same build but not all information is printed during building, only errors: -q: quiet 

# Or
docker build -t fake-news-image . > build.log 2>&1   # If we want the building details to be save to a .log file istead of being printed on the terminal

docker run -d -p 3838:3838 --name fake-news-container fake-news-image
```

Hit the app at `http://YOUR_SERVER_IP:3838` in a browser.

```bash
curl http://localhost:3838
```


#### Useful Docker commands

```bash
# List images
docker image ls

# Containers running
docker ps -a  # All containers
docker ps     # Running containers

# Logs
docker logs -f fake-news-container

# Stop
docker stop fake-news-container
# Remove the stopped one
docker rm fake-news-container 

# Start again
docker start fake-news-container

# Rebuild after changing app or Dockerfile (uses cache; only changed layers rebuild)
docker build -t fake-news-image .
docker stop fake-news-container
docker rm fake-news-container
docker run -d -p 3838:3838 --name fake-news-container fake-news-image

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

