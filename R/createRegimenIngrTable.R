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
                
                sql <- SqlRender::render(SqlRender::readSql(paste0(system.file(package = "OncoRegimenFinder"), "/sql/RegimenFormat.sql")),
                                                                                writeDatabaseSchema = writeDatabaseSchema,
                                                                                cohortTable = cohortTable,
                                                                                regimenTable = regimenTable,
                                                                                regimenIngredientTable = regimenIngredientTable,
                                                                                vocabularyTable = vocabularyTable)
                
                pg13::execute(conn = conn,
                              sql_statement = sql)
                
        }
