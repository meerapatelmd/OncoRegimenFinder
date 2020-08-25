#' @title Build Ingredient Exposures Tables
#' @description 
#' This function builds the Ingredient Exposures Table for the algorithm to derive the antineoplastic combinations based on the RxNorm Ingredient of the drug in question. 
#' 
#' @param conn                          Connection object to the database engine  
#' @param cdmDatabaseSchema             Source CDM Drug Exposure Table schema  
#' @param writeDatabaseSchema           Schema where the OncoRegimenFinder tables will be written to.
#' @param drugExposureIngredientTable   Name of the new Ingredient Exposure Table
#' 
#' @return  
#' Ingredient Exposure Table in `writeDatabaseSchema` that contains all the original fields from the Drug Exposure Table with the addition of an Ingedient Conceot Id column that maps the drug to its RxNorm Ingredient.
#' 
#' @details 
#' If the Cohort, Regimen, and Regimen Staging Tables already exist, these tables are renamed with the system date appended in the format "{_YYYY_MM_DD}". The renaming is skipped and the existing Cohort, Regimen and Regimen Staging Tables are dropped if the dated table already exists, indicating that the OncoRegimenFinder was already run once for that system date.
#' @seealso 
#'  \code{\link[OncoRegimenFinder]{atc_antineoplastic_id}},\code{\link[OncoRegimenFinder]{hemonc_classes}},\code{\link[OncoRegimenFinder]{falsepositives}}
#'  \code{\link[pg13]{lsTables}},\code{\link[pg13]{renameTable}},\code{\link[pg13]{appendDate}},\code{\link[pg13]{execute}}
#'  \code{\link[SqlRender]{render}},\code{\link[SqlRender]{readSql}}
#' @rdname buildIngredientExposuresTable
#' @export 
#' @importFrom pg13 lsTables renameTable appendDate execute
#' @importFrom SqlRender render readSql


buildIngredientExposuresTable <-
        function(conn,
                 cdmDatabaseSchema,
                 writeDatabaseSchema,
                 drugExposureIngredientTable,
                 renameTable) {

                drugExposureIngredientTable <- toupper(drugExposureIngredientTable)

                if (renameTable) {

                   Tables <- pg13::lsTables(conn = conn,
                                         schema = writeDatabaseSchema)

                   if (drugExposureIngredientTable %in% Tables) {
                        
                        newTableName <- pg13::appendDate(drugExposureIngredientTable)
                        
                        if (!(newTableName %in% Tables)) {
                        
                                pg13::renameTable(conn = conn,
                                                  schema = writeDatabaseSchema,
                                                  tableName = drugExposureIngredientTable,
                                                  newTableName = newTableName)
                        } else {
                                
                                pg13::dropTable(conn = conn,
                                                schema = writeDatabaseSchema,
                                                tableName = drugExposureIngredientTable)
                                
                        }
                   }
                }
                                pg13::execute(conn,
                                SqlRender::render(SqlRender::readSql(paste0(system.file(package = "OncoRegimenFinder"), "/sql/IngredientExposureTable.sql")),
                                                         cdmDatabaseSchema = cdmDatabaseSchema,
                                                         writeDatabaseSchema = writeDatabaseSchema,
                                                        drugExposureIngredientTable = drugExposureIngredientTable))


        }
