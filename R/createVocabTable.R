#' @title Write the Vocabulary Table
#' @description
#' The Vocabulary Table takes all the HemOnc Regimens in the OMOP Concept Table, maps the RxNorm Ingredients that comprise each Regimen, and calculates the number of unique ingredients per Regimen in an `ingredient_count` field and a string aggregate `ingredient_combination`. The `ingredient_combination` field combines the names of all the ingredients in a comma-separated string when the `ingredient_count` is greater than 2, an "and" concatenation when the `ingredient_count` is 2, or simply the ingredient name when `ingredient_count` is 1.
#'    Since a set of RxNorm Ingredients can map to more than 1 HemOnc Regimen, the table also is filtered for the shortest `ingredient_combination` string by character count by the concept id of the regimen, excluding abbreviations assumed to be of character counts of 5 or less.
#' @param conn PARAM_DESCRIPTION
#' @param writeDatabaseSchema PARAM_DESCRIPTION
#' @param cdmDatabaseSchema PARAM_DESCRIPTION
#' @param vocabularyTable PARAM_DESCRIPTION
#' @return
#' A Vocabulary Table in the designated schema.
#' @seealso
#'  \code{\link[pg13]{lsTables}},\code{\link[pg13]{appendDate}},\code{\link[pg13]{renameTable}},\code{\link[pg13]{dropTable}},\code{\link[pg13]{execute}},\code{\link[pg13]{readTable}},\code{\link[pg13]{writeTable}}
#'  \code{\link[SqlRender]{render}},\code{\link[SqlRender]{readSql}}
#'  \code{\link[secretary]{press_enter}}
#'  \code{\link[dplyr]{group_by}},\code{\link[dplyr]{summarise}},\code{\link[dplyr]{arrange}},\code{\link[dplyr]{rename}},\code{\link[dplyr]{mutate-joins}},\code{\link[dplyr]{mutate}},\code{\link[dplyr]{select}}
#'  \code{\link[rubix]{group_by_unique_aggregate}},\code{\link[rubix]{arrange_by_nchar}}
#'  \code{\link[stringr]{str_replace}}
#'  \code{\link[forcats]{fct_collapse}}
#' @rdname createVocabTable
#' @export
#' @importFrom pg13 lsTables appendDate renameTable dropTable execute readTable writeTable
#' @importFrom SqlRender render readSql
#' @importFrom secretary press_enter
#' @importFrom dplyr group_by summarize ungroup arrange rename left_join mutate select
#' @importFrom rubix group_by_unique_aggregate arrange_by_nchar
#' @importFrom stringr str_replace
#' @importFrom forcats fct_collapse

createVocabTable <-
        function(conn,
                 writeDatabaseSchema,
                 cdmDatabaseSchema,
                 vocabularyTable,
                 renameTable) {

                vocabularyTable <- toupper(vocabularyTable)

                if (renameTable) {
                  Tables <- pg13::lsTables(conn = conn,
                                         schema = writeDatabaseSchema)
                  if (vocabularyTable %in% Tables) {
                        newTableName <- pg13::appendDate(vocabularyTable)
                        if (!(newTableName %in% Tables)) {
                                pg13::renameTable(conn = conn,
                                                  schema = writeDatabaseSchema,
                                                  tableName = vocabularyTable,
                                                  newTableName = newTableName)
                        } else {
                                pg13::dropTable(conn = conn,
                                                schema = writeDatabaseSchema,
                                                tableName = vocabularyTable)
                        }
                    }
                }

                sql <- SqlRender::render(SqlRender::readSql(paste0(system.file(package = "OncoRegimenFinder"), "/sql/RegimenVoc.sql")),
                                         writeDatabaseSchema = writeDatabaseSchema,
                                         cdmDatabaseSchema = cdmDatabaseSchema,
                                         vocabularyTable = vocabularyTable)

                pg13::execute(conn = conn,
                              sql_statement = sql)


                vocabulary <-
                        pg13::readTable(conn = conn,
                                        schema = writeDatabaseSchema,
                                        tableName = vocabularyTable)

                processedVocabularyA <-
                        vocabulary %>%
                                dplyr::group_by(regimen_id, regimen_name) %>%
                                dplyr::summarize(ingredient_count = length(unique(ingredient_id)), .groups = "drop") %>%
                                dplyr::ungroup()

                processedVocabularyB <-
                        vocabulary %>%
                                dplyr::arrange(ingredient_name) %>%
                                rubix::group_by_unique_aggregate(regimen_id, regimen_name,
                                                                 agg.col = ingredient_name,
                                                                 collapse = ", ") %>%
                                dplyr::rename(ingredient_combination = ingredient_name)


                processedVocabulary <-
                        dplyr::left_join(processedVocabularyA,
                                         processedVocabularyB,
                                         by = c("regimen_id", "regimen_name")) %>%
                        dplyr::mutate(ingredient_combination =
                                         ifelse(ingredient_count == 2,
                                                stringr::str_replace(ingredient_combination,
                                                                                     "[,]{1} ",
                                                                                         " and "),
                                                ingredient_combination)) %>%
                        dplyr::group_by(regimen_id) %>%
                        rubix::arrange_by_nchar(nchar_col = ingredient_combination) %>%
                        dplyr::filter(dplyr::row_number() == 1) %>%
                        dplyr::ungroup() %>%
                        rubix::arrange_by_nchar(regimen_name) %>%
                        dplyr::mutate(nchar_regimen_name = nchar(regimen_name)) %>%
                        dplyr::mutate(regimen_name_cat = suppressWarnings(forcats::fct_collapse(factor(nchar_regimen_name),
                                                                                 abbr = as.character(min(nchar_regimen_name):5),
                                                                               nonabbr = as.character(6:max(nchar_regimen_name))))) %>%
                        dplyr::mutate(regimen_name_cat = as.character(regimen_name_cat)) %>%
                        dplyr::group_by(ingredient_count, ingredient_combination) %>%
                        dplyr::arrange(desc(regimen_name_cat), nchar_regimen_name) %>%
                        dplyr::filter(dplyr::row_number() == 1) %>%
                        dplyr::ungroup() %>%
                        dplyr::select(regimen_id,
                                      regimen_name,
                                      ingredient_count,
                                      ingredient_combination)


                pg13::dropTable(conn = conn,
                                schema = writeDatabaseSchema,
                                tableName = vocabularyTable)


                pg13::writeTable(conn = conn,
                                 schema = writeDatabaseSchema,
                                 tableName = vocabularyTable,
                                 .data = processedVocabulary)

        }

