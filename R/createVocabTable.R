#' Process Regimen Table
#' @import SqlRender
#' @import pg13
#' @export

createVocabTable <- 
        function(conn,
                 writeDatabaseSchema,
                 cdmDatabaseSchema,
                 vocabularyTable,
                 renameCurrentTables = TRUE) {
                
                vocabularyTable <- toupper(vocabularyTable)
                
                if (renameCurrentTables) {
                        
                        Tables <- pg13::lsTables(conn = conn,
                                                 schema = writeDatabaseSchema)
                        
                        if (vocabularyTable %in% Tables) {
                                pg13::renameTable(conn = conn,
                                                  schema = writeDatabaseSchema,
                                                  tableName = vocabularyTable,
                                                  newTableName = pg13::appendDate(vocabularyTable))
                        }
                        
                }
                
                
                sql <- SqlRender::render(SqlRender::readSql(paste0(system.file(package = "OncoRegimenFinder"), "/sql/RegimenVoc.sql")),
                                         writeDatabaseSchema = writeDatabaseSchema,
                                         cdmDatabaseSchema = cdmDatabaseSchema,
                                         vocabularyTable = vocabularyTable)
                
                pg13::execute(conn = conn,
                              sql_statement = sql)

                
        }

