#' @title Build the Cohort and Regimen Tables
#' @description 
#' This function builds the Cohort and Regimen Tables for the algorithm the derives the antineoplastic combinations. Since the Regimen Table will be directly transformed via the algorithm, a copy of the Regimen Table is made as a Regimen Staging Table to reference back to for optimization and bug fixing purposes.
#' 
#' @param conn                          Connection object to the database engine  
#' @param cdmDatabaseSchema             Source CDM Drug Exposure Table schema  
#' @param cohortDefinitionId            (optional) Cohort Definition Id that filters the CDM Drug Exposure Table to create cohort-specific tables, if desired.
#' @param cohortDefinitionIdSchema      (optional) If a `cohortDefinitionId` is provided, the schema in which the cohort table is located.
#' @param writeDatabaseSchema           Schema where the OncoRegimenFinder tables will be written to.
#' @param cohortTable                   Name of the Cohort Table OncoRegimenFinder requires to execute the algorithm
#' @param regimenTable                  Name of the Regimen Table OncoRegimen will execute the algorithm on.
#' @param drug_classification_id_input  OMOP Concept Ids for Drug Classes curated from the OMOP Vocabulary that are used to identify antineoplastic drugs in the Drug Exposures Table. OncoRegimenFinder is packaged with a default vector of values (c(OncoRegimenFinder::atc_antineoplastic_id, OncoRegimenFinder::hemonc_classes)).   
#' @param false_positive_id             OMOP Concept Ids for Drugs that are often classified as antineoplastics, but are more likely be used in a non-cancer clinical setting, such as retinoids and certain antibiotics. Default: OncoRegimenFinder::falsepositives.
#' @return  
#' Cohort, Regimen, and Regimen Staging Tables in the `writeDatabaseSchema`
#' @details 
#' If the Cohort, Regimen, and Regimen Staging Tables already exist, these tables are renamed with the system date appended in the format "{_YYYY_MM_DD}". The renaming is skipped and the existing Cohort, Regimen and Regimen Staging Tables are dropped if the dated table already exists, indicating that the OncoRegimenFinder was already run once for that system date.
#' @seealso 
#'  \code{\link[OncoRegimenFinder]{atc_antineoplastic_id}},\code{\link[OncoRegimenFinder]{hemonc_classes}},\code{\link[OncoRegimenFinder]{falsepositives}}
#'  \code{\link[pg13]{lsTables}},\code{\link[pg13]{renameTable}},\code{\link[pg13]{appendDate}},\code{\link[pg13]{execute}}
#'  \code{\link[SqlRender]{render}},\code{\link[SqlRender]{readSql}}
#' @rdname buildCohortRegimenTable
#' @export 
#' @importFrom pg13 lsTables renameTable appendDate execute
#' @importFrom SqlRender render readSql


buildCohortRegimenTable <-
        function(conn,
                 cdmDatabaseSchema,
                 cohortDefinitionId = NULL,
                 cohortDefinitionIdSchema = NULL,
                 writeDatabaseSchema,
                 drugExposureIngredientTable,
                 cohortTable,
                 regimenTable,
                 drug_classification_id_input = c("21601387", "35101847", "35807195", "35807466", "35807470", "35807489"),
                 false_positive_id = c("45775396", "1304850", "792993", "19010482", "19089602", "19080458", "19104221", "19065450", "1510328", "42903942", "1354698", "1551860", "19003472", "1356009", "40244464", "1303425", "745466", "1389464", "19025194", "740910", "1710612", "35606631", "19003999", "985708", "45775206", "1308432", "1522957", "1760616", "950637", "1300978", "44816310", "1500211", "1506270", "923645", "19061406", "40171288", "1388796", "40168303", "975125", "1507705", "1511449", "1738521", "1548195", "1518254", "40222444", "1713332", "1112807", "19014878", "19034726", "984232", "1525866", "989482", "1550557", "1551099", "924120", "904351")) {

                cohortTable <- toupper(cohortTable)
                regimenTable <- toupper(regimenTable)
                regimenStagingTable <- toupper(paste0(regimenTable, "_staging"))

                Tables <- pg13::lsTables(conn = conn,
                                         schema = writeDatabaseSchema)

                if (cohortTable %in% Tables) {
                        
                        newTableName <- pg13::appendDate(cohortTable)
                        
                        if (!(newTableName %in% Tables)) {
                        
                                pg13::renameTable(conn = conn,
                                                  schema = writeDatabaseSchema,
                                                  tableName = cohortTable,
                                                  newTableName = newTableName)
                        } else {
                                
                                pg13::dropTable(conn = conn,
                                                schema = writeDatabaseSchema,
                                                tableName = cohortTable)
                                
                        }
                }


                if (regimenTable %in% Tables) {
                        
                        newTableName <- pg13::appendDate(regimenTable)
                        
                        if (!(newTableName %in% Tables)) {
                        
                                pg13::renameTable(conn = conn,
                                                  schema = writeDatabaseSchema,
                                                  tableName = regimenTable,
                                                  newTableName = newTableName)
                        } else {
                                pg13::dropTable(conn = conn,
                                                schema = writeDatabaseSchema,
                                                tableName = regimenTable)
                        }
                }
                
                if (regimenStagingTable %in% Tables) {
                        
                        newTableName <- pg13::appendDate(regimenStagingTable)
                        
                        if (!(newTableName %in% Tables)) {
                                
                                pg13::renameTable(conn = conn,
                                                  schema = writeDatabaseSchema,
                                                  tableName = regimenStagingTable,
                                                  newTableName = newTableName)
                        } else {
                                pg13::dropTable(conn = conn,
                                                schema = writeDatabaseSchema,
                                                tableName = regimenStagingTable)
                        }
                }


                if (!is.null(cohortDefinitionId)) {
                                pg13::execute(conn,
                                            SqlRender::render(SqlRender::readSql(paste0(system.file(package = "OncoRegimenFinder"), "/sql/CohortBuild_cohort_def_id.sql")),
                                                         cdmDatabaseSchema = cdmDatabaseSchema,
                                                         cdmResultSchema = cohortDefinitionIdSchema,
                                                         writeDatabaseSchema = writeDatabaseSchema,
                                                         cohortTable = cohortTable,
                                                         regimenTable = regimenTable,
                                                         drug_classification_id_input = drug_classification_id_input,
                                                         cohortDefinitionId = cohortDefinitionId)
                                )

                } else {

                                                        
                        sql_statement <-
                                                        SqlRender::render(SqlRender::readSql(paste0(system.file(package = "OncoRegimenFinder"), "/sql/CohortBuild.sql")),
                                                                                 cdmDatabaseSchema = cdmDatabaseSchema,
                                                                                 writeDatabaseSchema = writeDatabaseSchema,
                                                                          drugExposureIngredientTable = drugExposureIngredientTable,
                                                                                 cohortTable = cohortTable,
                                                                                 regimenTable = regimenTable,
                                                                                 drug_classification_id_input = drug_classification_id_input,
                                                                          false_positive_id = false_positive_id)
                        

                                pg13::execute(conn,
                                              sql_statement = sql_statement)


                        }

        }
