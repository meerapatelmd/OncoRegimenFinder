## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  tidy = 'styler',
  collapse = TRUE,
  comment = "#>",
  cache = TRUE
)

## ----setup, eval=TRUE,echo=TRUE-----------------------------------------------
library(OncoRegimenFinder)

## ----parameters, echo=TRUE,eval=TRUE------------------------------------------
cdmDatabaseSchema <- "omop_cdm_2"
writeDatabaseSchema <- "oncoregimenfinder"
vocabularyTable <- "vocabulary"
drugExposureIngredientTable <- "ingredient_exposure"
regimenTable <- "regimen"
cohortTable <- "cohort"
regimenIngredientTable <- "regimen_ingredient"

## ----run,eval=FALSE,echo=TRUE-------------------------------------------------
#  runORF(conn = conn,
#         cdmDatabaseSchema = cdmDatabaseSchema,
#         writeDatabaseSchema = writeDatabaseSchema,
#         vocabularyTable = vocabularyTable,
#         drugExposureIngredientTable = drugExposureIngredientTable,
#         cohortTable = cohortTable,
#         regimenTable = regimenTable,
#         regimenIngredientTable = regimenIngredientTable)

