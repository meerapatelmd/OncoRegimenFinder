# create_regimens <- function(connectionDetails,
#                             cdmDatabaseSchema,
#                             writeDatabaseSchema,
#                             cohortTable = "cancer_cohort",
#                             regimenTable = "cancer_regimens",
#                             regimenIngredientTable = "cancer_regimen_ingredients",
#                             vocabularyTable = "regimen_voc_upd",
#                             drug_classification_id_input = 21601387,
#                             date_lag_input = 30,
#                             regimen_repeats = 5,
#                             generateVocabTable = F,
#                             cdmResultSchema = NULL,
#                             cohortDefinitionId = NULL){
#
#
#               connection <-  DatabaseConnector::connect(connectionDetails)
#
#               if (!is.null(cohortDefinitionId)) {
#                 sql <- SqlRender::render(SqlRender::readSql("SQL/CohortBuild_cohort_def_id.sql"),
#                                          cdmDatabaseSchema = cdmDatabaseSchema,
#                                          cdmResultSchema = cdmResultSchema,
#                                          writeDatabaseSchema = writeDatabaseSchema,
#                                          cohortTable = cohortTable,
#                                          regimenTable = regimenTable,
#                                          drug_classification_id_input = drug_classification_id_input,
#                                          cohortDefinitionId = cohortDefinitionId)
#
#               } else {
#
#                 sql <- SqlRender::render(SqlRender::readSql("SQL/CohortBuild.sql"),
#                                          cdmDatabaseSchema = cdmDatabaseSchema,
#                                          writeDatabaseSchema = writeDatabaseSchema,
#                                          cohortTable = cohortTable,
#                                          regimenTable = regimenTable,
#                                          drug_classification_id_input = drug_classification_id_input)
#
#
#               }
#
#               #sql <- SqlRender::translate(sql,targetDialect = connectionDetails$dbms)
#
#               pg13::execute(conn = conn,
#                             sql_statement = sql)
#
#               sql <- SqlRender::render(SqlRender::readSql("SQL/RegimenCalc2.sql"),
#                                        writeDatabaseSchema = writeDatabaseSchema,
#                                        regimenTable = regimenTable,
#                                        date_lag_input = date_lag_input)
# 
#               #sql <- SqlRender::translate(sql,targetDialect = connectionDetails$dbms)
# 
#               for( i in 1:regimen_repeats) {
# 
#                 DatabaseConnector::executeSql(connection, sql)
# 
#               }
# 
#               if(generateVocabTable){
# 
#                 sql <- SqlRender::render(SqlRender::readSql("SQL/RegimenVoc.sql"),
#                                          writeDatabaseSchema = writeDatabaseSchema,
#                                          cdmDatabaseSchema = cdmDatabaseSchema,
#                                          vocabularyTable = vocabularyTable)
# 
#                 #sql <- SqlRender::translate(sql,targetDialect = connectionDetails$dbms)
# 
#                 DatabaseConnector::executeSql(connection, sql)
# 
#               }
# 
# 
#               sql <- SqlRender::render(SqlRender::readSql("SQL/RegimenFormat.sql"),
#                                        writeDatabaseSchema = writeDatabaseSchema,
#                                        cohortTable = cohortTable,
#                                        regimenTable = regimenTable,
#                                        regimenIngredientTable = regimenIngredientTable,
#                                        vocabularyTable = vocabularyTable)
# 
#               #sql <- SqlRender::translate(sql,targetDialect = connectionDetails$dbms)
# 
# 
#               DatabaseConnector::executeSql(connection, sql)
# 
# }
