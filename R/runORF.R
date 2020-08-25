#' @title Run OncoRegimenFinder
#' @description 
#' This function runs OncoRegimenFinder from start to finish.
#' @param conn                                  a database connection object
#' @param cdmDatabaseSchema                     OMOP CDM source schema
#' @param writeDatabaseSchema                   schema to write to
#' @param vocabularyTable                       Vocabulary Table
#' @param drugExposureIngredientTable           Drug Exposure Table
#' @param cohortTable                           Cohort Table
#' @param regimenTable                          Regimen Table
#' @param regimenIngredientTable                Regimen Ingredient Table
#' @param verbose                               If TRUE, prints details of the operations being performed as they are being executed.
#' @param progressBar                           If TRUE, prints a progress bar to the console that tracks the write table process.
#' @seealso 
#'  \code{\link[progress]{progress_bar}}
#'  \code{\link[secretary]{typewrite}}
#'  \code{\link[OncoRegimenFinder]{createVocabTable}},\code{\link[OncoRegimenFinder]{buildIngredientExposuresTable}},\code{\link[OncoRegimenFinder]{buildCohortRegimenTable}},\code{\link[OncoRegimenFinder]{processRegimenTable}},\code{\link[OncoRegimenFinder]{createRegimenIngrTable}}
#' @rdname runORF
#' @export 
#' @importFrom progress progress_bar
#' @importFrom secretary typewrite





runORF <- 
        function(conn,
                 cdmDatabaseSchema,
                 writeDatabaseSchema,
                 vocabularyTable,
                 drugExposureIngredientTable,
                 cohortTable,
                 regimenTable,
                 regimenIngredientTable,
                 verbose = TRUE,
                 progressBar = TRUE,
                 renameTable = FALSE) {
                
                
                if (progressBar) {
                        pb <- progress::progress_bar$new(
                                                format = ":what [:bar] :elapsedfull :current/:total (:percent)", 
                                                clear = FALSE,
                                                total = 5)
                        
                        pb$tick(0)
                        Sys.sleep(0.2)
                }
                
                
                if (progressBar) {
                        pb$tick(tokens = list(what = vocabularyTable))
                        Sys.sleep(0.2)
                }
                
                if (verbose) {
                        secretary::typewrite("\nWriting Vocabulary Table...")
                }
                
                createVocabTable(conn = conn,
                                                    writeDatabaseSchema = writeDatabaseSchema,
                                                    cdmDatabaseSchema = cdmDatabaseSchema,
                                                    vocabularyTable = vocabularyTable, renameTable = renameTable)
                
                if (progressBar) {
                        pb$tick(tokens = list(what = drugExposureIngredientTable))
                        Sys.sleep(0.2)
                }
                
                if (verbose) {
                        secretary::typewrite("\nWriting Ingredient Exposures Table...")
                }
                
                buildIngredientExposuresTable(conn = conn,
                                                                 cdmDatabaseSchema = cdmDatabaseSchema,
                                                                 writeDatabaseSchema = writeDatabaseSchema,
                                                                 drugExposureIngredientTable = drugExposureIngredientTable,
                                              renameTable = renameTable)
                
                
                if (progressBar) {
                        pb$tick(tokens = list(what = paste(cohortTable, regimenTable, collapse = " and ")))
                        Sys.sleep(0.2)
                }
                
                if (verbose) {
                        secretary::typewrite("\nWriting Cohort and Regimen Staging Tables...")
                }
                
                buildCohortRegimenTable(conn = conn,
                                                           cdmDatabaseSchema = cdmDatabaseSchema,
                                                           writeDatabaseSchema = writeDatabaseSchema,
                                                           drugExposureIngredientTable = drugExposureIngredientTable,
                                                           cohortTable = cohortTable,
                                                           regimenTable = regimenTable,
                                         renameTable = renameTable)
                
                if (progressBar) {
                        pb$tick(tokens = list(what = regimenTable))
                        Sys.sleep(0.2)
                }
                
                
                if (verbose) {
                        secretary::typewrite("\nProcessing Regimen Tables...")
                }
               
                processRegimenTable(conn = conn,
                                                       writeDatabaseSchema = writeDatabaseSchema,
                                                       regimenTable = regimenTable)
                
                
                if (progressBar) {
                        pb$tick(tokens = list(what = regimenIngredientTable))
                        Sys.sleep(0.2)
                }
                
                if (verbose) {
                        secretary::typewrite("\nWriting Regimen Ingredient Table...")
                }
                
                createRegimenIngrTable(conn = conn,
                                                          writeDatabaseSchema = writeDatabaseSchema,
                                                          cohortTable = cohortTable,
                                                          regimenTable = regimenTable,
                                                          regimenIngredientTable = regimenIngredientTable,
                                                          vocabularyTable = vocabularyTable,
                                        renameTable = renameTable)
                
        }
