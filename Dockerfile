FROM rocker/r-ver:3.4.4

ENV DEBIAN_FRONTEND=noninteractive

# System libraries required by R packages
RUN apt-get update && apt-get install -y \
    build-essential \
    gfortran \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libcairo2-dev \
    libxt-dev \
    libglu1-mesa-dev \
    libgl1-mesa-dev \
    libv8-dev \
    libpoppler-cpp-dev \
    libglpk-dev \
    libmagick++-dev \
    libudunits2-dev \
    qpdf \
    antiword \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# Freeze CRAN snapshot to match R 3.4.4 era
RUN echo "options(repos = c(CRAN='https://mran.microsoft.com/snapshot/2018-03-15'))" >> /usr/local/lib/R/etc/Rprofile.site

# Install all R packages in one go with progress messages
RUN R -e "packages <- c(
'antiword','askpass','assertthat','backports','BH','bitops','bmp','brew','Cairo','callr','caTools','cellranger',
'cli','clipr','clisymbols','colorspace','commonmark','covr','crayon','crosstalk','curl','data.table','desc',
'devtools','digest','downloader','DT','e1071','ellipsis','evaluate','fansi','farver','fastmap','foreach',
'formatR','fs','futile.logger','futile.options','ggplot2','gh','git2r','glmnet','glue','gtable','hms',
'htmltools','htmlwidgets','httpuv','httr','igraph','imager','ini','ipred','irlba','iterators','jpeg',
'jsonlite','labeling','lambda.r','later','lava','lazyeval','lifecycle','magrittr','maxent','memoise','mime',
'mlapi','munsell','ndjson','NLP','numDeriv','openssl','pdftools','pillar','pkgbuild','pkgconfig','pkgload',
'plyr','png','praise','prettyunits','processx','prodlim','progress','promises','ps','purrr','qpdf','R6',
'randomForest','rcmdcheck','RColorBrewer','Rcpp','RcppParallel','RCurl','readbitmap','readODS','readr',
'readtext','readxl','rematch','remotes','reshape2','rex','rjson','rlang','roxygen2','rprojroot','rstudioapi',
'rversions','scales','sessioninfo','shiny','slam','SnowballC','sourcetools','SparseM','sparsepp','SQUAREM',
'streamR','stringi','stringr','striprtf','sys','tau','testthat','text2vec','tibble','tiff','tm','tree',
'usethis','utf8','vctrs','viridisLite','whisker','withr','xgboost','xml2','xopen','xtable','yaml'
)
for (pkg in packages) {
  cat('Installing package:', pkg, '\n')
  install.packages(pkg, dependencies=TRUE, Ncpus=4)
}"
