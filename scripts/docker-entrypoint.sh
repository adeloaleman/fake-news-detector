#!/bin/bash
set -e
# Install any packages listed in /app/extra-packages.txt (one per line). Use this to fix
# "there is no package called 'X'" without rebuilding the image: add X to extra-packages.txt
# and restart the container (run with -v "$(pwd):/app" so the file is visible).
if [ -f /app/extra-packages.txt ] && [ -s /app/extra-packages.txt ]; then
  echo "Installing extra packages from extra-packages.txt..."
  R -e "options(repos='https://cloud.r-project.org/'); pkg <- readLines('/app/extra-packages.txt'); pkg <- trimws(pkg); pkg <- pkg[nzchar(pkg) & !startsWith(pkg, '#')]; if (length(pkg)) install.packages(pkg, dependencies=TRUE)"
fi
exec R -e "shiny::runApp('/app', host='0.0.0.0', port=3838)"
