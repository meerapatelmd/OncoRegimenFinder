## code to prepare `false-positive-oncology-drugs` dataset goes here
library(devtools)
devtools::install_github("patelm9/broca")
library(broca)
topclasses <- broca::simply_read_csv("data-raw/topclasses.csv")

usethis::use_data(topclasses, overwrite = TRUE)
