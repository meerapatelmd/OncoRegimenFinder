# Connection Object
devtools::load_all()
library(DatabaseConnector)
library(dplyr) 
conn_details <- DatabaseConnector::createConnectionDetails(dbms = "postgresql",
                                                           server = "dlvidhiomop1.mskcc.org/omop_raw",
                                                           user = "oncoregimenfinder",
                                                           password = "jBTHOTCwKpy3",
                                                           port = "5432")
conn <- DatabaseConnector::connect(conn_details)

# Settings
cdmDatabaseSchema <- "omop_cdm_2"
writeDatabaseSchema <- "oncoregimenfinder"
vocabularyTable <- "vocabulary"
drugExposureIngredientTable <- "ingredient_exposure"
regimenTable <- "regimen"
cohortTable <- "cohort"
regimenIngredientTable <- "regimen_ingredient"

runORF(conn = conn,
       cdmDatabaseSchema = cdmDatabaseSchema,
       writeDatabaseSchema = writeDatabaseSchema,
       vocabularyTable = vocabularyTable,
       drugExposureIngredientTable = drugExposureIngredientTable,
       cohortTable = cohortTable,
       regimenTable = regimenTable,
       regimenIngredientTable = regimenIngredientTable)
