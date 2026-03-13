#!/usr/bin/env Rscript
# Check that all R packages required by the app are installed and loadable.
# Run inside the container: docker exec fake-news-detector-container Rscript /app/scripts/check_r_packages.R

# Packages explicitly loaded by the app (from library() in ui.R, server.R, nbase.r, etc.)
# "tools" is base R, so not listed.
required <- c(
  "readtext",
  "xgboost",
  "tm",
  "text2vec",
  "devtools",
  "readr",
  "SnowballC",
  "RTextTools",
  "FakeNewsDetector",
  "shiny",
  "NLP",
  "imager"
)

cat("Checking", length(required), "required packages...\n\n")

ok <- character(0)
failed <- character(0)

for (pkg in required) {
  loaded <- tryCatch(
    suppressPackageStartupMessages(require(pkg, character.only = TRUE, quietly = TRUE)),
    error = function(e) FALSE
  )
  if (loaded) {
    v <- as.character(packageVersion(pkg))
    cat("  OK   ", pkg, "(", v, ")\n")
    ok <- c(ok, pkg)
  } else {
    cat("  FAIL ", pkg, "\n")
    failed <- c(failed, pkg)
  }
}

cat("\n--- Summary ---\n")
cat("  Loaded:", length(ok), "/", length(required), "\n")
if (length(failed) > 0) {
  cat("  Missing or failed to load:", paste(failed, collapse = ", "), "\n")
  quit(status = 1)
}
cat("  All required packages are available.\n")
quit(status = 0)
