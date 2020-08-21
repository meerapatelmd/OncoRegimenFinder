# Connection Object
library(DatabaseConnector)
conn_details <- DatabaseConnector::createConnectionDetails(dbms = "postgresql",
                                                           user, 
                                                           password,
                                                           port = "5432", 
                                                           server)
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
