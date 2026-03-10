# Use the same R version as your old server.
# When you run docker build: Docker downloads that image from Docker Hub.
# That image is a snapshot that already contains R and the base system.
FROM rocker/r-ver:3.4.4

# System libs for R packages (imager, tm, etc.)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gfortran \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libmagick++-dev \
    libfftw3-dev \
    && rm -rf /var/lib/apt/lists/*

## Install the exact package versions from the old server
RUN R -e "install.packages('remotes', repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('shiny',      version = '1.4.0',    repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('readtext',   version = '0.75',     repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('xgboost',    version = '0.90.0.2', repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('text2vec',   version = '0.5.1',    repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('tm',         version = '0.7-7',    repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('NLP',        version = '0.2-0',    repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('readr',      version = '1.3.1',    repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('SnowballC',  version = '0.6.0',    repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('imager',     version = '0.42.1',   repos = 'https://cloud.r-project.org/')"

# Creating a working directory for the app
WORKDIR /app

# Copying the app into the working directory
COPY . /app

# Install RTextTools and FakeNewsDetector from local R-packages.n0b4
# (Project must contain R-packages.n0b4/RTextTools-modificado/RTextTools and R-packages.n0b4/FakeNewsDetector)
RUN R CMD INSTALL /app/R-packages.n0b4/RTextTools-modificado/RTextTools && \
    R CMD INSTALL /app/R-packages.n0b4/FakeNewsDetector && \
    rm -rf /app/R-packages.n0b4

# App needs to write readData.txt and result-*.txt
RUN chmod -R a+rX /app && chmod -R a+w /app

EXPOSE 3838

# Run the app directly (no Shiny Server needed)
CMD ["R", "-e", "shiny::runApp('/app', host='0.0.0.0', port=3838)"]
