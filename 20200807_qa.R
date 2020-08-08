# library(tidyverse)
# library(rlang)
# # conn <- fantasia::connectOMOP()
# # Get all Vocabulary Id and Concept Class Ids for the Drug Exposures
# deConceptType <- 
#         pg13::query(conn = conn,
#                     sql_statement = pg13::buildQuery(fields = "drug_concept_id",
#                                                      distinct = TRUE,
#                                                      schema = "omop_cdm_2",
#                                                      tableName = "drug_exposure"))
# 
# deConceptType2 <-
# chariot::leftJoinConcept(deConceptType,
#                          athena_schema = "public") %>% 
#         dplyr::select(domain_id,
#                       vocabulary_id,
#                       concept_class_id) %>% 
#         distinct()
# 
# deConceptType3 <- 
#         deConceptType2 %>% 
#         dplyr::select(concept_class_id_1 = concept_class_id) %>% 
#         dplyr::distinct()
# 
# RxNormIngredientRelationships <-
# chariot::queryConceptClassRelationships("RxNorm") %>% 
#         dplyr::filter(concept_class_id_2 == "Ingredient")
# 
# 
# dplyr::left_join(deConceptType3,
#                  RxNormIngredientRelationships) %>% 
#         broca::view_as_csv()
# 
# # Relationships won't work, so need to try relatives
# 
# # Getting concept ids for all the Drug Exposures Concept Classes
# 
# deConcepts <-
# chariot::queryAthena(
# pg13::buildQuery(schema = "public",
#                  tableName = "concept",
#                  whereInField = "concept_class_id",
#                  whereInVector = deConceptType3$concept_class_id_1)
# ) %>% 
#         chariot::filter_for_rxnorm()
# 
# # Do these concepts have an `Ingredient` relative?
# deConceptsRelatives <- 
#         chariot::pivotRelative(deConceptType,
#                                names_from = "concept_class_id")
# head(deConceptsRelatives)
# 
# noIngredient <- 
# deConceptsRelatives %>% 
#         dplyr::filter(is.na(`Ingredient Count`)) %>% 
#         dplyr::select(drug_concept_id, contains("Ingredient")) %>% 
#         rubix::format_colnames() %>%
#         chariot::leftJoinConcept() %>% 
#         dplyr::select(-drug_concept_id) %>% 
#         chariot::mergeStrip(into = "Drug Exposure") %>% 
#         dplyr::select(`Drug Exposure`,
#                       contains("ingredient")) %>% 
#         dplyr::filter(!is.na(`Drug Exposure`))
# 
# deConceptsLevel <- 
#         chariot::pivotLevel(deConceptType)
# 
# deConceptsLevel2 <-
#         deConceptsLevel %>% 
#         dplyr::select(-contains("Count")) %>%
#         tidyr::pivot_longer(cols = !drug_concept_id,
#                             names_to = c("RelativeType", "RelativeLevel"),
#                             names_pattern = "([AD])[_]{1}([0-9]{1,}$)",
#                             values_to = "Concept",
#                             values_drop_na = TRUE) %>%
#         tidyr::separate_rows(Concept,
#                              sep = "\n")
# 
# deConcepts4 <-
# chariot::filterAtStrip(deConceptsLevel,
#                        merge_cols = c('A_9', 'A_8', 'A_7', 'A_6', 'A_5', 'A_4', 'A_3', 'A_2', 'A_1', 'A_0', 'A_NA', 'D_0', 'D_1', 'D_2', 'D_3', 'D_4', 'D_5', 'D_6'),
#                        all = FALSE,
#                        concept_class_id %in% c("Ingredient",
#                                                "Precise Ingredient"))
# 
# deConcepts5 <- 
#         deConcepts4 %>%
#         rubix::normalize_all_to_na() 
# 
# deConcepts6 <-
#         deConcepts5 %>% 
#         rubix::deselect_if_all_na()
# 
# 
# 
# 
# 
# 
#         chariot::pivotRelative(deConceptType,
#                                names_from = "concept_class_id")
# head(deConceptsRelatives)

