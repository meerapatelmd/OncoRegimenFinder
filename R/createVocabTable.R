#' Process Regimen Table
#' @import SqlRender
#' @import pg13
#' @export

createVocabTable <- 
        function(conn,
                 writeDatabaseSchema,
                 cdmDatabaseSchema,
                 vocabularyTable) {
                
                sql <- SqlRender::render(SqlRender::readSql(paste0(system.file(package = "OncoRegimenFinder"), "/sql/RegimenVoc.sql")),
                                         writeDatabaseSchema = writeDatabaseSchema,
                                         cdmDatabaseSchema = cdmDatabaseSchema,
                                         vocabularyTable = vocabularyTable)
                
                pg13::execute(conn = conn,
                              sql_statement = sql)

                
        }

