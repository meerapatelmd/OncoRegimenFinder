library(DatabaseConnector)
library(SqlRender)
source('R/file.R')

connectionDetails <-  DatabaseConnector::createConnectionDetails(dbms = "postgresql",
                                                                 server = "dlvidhiomop1.mskcc.org/omop_raw",
                                                                 user = Sys.getenv("omop_username"),
                                                                 password = Sys.getenv("omop_password"),
                                                                 port = 5432)

create_regimens(connectionDetails = connectionDetails,
               cdmDatabaseSchema = "omop_cdm_2",
               # Where the cohort table is located with: cohort_definition_id, subject_id, cohort_start_date, cohort_end_date
               cdmResultSchema = "omop_cdm_results_2",
               writeDatabaseSchema = "onco_regimen_finder_test",
               cohortTable = "test_cohort",
               regimenTable = "test_regimens",
               regimenIngredientTable = "test_regimen_ingredients",
               vocabularyTable = "regimen_voc_upd2",
               drug_classification_id_input = 21601387,
               date_lag_input = 30,
               regimen_repeats = 5,
               cohortDefinitionId = 7,
               generateVocabTable = T)
