#!/usr/bin/env Rscript
# Install readtext and its dependencies with pinned versions inside a running container.
# Use: docker cp scripts/install_readtext_manual.R fake-news-detector-container:/tmp/install_readtext_manual.R
#      docker exec fake-news-detector-container Rscript /tmp/install_readtext_manual.R

options(repos = c(CRAN = "https://cloud.r-project.org/"))

install_one <- function(pkg, version, upgrade = "never") {
  cat("Installing", pkg, version, "... ")
  out <- tryCatch({
    if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes", quiet = TRUE)
    remotes::install_version(pkg, version = version, upgrade = upgrade, quiet = FALSE)
    cat("OK\n")
    TRUE
  }, error = function(e) {
    cat("FAIL:", conditionMessage(e), "\n")
    FALSE
  })
  invisible(out)
}

# Dependencies readtext needs (install in order; use same versions as list_of_packages.txt)
install_one("progress",   "1.2.2")
install_one("readODS",    "1.6.7")
install_one("readxl",     "1.3.1")
install_one("readtext",   "0.75")

# Verify
if (require("readtext", character.only = TRUE, quietly = TRUE)) {
  cat("\nreadtext", as.character(packageVersion("readtext")), "loaded successfully.\n")
  quit(status = 0)
} else {
  cat("\nreadtext failed to load.\n")
  quit(status = 1)
}
