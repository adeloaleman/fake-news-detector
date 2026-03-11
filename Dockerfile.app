# Fast app-only build: use this when you did NOT change apt or R packages in the main Dockerfile.
# Requires the deps image to exist. Build it once with:
#   docker build --target deps -t fake-news-deps .
# Then use this file so only app install + your code runs (~1–2 min):
#   docker build -f Dockerfile.app -t fake-news-detector-image .
FROM fake-news-deps

WORKDIR /app
COPY . /app

# Install lava 1.6.6 first so prodlim does not pull lava 1.8.x (which needs progressr, not on R 3.4).
RUN R -e "remotes::install_version('lava', version = '1.6.6', repos = 'https://cloud.r-project.org/', upgrade = 'never')" && \
    R -e "remotes::install_version('prodlim', version = '1.6.1', repos = 'https://cloud.r-project.org/', upgrade = 'never')" && \
    R -e "remotes::install_version('ipred', version = '0.9-9', repos = 'https://cloud.r-project.org/', upgrade = 'never')" && \
    R CMD INSTALL /app/R-packages.n0b4/RTextTools-modificado/RTextTools && \
    R CMD INSTALL /app/R-packages.n0b4/FakeNewsDetector && \
    rm -rf /app/R-packages.n0b4

RUN chmod -R a+rX /app && chmod -R a+w /app

EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/app', host='0.0.0.0', port=3838)"]
