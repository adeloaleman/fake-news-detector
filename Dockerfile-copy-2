FROM rocker/r-ver:4.2.3

ENV DEBIAN_FRONTEND=noninteractive

# System libraries required by many R packages
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
    qpdf \
    antiword \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# Set CRAN mirror to latest snapshot for reproducibility
RUN echo "options(repos = c(CRAN='https://cran.rstudio.com'))" >> /usr/local/lib/R/etc/Rprofile.site

# Install R packages in blocks to reduce layers
RUN R -e "install.packages(c('antiword','askpass','assertthat','backports','BH','bitops','bmp','brew','Cairo','callr','caTools','cellranger','cli','clipr','clisymbols','colorspace','commonmark','covr','crayon','crosstalk'), dependencies=TRUE, Ncpus=4)"
RUN R -e "install.packages(c('curl','data.table','desc','devtools','digest','downloader','DT','e1071','ellipsis','evaluate','fansi','farver','fastmap','foreach','formatR','fs','futile.logger','futile.options','ggplot2','gh','git2r'), dependencies=TRUE, Ncpus=4)"
RUN R -e "install.packages(c('glmnet','glue','gtable','hms','htmltools','htmlwidgets','httpuv','httr','igraph','imager','ini','ipred','irlba','iterators','jpeg','jsonlite','labeling','lambda.r','later','lava'), dependencies=TRUE, Ncpus=4)"
RUN R -e "install.packages(c('lazyeval','lifecycle','magrittr','maxent','memoise','mime','mlapi','munsell','ndjson','NLP','numDeriv','openssl','pdftools','pillar','pkgbuild','pkgconfig','pkgload','plyr','png','praise','prettyunits'), dependencies=TRUE, Ncpus=4)"
RUN R -e "install.packages(c('processx','prodlim','progress','promises','ps','purrr','qpdf','R6','randomForest','rcmdcheck','RColorBrewer','Rcpp','RcppParallel','RCurl','readbitmap','readODS','readr','readtext','readxl','rematch'), dependencies=TRUE, Ncpus=4)"
RUN R -e "install.packages(c('remotes','reshape2','rex','rjson','rlang','roxygen2','rprojroot','rstudioapi','rversions','scales','sessioninfo','shiny','slam','SnowballC','sourcetools','SparseM','sparsepp','SQUAREM','streamR','stringi'), dependencies=TRUE, Ncpus=4)"
RUN R -e "install.packages(c('stringr','striprtf','sys','tau','testthat','text2vec','tibble','tiff','tm','tree','usethis','utf8','vctrs','viridisLite','whisker','withr','xgboost','xml2','xopen','xtable','yaml'), dependencies=TRUE, Ncpus=4)"