#' Build the Cohort and Regimen Tables
#' @import SqlRender
#' @import pg13
#' @return The Cohort and Regimen Tables in the writeDatabaseSchema
#' @param cohortDefinitionId Optional. Cohort Definition Id in the `cdmResultSchema`
#' @param cohortDefinitionIdSchema  Optional. Schema where the the cohort and cohort definition ID point to.
#' @export

buildCohortRegimenTable <-
        function(conn,
                 cdmDatabaseSchema,
                 cohortDefinitionId = NULL,
                 cohortDefinitionIdSchema = NULL,
                 writeDatabaseSchema,
                 cohortTable,
                 regimenTable,
                 renameCurrentTables = TRUE,
                 drug_classification_id_input) {

                cohortTable <- toupper(cohortTable)
                regimenTable <- toupper(regimenTable)

                if (renameCurrentTables) {

                        Tables <- pg13::lsTables(conn = conn,
                                                 schema = writeDatabaseSchema)

                        if (cohortTable %in% Tables) {
                                pg13::renameTable(conn = conn,
                                                  schema = writeDatabaseSchema,
                                                  tableName = cohortTable,
                                                  newTableName = pg13::appendDate(cohortTable))
                        }


                        if (regimenTable %in% Tables) {
                                pg13::renameTable(conn = conn,
                                                  schema = writeDatabaseSchema,
                                                  tableName = regimenTable,
                                                  newTableName = pg13::appendDate(regimenTable))
                        }

                }

                if (!is.null(cohortDefinitionId)) {
                                pg13::execute(conn,
                                            SqlRender::render(SqlRender::readSql(paste0(system.file(package = "OncoRegimenFinder"), "/inst/sql/CohortBuild_cohort_def_id.sql")),
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
                                SqlRender::render(SqlRender::readSql(paste0(system.file(package = "OncoRegimenFinder"), "/inst/sql/CohortBuild.sql")),
                                                         cdmDatabaseSchema = cdmDatabaseSchema,
                                                         writeDatabaseSchema = writeDatabaseSchema,
                                                         cohortTable = cohortTable,
                                                         regimenTable = regimenTable,
                                                         drug_classification_id_input = drug_classification_id_input))


                        }

        }
