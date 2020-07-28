conn <- fantasia::connectOMOP()
# Tables <- c("oncoregimenfinder_cohort",
#             "oncoregimenfinder_regimen",
#             "oncoregimenfinder_regimen_staging",
#             "oncoregimenfinder_vocabulary",
#             "oncoregimenfinder_regimen_ingredients")
# 
# Tables %>%
#         purrr::map(function(x) pg13::dropTable(conn = conn,
#                                                schema = "patelm9",
#                                                tableName = x))

# settings <- 
#         list(cdmDatabaseSchema = "omop_cdm_2",
#              writeDatabaseSchema = "patelm9",
#              cohortTable = "oncoregimenfinder_cohort",
#              regimenTable = "oncoregimenfinder_regimen",
#              vocabularyTable = "oncoregimenfinder_vocabulary",
#              regimenIngredientTable= "oncoregimenfinder_regimen_ingredients",
#              drug_classification_id_input = c(21601387,
#                                               35807188,
#                                               35807277,
#                                               35807189),
#              date_lag_input = 30,
#              regimen_repeats = 5)
# 
OncoRegimenFinder::buildCohortRegimenTable(conn = conn,
                                           cdmDatabaseSchema = "omop_cdm_2",
                                           writeDatabaseSchema = "patelm9",
                                           cohortTable = "oncoregimenfinder_cohort",
                                           regimenTable = "oncoregimenfinder_regimen",
                                           drug_classification_id_input = c(21601387,
                                                                            35807188,
                                                                            35807277,
                                                                            35807189))
OncoRegimenFinder::processRegimenTable(conn = conn,
                    writeDatabaseSchema = "patelm9",
                    regimenTable = "oncoregimenfinder_regimen",
                    date_lag_input = 30,
                    regimen_repeats = 5)
# 
OncoRegimenFinder::createVocabTable(conn = conn,
                                    writeDatabaseSchema = "patelm9",
                                    cdmDatabaseSchema = "omop_cdm_2",
                                    vocabularyTable = "oncoregimenfinder_vocabulary")
# 
OncoRegimenFinder::createRegimenIngrTable(conn = conn,
                                          writeDatabaseSchema = "patelm9",
                                          cohortTable = "oncoregimenfinder_cohort",
                                          regimenTable = "oncoregimenfinder_regimen",
                                          regimenIngredientTable = "oncoregimenfinder_regimen_ingredients",
                                          vocabularyTable = "oncoregimenfinder_vocabulary")
fantasia::dcOMOP(conn = conn)
