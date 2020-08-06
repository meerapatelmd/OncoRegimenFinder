## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(OncoRegimenFinder)

## ---- echo=FALSE,eval=TRUE,message=FALSE,results="hide"-----------------------
library(fantasia)
conn <- fantasia::connectOMOP()

## ----settings, eval=FALSE-----------------------------------------------------
#  # Schema of Source Person and Drug Exposure Tables
#  cdmDatabaseSchema = "omop_cdm_2"
#  
#  # Output Schema and Tables
#  writeDatabaseSchema = "patelm9"
#  cohortTable = "oncoregimenfinder_cohort"
#  regimenTable = "oncoregimenfinder_regimen"
#  regimenStagingTable = "oncoregimenfinder_regimen_staging"
#  vocabularyTable = "oncoregimenfinder_vocabulary"
#  regimenIngredientTable= "oncoregimenfinder_regimen_ingredients"
#  
#  # OMOP Vocabulary Drug Classes to filter Drug Exposures for
#  drug_classification_id_input = c(21601387,
#                                  35807188,
#                                  35807277,
#                                  35807189)
#  
#  # Date difference when assessing for drug combinations in the Drug Exposures table
#  date_lag_input = 30
#  regimen_repeats = 5
#  

## ---- eval=FALSE--------------------------------------------------------------
#  
#  OncoRegimenFinder::buildCohortRegimenTable(conn = conn,
#                                             cdmDatabaseSchema = "omop_cdm_2",
#                                             writeDatabaseSchema = "patelm9",
#                                             cohortTable = "oncoregimenfinder_cohort",
#                                             regimenTable = "oncoregimenfinder_regimen",
#                                             drug_classification_id_input = c(21601387,
#                                                                              35807188,
#                                                                              35807277,
#                                                                              35807189))

## ----cohortTable, eval=TRUE, echo=FALSE---------------------------------------

cohortTable <-
  pg13::query(conn = conn,
              sql_statement = pg13::buildQuery(schema = "patelm9",
                                               tableName = "oncoregimenfinder_cohort",
                                               n = 20,
                                               n_type = "random"))

print(cohortTable)


## ---- echo=FALSE, eval=TRUE---------------------------------------------------

regimenStagingTable <-
  pg13::query(conn = conn,
              sql_statement = pg13::buildQuery(schema = "patelm9",
                                               tableName = "oncoregimenfinder_regimen_staging",
                                               n = 20,
                                               n_type = "random"))

print(regimenStagingTable)


## ---- eval=FALSE,echo=TRUE----------------------------------------------------
#  
#  OncoRegimenFinder::processRegimenTable(conn = conn,
#                      writeDatabaseSchema = "patelm9",
#                      regimenTable = "oncoregimenfinder_regimen",
#                      date_lag_input = 30,
#                      regimen_repeats = 5)
#  

## ---- echo=FALSE, eval=TRUE---------------------------------------------------

regimenTable <-
  pg13::query(conn = conn,
              sql_statement = pg13::buildQuery(schema = "patelm9",
                                               tableName = "oncoregimenfinder_regimen",
                                               n = 20,
                                               n_type = "random"))

print(regimenTable)


## ---- eval=FALSE,echo=TRUE----------------------------------------------------
#  
#  OncoRegimenFinder::createVocabTable(conn = conn,
#                                      writeDatabaseSchema = "patelm9",
#                                      cdmDatabaseSchema = "omop_cdm_2",
#                                      vocabularyTable = "oncoregimenfinder_vocabulary")
#  

## ---- echo=FALSE, eval=TRUE---------------------------------------------------

vocabularyTable <-
  pg13::query(conn = conn,
              sql_statement = pg13::buildQuery(schema = "patelm9",
                                               tableName = "oncoregimenfinder_vocabulary",
                                               n = 20,
                                               n_type = "random"))

print(vocabularyTable)


## ---- eval=FALSE, echo = TRUE-------------------------------------------------
#  createRegimenIngrTable(conn = conn,
#                         writeDatabaseSchema = "patelm9",
#                         cohortTable = "oncoregimenfinder_cohort",
#                         regimenTable = "oncoregimenfinder_regimen",
#                         regimenIngredientTable = "oncoregimenfinder_regimen_ingredients",
#                         vocabularyTable = "oncoregimenfinder_vocabulary")

## ---- echo=FALSE, eval=TRUE---------------------------------------------------
regimenIngrTable <-
  pg13::query(conn = conn,
              sql_statement = pg13::buildQuery(schema = "patelm9",
                                               tableName = "oncoregimenfinder_regimen_ingredients",
                                               n = 20,
                                               n_type = "random"))

print(regimenIngrTable)


## ----echo=FALSE,eval=TRUE,message=FALSE,results="hide"------------------------
fantasia::dcOMOP(conn = conn,
                 remove = TRUE)

