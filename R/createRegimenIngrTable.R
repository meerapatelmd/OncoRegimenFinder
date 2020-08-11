#' Create Regimen Ingredient Table
#' @import SqlRender
#' @import pg13
#' @export

createRegimenIngrTable <-
        function(conn,
                 writeDatabaseSchema,
                 cohortTable,
                 regimenTable,
                 regimenIngredientTable,
                 vocabularyTable) {
                
                regimenIngredientTable <- toupper(regimenIngredientTable)
                
 
                        
                Tables <- pg13::lsTables(conn = conn,
                                         schema = writeDatabaseSchema)
                
                if (regimenIngredientTable %in% Tables) {
                        
                        newTableName <- pg13::appendDate(regimenIngredientTable)
                        
                        if (!(newTableName %in% Tables)) {
                                
                                pg13::renameTable(conn = conn,
                                                  schema = writeDatabaseSchema,
                                                  tableName = regimenIngredientTable,
                                                  newTableName = newTableName)
                                
                        } else {
                                
                                pg13::dropTable(conn = conn,
                                                schema = writeDatabaseSchema,
                                                tableName = regimenIngredientTable)
                                
                        }
                }
                        
                
                sql <- SqlRender::render(SqlRender::readSql(paste0(system.file(package = "OncoRegimenFinder"), "/sql/RegimenIngredientTable.sql")),
                                                                                writeDatabaseSchema = writeDatabaseSchema,
                                                                                cohortTable = cohortTable,
                                                                                regimenTable = regimenTable,
                                                                                regimenIngredientTable = regimenIngredientTable,
                                                                                vocabularyTable = vocabularyTable)
                
                pg13::execute(conn = conn,
                              sql_statement = sql)
                
        }
