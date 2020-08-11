## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  tidy = 'styler',
  collapse = TRUE,
  comment = "#>",
  cache = TRUE
)

## ----pkgsetup, echo=TRUE,eval=TRUE,message=FALSE,results="hide", warning=FALSE----
library(OncoRegimenFinder)
library(tidyverse)

## ----secretpkgsetup, echo=FALSE,eval=TRUE,message=FALSE,results="hide",warning=FALSE----
library(fantasia)
conn <- fantasia::connectOMOP()

## ----setupparameters, echo=TRUE,eval=TRUE-------------------------------------
# Schema for the Concept and Drug Exposure Tables
cdmDatabaseSchema <- "omop_cdm_2"

# Output Schema and Tables
writeDatabaseSchema <- "oncoregimenfinder"
drugExposureIngredientTable <- "ingredient_exposure"
vocabularyTable <- "vocabulary"


## ----vocabulary,eval=FALSE,echo=TRUE------------------------------------------
#  OncoRegimenFinder::createVocabTable(conn = conn,
#                   writeDatabaseSchema = writeDatabaseSchema,
#                   cdmDatabaseSchema = cdmDatabaseSchema,
#                   vocabularyTable = vocabularyTable)
#  

## ----vocabcount, echo=FALSE,eval=TRUE, print=TRUE-----------------------------
grep(pattern = paste0("^",vocabularyTable),
    pg13::lsTables(conn = conn,
                   schema = writeDatabaseSchema),
    ignore.case = T,
    value = TRUE) %>% 
        rubix::map_names_set(function(x) pg13::query(conn = conn,
                                          pg13::renderRowCount(schema = writeDatabaseSchema,
                                                   tableName = x))) %>% 
        dplyr::bind_rows(.id = "Table") %>% 
        dplyr::rename(RowCount = count)


## ----samplevocabulary, echo=FALSE, eval=TRUE, cache=TRUE----------------------
vocabularyTableData <-
  pg13::query(conn = conn,
              sql_statement = pg13::buildQuery(schema = writeDatabaseSchema,
                                               tableName = vocabularyTable,
                                               n = 20,
                                               n_type = "random"))

vocabularyTableData


## ----ingredientexposures, echo=TRUE,eval=FALSE--------------------------------
#  
#  OncoRegimenFinder::buildIngredientExposuresTable(conn = conn,
#                                                   cdmDatabaseSchema = cdmDatabaseSchema,
#                                                   writeDatabaseSchema = writeDatabaseSchema,
#                                                   drugExposureIngredientTable = drugExposureIngredientTable)
#  

## ----ingredientexposurescount, echo=FALSE,eval=TRUE---------------------------
grep(pattern = paste0("^",drugExposureIngredientTable),
    pg13::lsTables(conn = conn,
                   schema = writeDatabaseSchema),
    ignore.case = T,
    value = TRUE) %>% 
        rubix::map_names_set(function(x) pg13::query(conn = conn,
                                          pg13::renderRowCount(schema = writeDatabaseSchema,
                                                   tableName = x))) %>% 
        dplyr::bind_rows(.id = "Table") %>% 
        dplyr::rename(RowCount = count)

## ----sampleingredientexposure, eval=TRUE, echo=FALSE, cache=TRUE--------------

drugExposureIngredientTableData <-
  pg13::query(conn = conn,
              sql_statement = pg13::buildQuery(schema = writeDatabaseSchema,
                                               tableName = drugExposureIngredientTable,
                                               n = 20,
                                               n_type = "random"))

drugExposureIngredientTableData %>%
  dplyr::select(ingredient_concept_id,
                starts_with("drug_exposure"))


## ----dc1, echo=F, eval=TRUE, message="hide"-----------------------------------

fantasia::dcOMOP(conn = conn)


## ----pkgsetup2, echo=TRUE,eval=TRUE,message=FALSE,results="hide", warning=FALSE----
library(OncoRegimenFinder)
library(tidyverse)

## ----secretpkgsetup2, echo=FALSE,eval=TRUE,message=FALSE,results="hide",warning=FALSE----
library(fantasia)
conn <- fantasia::connectOMOP()

## ----setparameters2, eval=TRUE------------------------------------------------
# Schema of Source Person and Drug Exposure Tables
cdmDatabaseSchema <- "omop_cdm_2"

# Output Schema and Tables
writeDatabaseSchema <- "oncoregimenfinder"
drugExposureIngredientTable <- "ingredient_exposure"
cohortTable <- "cohort"
regimenTable <- "regimen"
regimenStagingTable <- "regimen_staging"
vocabularyTable <- "vocabulary"
regimenIngredientTable <- "regimen_ingredients"

# OMOP Vocabulary Drug Classes to filter Drug Exposures for
drug_classification_id_input <- c(#ATC Antineoplastics (OncoRegimenFinder::atc_antineoplastics_id)
                                 21601387, 
                                 #HemOnc Classes (OncoRegimenFinder::hemonc_classes)
                                 35101847, 
                                 35807195, 
                                 35807466, 
                                 35807470, 
                                 35807489)
false_positive_id <- 
                #OncoRegimenFinder::falsepositives
                c(45775396, 1304850, 792993, 19010482, 19089602, 
                  19080458, 19104221, 19065450, 1510328, 42903942, 
                  1354698, 1551860, 19003472, 1356009, 40244464, 
                  1303425, 745466, 1389464, 19025194, 740910, 1710612, 
                  35606631, 19003999, 985708, 45775206, 1308432, 1522957, 
                  1760616, 950637, 1300978, 44816310, 1500211, 1506270, 
                  923645, 19061406, 40171288, 1388796, 40168303, 975125, 
                  1507705, 1511449, 1738521, 1548195, 1518254, 40222444, 
                  1713332, 1112807, 19014878, 19034726, 984232, 1525866, 
                  989482, 1550557, 1551099, 924120, 904351)

# Date difference when assessing for drug combinations in the Drug Exposures table
date_lag_input <- 30
regimen_repeats <- 5


## ----cohortregimentables, eval=FALSE, echo=TRUE-------------------------------
#  OncoRegimenFinder::buildCohortRegimenTable(conn = conn,
#                                             cdmDatabaseSchema = cdmDatabaseSchema,
#                                             writeDatabaseSchema = writeDatabaseSchema,
#                                             cohortTable = cohortTable,
#                                             regimenTable = regimenTable,
#                                             drug_classification_id_input = drug_classification_id_input,
#                                             false_positive_id = false_positive_id)

## ----cohort, eval=TRUE, echo=FALSE, cache=TRUE--------------------------------

cohortTableData <-
  pg13::query(conn = conn,
              sql_statement = pg13::buildQuery(schema = writeDatabaseSchema,
                                               tableName = cohortTable,
                                               n = 20,
                                               n_type = "random"))

cohortTableData


## ----cohortcount, echo=FALSE,eval=TRUE----------------------------------------
grep(pattern = cohortTable,
    pg13::lsTables(conn = conn,
                   schema = writeDatabaseSchema),
    ignore.case = T,
    value = TRUE) %>% 
        rubix::map_names_set(function(x) pg13::query(conn = conn,
                                          pg13::renderRowCount(schema = writeDatabaseSchema,
                                                   tableName = x))) %>% 
        dplyr::bind_rows(.id = "Table") %>% 
        dplyr::rename(RowCount = count)
  


## ---- echo=FALSE, eval=TRUE,cache=TRUE----------------------------------------

regimenStagingTableData <-
  pg13::query(conn = conn,
              sql_statement = pg13::buildQuery(schema = writeDatabaseSchema,
                                               tableName = regimenStagingTable,
                                               n = 20,
                                               n_type = "random"))

regimenStagingTableData


## ----regimenstagingcount, echo=FALSE, eval=TRUE-------------------------------

grep(pattern = regimenStagingTable,
    pg13::lsTables(conn = conn,
                   schema = writeDatabaseSchema),
    ignore.case = T,
    value = TRUE) %>% 
        rubix::map_names_set(function(x) pg13::query(conn = conn,
                                          pg13::renderRowCount(schema = writeDatabaseSchema,
                                                   tableName = x))) %>% 
        dplyr::bind_rows(.id = "Table") %>% 
        dplyr::rename(RowCount = count)


## ----processregimen, eval=FALSE,echo=TRUE-------------------------------------
#  
#  OncoRegimenFinder::processRegimenTable(conn = conn,
#                      writeDatabaseSchema = writeDatabaseSchema,
#                      regimenTable = regimenTable,
#                      date_lag_input = date_lag_input,
#                      regimen_repeats = regimen_repeats)
#  

## ----sampleregimen, echo=FALSE, eval=TRUE, cache=TRUE-------------------------

regimenTableData <-
  pg13::query(conn = conn,
              sql_statement = pg13::buildQuery(schema = writeDatabaseSchema,
                                               tableName = regimenTable,
                                               n = 20,
                                               n_type = "random"))

regimenTableData


## ----regimencount, echo=FALSE, eval=TRUE--------------------------------------
grep(pattern = paste(regimenStagingTable, regimenIngredientTable, sep = "|"),
    pg13::lsTables(conn = conn,
                   schema = writeDatabaseSchema),
    ignore.case = T,
    value = TRUE,
    invert = TRUE) %>% 
  purrr::map(function(x) grep(regimenTable, x, ignore.case = T, value = TRUE)) %>% 
  purrr::keep(~length(.)==1) %>% 
  unlist() %>% 
  rubix::map_names_set(function(x) pg13::query(conn = conn,
                                          pg13::renderRowCount(schema = writeDatabaseSchema,
                                                   tableName = x))) %>% 
        dplyr::bind_rows(.id = "Table") %>% 
        dplyr::rename(RowCount = count)


## ----regingr, eval=FALSE, echo = TRUE-----------------------------------------
#  createRegimenIngrTable(conn = conn,
#                         writeDatabaseSchema = "patelm9",
#                         cohortTable = "oncoregimenfinder_cohort",
#                         regimenTable = "oncoregimenfinder_regimen",
#                         regimenIngredientTable = "oncoregimenfinder_regimen_ingredients",
#                         vocabularyTable = "oncoregimenfinder_vocabulary")

## ----sampleregingr, echo=FALSE, eval=TRUE, cache=TRUE-------------------------

regimenIngrTableData <-
  pg13::query(conn = conn,
              sql_statement = pg13::buildQuery(schema = writeDatabaseSchema,
                                               tableName = regimenIngredientTable,
                                               n = 20,
                                               n_type = "random"))

regimenIngrTableData


## ----regingrcount, echo=FALSE, eval=TRUE--------------------------------------

grep(pattern = regimenIngredientTable,
    pg13::lsTables(conn = conn,
                   schema = writeDatabaseSchema),
    ignore.case = T,
    value = TRUE) %>% 
        rubix::map_names_set(function(x) pg13::query(conn = conn,
                                          pg13::renderRowCount(schema = writeDatabaseSchema,
                                                   tableName = x))) %>% 
        dplyr::bind_rows(.id = "Table") %>% 
        dplyr::rename(RowCount = count)


## ----dc2,echo=FALSE,eval=TRUE,message=FALSE,results="hide"--------------------
fantasia::dcOMOP(conn = conn,
                 remove = TRUE)

