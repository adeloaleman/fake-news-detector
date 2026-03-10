# Use the same R version as your old server.
# When you run docker build: Docker downloads that image from Docker Hub.
# That image is a snapshot that already contains R and the base system.
FROM rocker/r-ver:3.4.4 AS deps

# Use Debian archive (Stretch is EOL and no longer on main mirrors)
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    echo 'deb http://archive.debian.org/debian stretch-backports main' >> /etc/apt/sources.list

# Allow apt to use archived repos (expired Release/Valid-Until)
RUN echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-valid-until

# System libs for R packages (imager, tm, pdftools, readxl, etc.)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gfortran \
    wget \
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
    libpoppler-cpp-dev \
    libxls-dev \
    && rm -rf /var/lib/apt/lists/*

# Install gcc-7/g++-7 from archive (C++17/string_view for ndjson, qpdf). Do NOT install Buster binutils:
# their ld requires glibc 2.27 and breaks linking on Stretch. Install gcc-7 with --force-depends, then
# install Stretch binutils via dpkg --force-depends so /usr/bin/ld is the Stretch version (glibc 2.24).
RUN ARCH='http://archive.debian.org/debian/pool/main' && \
    G7="$ARCH/g/gcc-7" && G8="$ARCH/g/gcc-8" && ISL="$ARCH/i/isl" && MPFR="$ARCH/m/mpfr4" && \
    MPC="$ARCH/m/mpclib3" && BIN_STRETCH="$ARCH/b/binutils" && \
    cd /tmp && \
    wget -q \
      "$MPC/libmpc3_1.1.0-1_amd64.deb" \
      "$ISL/libisl19_0.20-2_amd64.deb" \
      "$MPFR/libmpfr6_4.0.2-1_amd64.deb" \
      "$G8/gcc-8-base_8.3.0-6_amd64.deb" \
      "$G8/libgcc1_8.3.0-6_amd64.deb" \
      "$G8/libgomp1_8.3.0-6_amd64.deb" \
      "$G8/libitm1_8.3.0-6_amd64.deb" \
      "$G8/libatomic1_8.3.0-6_amd64.deb" \
      "$G8/libstdc++6_8.3.0-6_amd64.deb" \
      "$G8/libcc1-0_8.3.0-6_amd64.deb" \
      "$G8/liblsan0_8.3.0-6_amd64.deb" \
      "$G8/libmpx2_8.3.0-6_amd64.deb" \
      "$G8/libquadmath0_8.3.0-6_amd64.deb" \
      "$G8/libtsan0_8.3.0-6_amd64.deb" \
      "$G7/libasan4_7.4.0-6_amd64.deb" \
      "$G7/libcilkrts5_7.4.0-6_amd64.deb" \
      "$G7/libubsan0_7.4.0-6_amd64.deb" \
      "$G7/gcc-7-base_7.4.0-6_amd64.deb" \
      "$G7/cpp-7_7.4.0-6_amd64.deb" \
      "$G7/libgcc-7-dev_7.4.0-6_amd64.deb" \
      "$G7/gcc-7_7.4.0-6_amd64.deb" \
      "$G7/libstdc++-7-dev_7.4.0-6_amd64.deb" \
      "$G7/g++-7_7.4.0-6_amd64.deb" && \
    wget -q \
      "$BIN_STRETCH/binutils_2.28-5_amd64.deb" && \
    dpkg --force-depends -r binutils || true && \
    dpkg -i --force-depends libmpc3_1.1.0-1_amd64.deb \
            libisl19_0.20-2_amd64.deb libmpfr6_4.0.2-1_amd64.deb \
            gcc-8-base_8.3.0-6_amd64.deb \
            libgcc1_8.3.0-6_amd64.deb libgomp1_8.3.0-6_amd64.deb \
            libitm1_8.3.0-6_amd64.deb libatomic1_8.3.0-6_amd64.deb \
            libstdc++6_8.3.0-6_amd64.deb libcc1-0_8.3.0-6_amd64.deb \
            liblsan0_8.3.0-6_amd64.deb libmpx2_8.3.0-6_amd64.deb \
            libquadmath0_8.3.0-6_amd64.deb libtsan0_8.3.0-6_amd64.deb \
            libasan4_7.4.0-6_amd64.deb libcilkrts5_7.4.0-6_amd64.deb \
            libubsan0_7.4.0-6_amd64.deb \
            gcc-7-base_7.4.0-6_amd64.deb cpp-7_7.4.0-6_amd64.deb \
            libgcc-7-dev_7.4.0-6_amd64.deb gcc-7_7.4.0-6_amd64.deb \
            libstdc++-7-dev_7.4.0-6_amd64.deb g++-7_7.4.0-6_amd64.deb || true && \
    ( dpkg --configure -a --force-depends || true ) && \
    dpkg -i --force-depends binutils_2.28-5_amd64.deb && \
    rm -f /tmp/*.deb && \
    g++-7 --version

# Allow packages that need C++17 (ndjson, qpdf) to compile; g++-7 provides <string_view>
RUN echo 'CXX17 = g++-7 -std=c++17 -fPIC' >> /usr/local/lib/R/etc/Makeconf

## Install the exact package versions from the old server
## Step 1: Base deps (R 3.4–compatible) so CRAN does not pull newer incompatible versions
RUN R -e "install.packages('remotes', repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('Rcpp',         version = '1.0.1',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('R6',           version = '2.4.0',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('rlang',        version = '0.3.1',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('glue',         version = '1.3.1',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('vctrs',        version = '0.1.0',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('later',        version = '1.0.0',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('promises',     version = '1.1.0',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('curl',         version = '3.2',        repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('xml2',         version = '1.2.2',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('irlba',        version = '2.3.2',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('pillar',       version = '1.4.2',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('tibble',       version = '2.1.3',      repos = 'https://cloud.r-project.org/', upgrade = 'never')" && \
    R -e "remotes::install_version('purrr',        version = '0.2.5',      repos = 'https://cloud.r-project.org/', upgrade = 'never')" && \
    R -e "remotes::install_version('igraph',       version = '1.2.1',      repos = 'https://cloud.r-project.org/')" && \
    R -e "install.packages(c('slam','BH','stringr'), repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('rjson',        version = '0.2.20',     repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('NLP',          version = '0.2-0',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('hms',          version = '0.4.2',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('httr',        version = '1.4.2',      repos = 'https://cloud.r-project.org/')" && \
    R -e "install.packages(c('clipr'), repos = 'https://cloud.r-project.org/')"

## Step 2: App packages (order matters for dependencies)
## Install readtext deps first so pdftools/streamR/readxl/readODS build with system libs and rjson/httr available
RUN R -e "remotes::install_version('readxl',       version = '1.3.1',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('readODS',      version = '1.6.4',     repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('pdftools',      version = '3.7.0',     repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('streamR',       version = '0.4.5',     repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('readtext',     version = '0.75',       repos = 'https://cloud.r-project.org/', upgrade = 'never')" && \
    R -e "remotes::install_version('httpuv',       version = '1.5.2',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('htmltools',    version = '0.4.0',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('shiny',        version = '1.4.0',      repos = 'https://cloud.r-project.org/', upgrade = 'never')" && \
    R -e "remotes::install_version('xgboost',      version = '0.90.0.2',   repos = 'https://cloud.r-project.org/', upgrade = 'never')" && \
    R -e "remotes::install_version('mlapi',        version = '0.1.1',      repos = 'https://cloud.r-project.org/', upgrade = 'never')" && \
    R -e "remotes::install_version('text2vec',     version = '0.5.1',      repos = 'https://cloud.r-project.org/', upgrade = 'never')" && \
    R -e "remotes::install_version('tm',           version = '0.7-7',      repos = 'https://cloud.r-project.org/', upgrade = 'never')" && \
    R -e "remotes::install_version('readr',        version = '1.3.1',      repos = 'https://cloud.r-project.org/', upgrade = 'never')" && \
    R -e "remotes::install_version('SnowballC',    version = '0.6.0',      repos = 'https://cloud.r-project.org/', upgrade = 'never')" && \
    R -e "remotes::install_version('imager',       version = '0.42.1',     repos = 'https://cloud.r-project.org/', upgrade = 'never')"

## Step 3: RTextTools dependencies (R 3.4–compatible versions; SparseM 1.77 avoids diag generic issue)
RUN R -e "remotes::install_version('SparseM',      version = '1.77',       repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('randomForest', version = '4.6-12',     repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('tree',         version = '1.0-37',     repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('prodlim',      version = '1.6.1',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('ipred',        version = '0.9-9',      repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('caTools',      version = '1.17.1.1',   repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_version('maxent',       version = '1.3.3.1',    repos = 'https://cloud.r-project.org/', upgrade = 'never')" && \
    R -e "remotes::install_version('glmnet',       version = '2.0-16',     repos = 'https://cloud.r-project.org/')" && \
    R -e "install.packages(c('e1071','tau'), repos = 'https://cloud.r-project.org/')"

# --- App stage: only re-runs when you change app code or local R packages ---
FROM deps

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
