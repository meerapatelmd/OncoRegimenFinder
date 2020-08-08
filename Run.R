# settings <-
#         list(cdmDatabaseSchema = "omop_cdm_2",
#              writeDatabaseSchema = "patelm9",
#              cohortTable = "oncoregimenfinder_cohort",
#              regimenTable = "oncoregimenfinder_regimen",
#              drugExposureIngredientTable = "ingredient_exposures",
#              vocabularyTable = "oncoregimenfinder_vocabulary",
#              regimenIngredientTable= "oncoregimenfinder_regimen_ingredients",
#              drug_classification_id_input = c(21601387,
#                                               35807188,
#                                               35807277,
#                                               35807189),
#              date_lag_input = 30,
#              regimen_repeats = 5)
# 
# Schema of Source Person and Drug Exposure Tables
# cdmDatabaseSchema <- "omop_cdm_2"
# 
# # Output Schema and Tables
# writeDatabaseSchema <- "patelm9"
# drugExposureIngredientTable <- "ingredient_exposure"
# cohortTable <- "oncoregimenfinder_cohort"
# regimenTable <- "oncoregimenfinder_regimen"
# regimenStagingTable <- "oncoregimenfinder_regimen_staging"
# vocabularyTable <- "oncoregimenfinder_vocabulary"
# regimenIngredientTable <- "oncoregimenfinder_regimen_ingredients"
# 
# # OMOP Vocabulary Drug Classes to filter Drug Exposures for
# drug_classification_id_input <- c(OncoRegimenFinder::atc_antineoplastic_id,
#                                   OncoRegimenFinder::hemonc_classes)
# false_positive_id <- OncoRegimenFinder::falsepositives
# 
# # Date difference when assessing for drug combinations in the Drug Exposures table
# date_lag_input <- 30
# regimen_repeats <- 5
# 
conn <- fantasia::connectOMOP()
testbuildCohortRegimenTable(conn = conn,
                            cdmDatabaseSchema = "omop_cdm_2",
                            writeDatabaseSchema = "patelm9",
                            cohortTable = cohortTable,
                            regimenTable = regimenTable,
                            drugExposureIngredientTable = drugExposureIngredientTable)
fantasia::dcOMOP(conn = conn,
                 remove = TRUE)
