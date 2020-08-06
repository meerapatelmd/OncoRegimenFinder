## code to prepare `false-positive-oncology-drugs` dataset goes here
library(devtools)
devtools::install_github("patelm9/broca")
devtools::install_github("patelm9/chariot")

library(broca)

topclasses <- broca::simply_read_csv("data-raw/topclasses.csv")
falsepositives <- broca::simply_read_csv("data-raw/falsepositives.csv")
falsepositives <- falsepositives$concept_id

atc_antineoplastic_id <- 21601387

hemonc_classes <- c(35101847, 35807195, 35807466, 35807470, 35807489)
names(hemonc_classes) <- c('Anti-CD79B antibody', 'Investigational drug', 'Drugs by class effect', 'Site-specific medication', 'Site-agnostic medication')


usethis::use_data(atc_antineoplastic_id, hemonc_classes, topclasses, falsepositives, overwrite = TRUE)
