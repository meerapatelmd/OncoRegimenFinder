#' @title 
#' Row Counts 
#' @description
#' This function takes the names of each of the table arguments for \code{\link{runORF}}, finds all the tables matching the name with or without the appended date in the format "YYYY_mm_dd". 
#' 
#' @param conn                          Database connection object
#' @param writeDatabaseSchema           Schema where tables are written
#' @inheritParams runORF
#' @return
#' A named list of data frames with counts for each respective argument.
#' @details DETAILS
#' @seealso 
#'  \code{\link[rubix]{map_names_set}}
#'  \code{\link[pg13]{lsTables}},\code{\link[pg13]{query}},\code{\link[pg13]{renderRowCount}}
#'  \code{\link[purrr]{map2}},\code{\link[purrr]{set_names}},\code{\link[purrr]{map}}
#'  \code{\link[dplyr]{bind}},\code{\link[dplyr]{select_all}}
#' @rdname rowCountHistory
#' @export 
#' @importFrom rubix map_names_set
#' @importFrom pg13 lsTables query renderRowCount
#' @importFrom purrr map2 set_names map
#' @importFrom dplyr bind_rows rename_at %>%

rowCountHistory <- 
        function(conn,
                 writeDatabaseSchema,
                 vocabularyTable,
                 drugExposureIngredientTable,
                 cohortTable,
                 regimenTable,
                 regimenIngredientTable) {
                
                
                tableNames <- 
                        list(
                        "vocabularyTable" = vocabularyTable,
                        "drugExposureIngredientTable" = drugExposureIngredientTable,
                        "cohortTable" = cohortTable,
                        "regimenStagingTable" = paste0(regimenTable, "_staging"),
                        "regimenTable" = regimenTable,
                        "regimenIngredientTable" = regimenIngredientTable
                        )  %>%
                        rubix::map_names_set(~paste0("^",.))
                
                tableNameRegex <- 
                        paste0(unlist(tableNames), "[_]{1}[0-9]{4}[_]{1}[0-9]{2}[_]{1}[0-9]{2}") %>%
                        as.list()
                names(tableNameRegex) <- names(tableNames)
                
                Tables <- pg13::lsTables(conn = conn,
                                         schema = writeDatabaseSchema)
                
                allTables <-
                tableNames %>% 
                        purrr::map2(tableNameRegex,
                                    function(x,y) grep(paste(paste0(x, "$"),y, sep = "|"),
                                                       Tables,
                                                       ignore.case = TRUE,
                                                       value = TRUE)) %>%
                        purrr::set_names(names(tableNames))
                
                
                allTables %>%
                        purrr::map(function(x) rubix::map_names_set(x, 
                                                          function(y) pg13::query(conn = conn,
                                                                                 sql_statement = pg13::renderRowCount(schema = writeDatabaseSchema,
                                                                                                                      tableName = y)))) %>%
                        purrr::map(~dplyr::bind_rows(., .id = "Table"))
                
        }
