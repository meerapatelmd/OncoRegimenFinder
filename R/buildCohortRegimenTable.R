#' @title Build the Cohort and Regimen Tables
#' @description 
#' This function builds the Cohort and Regimen Tables for the algorithm the derives the antineoplastic combinations. Since the Regimen Table will be directly transformed via the algorithm, a copy of the Regimen Table is made as a Regimen Staging Table to reference back to for optimization and bug fixing purposes. If a Cohort and Regimen Table already
#' 
#' @param conn PARAM_DESCRIPTION
#' @param cdmDatabaseSchema PARAM_DESCRIPTION
#' @param cohortDefinitionId Optional. Cohort Definition Id in the `cdmResultSchema`
#' @param cohortDefinitionIdSchema Optional. Schema where the the cohort and cohort definition ID point to.
#' @param writeDatabaseSchema PARAM_DESCRIPTION
#' @param cohortTable PARAM_DESCRIPTION
#' @param regimenTable PARAM_DESCRIPTION
#' @param renameCurrentTables PARAM_DESCRIPTION, Default: TRUE
#' @param drug_classification_id_input PARAM_DESCRIPTION, Default: c(OncoRegimenFinder::atc_antineoplastic_id, OncoRegimenFinder::hemonc_classes)
#' @param false_positive_id PARAM_DESCRIPTION, Default: OncoRegimenFinder::falsepositives
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
#' @importFrom OncoRegimenFinder atc_antineoplastic_id hemonc_classes falsepositives
#' @importFrom pg13 lsTables renameTable appendDate execute
#' @importFrom SqlRender render readSql



buildCohortRegimenTable <-
        function(conn,
                 cdmDatabaseSchema,
                 cohortDefinitionId = NULL,
                 cohortDefinitionIdSchema = NULL,
                 writeDatabaseSchema,
                 cohortTable,
                 regimenTable,
                 renameCurrentTables = TRUE,
                 drug_classification_id_input = c(OncoRegimenFinder::atc_antineoplastic_id,
                                                  OncoRegimenFinder::hemonc_classes),
                 false_positive_id = OncoRegimenFinder::falsepositives) {

                cohortTable <- toupper(cohortTable)
                regimenTable <- toupper(regimenTable)
                regimenStagingTable <- toupper(paste0(regimenTable, "_staging"))

                if (renameCurrentTables) {

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

                                pg13::execute(conn,
                                SqlRender::render(SqlRender::readSql(paste0(system.file(package = "OncoRegimenFinder"), "/sql/CohortBuild.sql")),
                                                         cdmDatabaseSchema = cdmDatabaseSchema,
                                                         writeDatabaseSchema = writeDatabaseSchema,
                                                         cohortTable = cohortTable,
                                                         regimenTable = regimenTable,
                                                         drug_classification_id_input = drug_classification_id_input,
                                                  false_positive_id = false_positive_id))


                        }

        }
