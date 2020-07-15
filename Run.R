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
               writeDatabaseSchema = "patelm9",
               cohortTable = "oncoregimenfinder_cohort",
               regimenTable = "oncoregimenfinder_regimen",
               regimenIngredientTable = "oncoregimenfinder_regimen_ingredients",
               vocabularyTable = "ncoregimenfinder_vocab",
               drug_classification_id_input = 21601387,
               date_lag_input = 30,
               regimen_repeats = 5,
               generateVocabTable = T)
