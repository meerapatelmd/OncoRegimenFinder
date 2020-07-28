# conn <- fantasia::connectOMOP()
# OncoRegimenFinder::buildCohortRegimenTable(conn = conn,
#                                            cdmDatabaseSchema = "omop_cdm_2",
#                                            writeDatabaseSchema = "patelm9",
#                                            cohortTable = "oncoregimenfinder_cohort",
#                                            regimenTable = "oncoregimenfinder_regimen",
#                                            drug_classification_id_input = c(21601387,
#                                                                             35807188,
#                                                                             35807277,
#                                                                             35807189))
# 
# OncoRegimenFinder::processRegimenTable(conn = conn,
#                     writeDatabaseSchema = "patelm9",
#                     regimenTable = "oncoregimenfinder_regimen",
#                     date_lag_input = 30,
#                     regimen_repeats = 5)
# 
# OncoRegimenFinder::createVocabTable(conn = conn,
#                                     writeDatabaseSchema = "patelm9",
#                                     cdmDatabaseSchema = "omop_cdm_2",
#                                     vocabularyTable = "oncoregimenfinder_vocabulary")
# 
# fantasia::dcOMOP(conn = conn)
