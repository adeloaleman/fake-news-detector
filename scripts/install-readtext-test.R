#!/usr/bin/env Rscript
# Test script: same install order as main Dockerfile so readtext works.
# Run inside readtext-test container. Edit and re-run without rebuilding image.
# Exit 1 on any failure.

options(repos = "https://cloud.r-project.org/")
options(error = function() quit(status = 1, save = "no"))
R <- "https://cloud.r-project.org/"
uv <- "never"

message("1) remotes...")
install.packages("remotes", repos = R)

message("2) Step 1 base (Rcpp, rlang, vctrs, pillar, tibble, curl, xml2, httr, rjson, ...)...")
remotes::install_version("Rcpp",    "1.0.1",   repos = R)
remotes::install_version("R6",     "2.4.0",   repos = R)
remotes::install_version("rlang",  "0.3.1",   repos = R)
remotes::install_version("glue",   "1.3.1",   repos = R)
remotes::install_version("vctrs",   "0.1.0",   repos = R)
remotes::install_version("later",  "1.0.0",   repos = R)
remotes::install_version("promises", "1.1.0", repos = R)
remotes::install_version("curl",   "2.8.1",   repos = R, upgrade = uv)
remotes::install_version("xml2",   "1.2.2",   repos = R)
remotes::install_version("pillar", "1.4.2",   repos = R, upgrade = uv)
remotes::install_version("tibble", "2.1.3",   repos = R, upgrade = uv)
remotes::install_version("purrr",  "0.2.5",   repos = R, upgrade = uv)
install.packages(c("slam", "BH"), repos = R)
remotes::install_version("stringr", "1.3.1", repos = R)
remotes::install_version("rjson",  "0.2.20",  repos = R)
remotes::install_version("hms",    "0.4.2",   repos = R)
remotes::install_version("httr",   "1.4.2",   repos = R, upgrade = uv)
install.packages("clipr", repos = R)

message("3) Step 2a: progress (pinned for R 3.4), cellranger, RCurl, data.table, bitops, base64enc, digest, stringi...")
remotes::install_version("progress", "1.2.2", repos = R, upgrade = uv)
install.packages(c("cellranger", "RCurl", "data.table", "bitops", "base64enc", "digest", "stringi"), repos = R)

message("4) Step 2b: readr, readODS, pdftools, streamR, readxl, readtext...")
remotes::install_version("readr",    "1.3.1",  repos = R, upgrade = uv)
remotes::install_version("readODS",  "1.6.4",  repos = R, upgrade = uv)
remotes::install_version("pdftools", "3.7.0",  repos = R, upgrade = uv)
remotes::install_version("streamR",  "0.4.5",  repos = R, upgrade = uv)
remotes::install_version("readxl",   "1.3.1",  repos = R, upgrade = uv)
remotes::install_version("readtext", "0.75",   repos = R, upgrade = uv)

message("5) Load readtext...")
library(readtext)
message("readtext OK")
quit(status = 0, save = "no")
