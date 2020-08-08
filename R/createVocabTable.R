#' Process Regimen Table
#' @import SqlRender
#' @import pg13
#' @export

createVocabTable <- 
        function(conn,
                 writeDatabaseSchema,
                 cdmDatabaseSchema,
                 vocabularyTable) {
                
                vocabularyTable <- toupper(vocabularyTable)
                
                
                        
                Tables <- pg13::lsTables(conn = conn,
                                         schema = writeDatabaseSchema)
                
                if (vocabularyTable %in% Tables) {
                        
                        newTableName <- pg13::appendDate(vocabularyTable)
                        
                        if (!(newTableName %in% Tables)) {
                                pg13::renameTable(conn = conn,
                                                  schema = writeDatabaseSchema,
                                                  tableName = vocabularyTable,
                                                  newTableName = newTableName)
                        } else {
                                pg13::dropTable(conn = conn,
                                                schema = writeDatabaseSchema,
                                                tableName = vocabularyTable)
                        }
                }
                        
                
                
                sql <- SqlRender::render(SqlRender::readSql(paste0(system.file(package = "OncoRegimenFinder"), "/sql/RegimenVoc.sql")),
                                         writeDatabaseSchema = writeDatabaseSchema,
                                         cdmDatabaseSchema = cdmDatabaseSchema,
                                         vocabularyTable = vocabularyTable)
                
                pg13::execute(conn = conn,
                              sql_statement = sql)
                
                
                vocabulary <- 
                        pg13::readTable(conn = conn,
                                        schema = writeDatabaseSchema,
                                        tableName = vocabularyTable)
                
                
                processedVocab <- 
                vocabulary %>% 
                        dplyr::arrange(ingredient_name) %>%
                        rubix::group_by_unique_aggregate(regimen_id, regimen_name,
                                                         agg.col = ingredient_name,
                                                         collapse = ", ") %>%
                        dplyr::rename(ingredient_combination = ingredient_name)
                
                
                pg13::dropTable(conn = conn,
                                schema = writeDatabaseSchema,
                                tableName = vocabularyTable)
                
                
                pg13::writeTable(conn = conn,
                                 schema = writeDatabaseSchema,
                                 tableName = vocabularyTable,
                                 .data = processedVocab)

        }

