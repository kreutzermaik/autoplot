#!/bin/bash
R -e "install.packages(c('ggplot2', 'viridis', 'dplyr', 'hms', 'gridExtra', 'ggpubr', 'rmarkdown', 'psych', 'devtools', 'R.utils'), repos='https://ftp.gwdg.de/pub/misc/cran/');library(devtools);install_github('trestletech/shinyStore')"
