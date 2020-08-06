# 
# 
# hoComp <- chariot::query_athena(SqlRender::render(SqlRender::readSql("inst/sql/hoComponent.sql"),
#                                         schema = "public")) 
# 
# 
# chariot::leftJoinRelationship(hoComp,
#                               merge_concept2 = F) %>%
#         rubix::filter_at_grepl(concept_class_id_2,
#                                grepl_phrase = "Ingredient") %>%
#         rubix::filter_at_grepl(vocabulary_id_2,
#                                grepl_phrase = "RxNorm") %>%
#         dplyr::select(concept_id_2) %>%
#         chariot::left_join_relatives() %>%
#         dplyr::filter(relative_standard_concept %in% c("C")) %>%
#         rubix::filter_at_grepl(relative_vocabulary_id,
#                                grepl_phrase = "hemonc|atc|rxnorm")
# 
# 
# readHemOncComponents <-
#         function() {
#                 sql <- SqlRender::render(SqlRender::readSql("inst/sql/hoComponent.sql"),
#                                          schema = "public")
#                 
#                 conn <- chariot::connectAthena()
#                 resultset <- pg13::query(conn = conn,
#                             sql_statement = sql)
#                 chariot::dcAthena(conn = conn)
#                 
#                 return(resultset)
#                 
#         }
# 
# 
# 
# readAllRelativesComponents <-
#         function(concept_ids) {
#                 
#                 sql <- SqlRender::render(SqlRender::readSql("inst/sql/allRelatives.sql"),
#                                          schema = "public",
#                                          concept_ids = concept_ids)
# 
#                 conn <- chariot::connectAthena()
#                 resultset <- pg13::query(conn = conn,
#                                          sql_statement = sql)
#                 chariot::dcAthena(conn = conn)
#                 
#                 return(resultset)
#                 
#         }
# 
# hoIngredients <- readAllRelativesComponents(hoComponents$concept_id)
# hoIngredients2 <-
#         hoIngredients %>%
#                 rubix::filter_for(filter_col =  concept_id,
#                                   inclusion_vector = OncoRegimenFinder::falsepositives$concept_id,
#                                   invert = TRUE)
