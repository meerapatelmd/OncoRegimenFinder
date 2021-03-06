% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/runORF.R
\name{runORF}
\alias{runORF}
\title{Run OncoRegimenFinder}
\usage{
runORF(
  conn,
  cdmDatabaseSchema,
  writeDatabaseSchema,
  vocabularyTable,
  drugExposureIngredientTable,
  cohortTable,
  regimenTable,
  regimenIngredientTable,
  verbose = TRUE,
  progressBar = TRUE,
  renameTable = FALSE
)
}
\arguments{
\item{conn}{a database connection object}

\item{cdmDatabaseSchema}{OMOP CDM source schema}

\item{writeDatabaseSchema}{schema to write to}

\item{vocabularyTable}{Vocabulary Table}

\item{drugExposureIngredientTable}{Drug Exposure Table}

\item{cohortTable}{Cohort Table}

\item{regimenTable}{Regimen Table}

\item{regimenIngredientTable}{Regimen Ingredient Table}

\item{verbose}{If TRUE, prints details of the operations being performed as they are being executed.}

\item{progressBar}{If TRUE, prints a progress bar to the console that tracks the write table process.}
}
\description{
This function runs OncoRegimenFinder from start to finish.
}
\seealso{
\code{\link[progress]{progress_bar}}
\code{\link[secretary]{typewrite}}
\code{\link[OncoRegimenFinder]{createVocabTable}},\code{\link[OncoRegimenFinder]{buildIngredientExposuresTable}},\code{\link[OncoRegimenFinder]{buildCohortRegimenTable}},\code{\link[OncoRegimenFinder]{processRegimenTable}},\code{\link[OncoRegimenFinder]{createRegimenIngrTable}}
}
