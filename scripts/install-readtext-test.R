#!/usr/bin/env Rscript
# Test script: install only what's needed for readtext 0.75. Run inside the
# readtext-test container. Edit this file and re-run (no Docker rebuild).
# Exit 1 on any failure so "docker run" fails and you see the error.

options(repos = "https://cloud.r-project.org/")
options(error = function() quit(status = 1, save = "no"))

message("Installing remotes...")
install.packages("remotes", repos = "https://cloud.r-project.org/")

message("Installing CRAN deps (progress, cellranger, digest, stringi, etc.)...")
install.packages(c(
  "progress", "cellranger", "digest", "stringi",
  "RCurl", "data.table", "bitops", "base64enc"
), repos = "https://cloud.r-project.org/")

message("Installing pillar, tibble, readr...")
remotes::install_version("pillar",   version = "1.4.2", repos = "https://cloud.r-project.org/", upgrade = "never")
remotes::install_version("tibble",   version = "2.1.3", repos = "https://cloud.r-project.org/", upgrade = "never")
remotes::install_version("readr",    version = "1.3.1", repos = "https://cloud.r-project.org/", upgrade = "never")

message("Installing readxl 1.3.1...")
remotes::install_version("readxl",   version = "1.3.1", repos = "https://cloud.r-project.org/", upgrade = "never")

message("Installing readtext 0.75 (and its deps: striprtf, antiword, etc.)...")
remotes::install_version("readtext", version = "0.75",  repos = "https://cloud.r-project.org/", upgrade = "never")

message("Loading readtext...")
library(readtext)
message("readtext OK")
quit(status = 0, save = "no")
