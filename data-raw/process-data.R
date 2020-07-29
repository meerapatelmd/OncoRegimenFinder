## code to prepare `false-positive-oncology-drugs` dataset goes here
library(devtools)
devtools::install_github("patelm9/broca")
library(broca)
topclasses <- broca::simply_read_csv("data-raw/topclasses.csv")
falsepositives <- broca::simply_read_csv("data-raw/falsepositives.csv")
usethis::use_data(topclasses, falsepositives, overwrite = TRUE)
