#' @title Top Classes
#' @description Top OMOP Classifications for Cancer Drugs
#' @format A data frame with 99 rows and 4 variables:
#' \describe{
#'   \item{\code{Vocabulary}}{character Vocabulary Id}
#'   \item{\code{Category}}{character Category assigned}
#'   \item{\code{cancer_drug_category_concept_id}}{character Concept Id for the Category}
#'   \item{\code{cancer_drug_category_concept_name}}{character Conecpt Name for the Category} 
#'}
#' @details DETAILS
"topclasses"

#' @title False Positive Cancer Drugs
#' @description Concept Ids that fall under a Cancer-related drug classification, but are unlikely to be used primarily for a cancer.
#' @format A data frame with 283 rows and 1 variables:
#' \describe{
#'   \item{\code{concept_id}}{character RxNorm Ingredient Concept Id} 
#'}
#' @details DETAILS
"falsepositives"
