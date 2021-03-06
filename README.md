
<!-- README.md is generated from README.Rmd. Please edit that file -->

# OncoRegimenFinder <img src="man/figures/logo.png" align="right" alt="" width="120" />

<!-- badges: start -->

<!-- badges: end -->

This package extracts Chemotherapy Regimens from the OMOP CDM Drug
Exposures Table based on an algorithm developed by the OHDSI Oncology
Workgroup.

## Installation

The development version can be installed from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("meerapatelmd/oncoregimenfinder")
```

## Example Run

OncoRegimenFinder requires:

  - A connection to an OMOP CDM Instance (`conn`)  
  - A designated schema where the results can be written to
    (`writeDatabaseSchema`)

<!-- end list -->

``` r
cdmDatabaseSchema <- "omop_cdm_2"
writeDatabaseSchema <- "oncoregimenfinder"
```

Execution performed by a single function call to `runORF()`

``` r
runORF(conn = conn,
       cdmDatabaseSchema = cdmDatabaseSchema,
       writeDatabaseSchema = writeDatabaseSchema)
```

## Code of Conduct

Please note that the OncoRegimenFinder project is released with a
[Contributor Code of
Conduct](https://github.mskcc.org/pages/patelm9/OncoRegimenFinder/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
