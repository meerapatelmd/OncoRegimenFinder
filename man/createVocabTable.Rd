% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/createVocabTable.R
\name{createVocabTable}
\alias{createVocabTable}
\title{Write the Vocabulary Table}
\usage{
createVocabTable(
  conn,
  writeDatabaseSchema,
  cdmDatabaseSchema,
  vocabularyTable,
  renameTable
)
}
\arguments{
\item{conn}{PARAM_DESCRIPTION}

\item{writeDatabaseSchema}{PARAM_DESCRIPTION}

\item{cdmDatabaseSchema}{PARAM_DESCRIPTION}

\item{vocabularyTable}{PARAM_DESCRIPTION}
}
\value{
A Vocabulary Table in the designated schema.
}
\description{
The Vocabulary Table takes all the HemOnc Regimens in the OMOP Concept Table, maps the RxNorm Ingredients that comprise each Regimen, and calculates the number of unique ingredients per Regimen in an \code{ingredient_count} field and a string aggregate \code{ingredient_combination}. The \code{ingredient_combination} field combines the names of all the ingredients in a comma-separated string when the \code{ingredient_count} is greater than 2, an "and" concatenation when the \code{ingredient_count} is 2, or simply the ingredient name when \code{ingredient_count} is 1.
Since a set of RxNorm Ingredients can map to more than 1 HemOnc Regimen, the table also is filtered for the shortest \code{ingredient_combination} string by character count by the concept id of the regimen, excluding abbreviations assumed to be of character counts of 5 or less.
}
\seealso{
\code{\link[pg13]{lsTables}},\code{\link[pg13]{appendDate}},\code{\link[pg13]{renameTable}},\code{\link[pg13]{dropTable}},\code{\link[pg13]{execute}},\code{\link[pg13]{readTable}},\code{\link[pg13]{writeTable}}
\code{\link[SqlRender]{render}},\code{\link[SqlRender]{readSql}}
\code{\link[secretary]{press_enter}}
\code{\link[dplyr]{group_by}},\code{\link[dplyr]{summarise}},\code{\link[dplyr]{arrange}},\code{\link[dplyr]{rename}},\code{\link[dplyr]{mutate-joins}},\code{\link[dplyr]{mutate}},\code{\link[dplyr]{select}}
\code{\link[rubix]{group_by_unique_aggregate}},\code{\link[rubix]{arrange_by_nchar}}
\code{\link[stringr]{str_replace}}
\code{\link[forcats]{fct_collapse}}
}
