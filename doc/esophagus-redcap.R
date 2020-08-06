## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup,echo=TRUE,eval=TRUE,message=FALSE,results="hide",warning=FALSE-----
library(tidyverse)
library(rlang)
library(rubix)
library(OncoRegimenFinder)

## ---- echo=FALSE,eval=TRUE,message=FALSE,results="hide"-----------------------
library(fantasia)
conn <- fantasia::connectOMOP()

## ----cohort, echo=FALSE,eval=TRUE---------------------------------------------

esophagus_cohort <- 
        pg13::readTable(conn = conn,
                        schema = "patelm9",
                        tableName = "esophagus_cohort")


## ----cohort2,echo=F,eval=TRUE-------------------------------------------------

head(esophagus_cohort) %>%
  kableExtra::kable()


## ----regimen_ingr,echo=F,eval=TRUE--------------------------------------------

regimen_ingredient <- 
    pg13::query(conn = conn,
                pg13::buildQuery(schema = "patelm9",
                                 tableName = "oncoregimenfinder_regimen_ingredients",
                                 n = 20,
                                 n_type = "random"))


## ----regimen_ingr2,echo=F,eval=TRUE-------------------------------------------

head(regimen_ingredient) %>%
      kableExtra::kable()


## ---- eval = TRUE, echo=FALSE-------------------------------------------------

sql <-
pg13::buildJoinQuery(fields = c("\npatelm9.esophagus_cohort.person_id AS esophagus_person_id\n",
                                "patelm9.esophagus_cohort.ptid\n",
                                "patelm9.oncoregimenfinder_regimen_ingredients.*\n"),
                     schema = "patelm9",
                     tableName = "esophagus_cohort",
                     column = "person_id",
                     joinType = "LEFT",
                     joinOnSchema = "patelm9",
                     joinOnTableName = "oncoregimenfinder_regimen_ingredients",
                     joinOnColumn = "person_id")

cat(sql)


## ---- echo=FALSE, eval=TRUE,results='hide'------------------------------------

esophagus_oncoregimenfinder_results <-
pg13::query(conn = conn,
             sql_statement = sql)


## ---- echo = FALSE, eval = TRUE-----------------------------------------------

esophagus_oncoregimenfinder_results <-
          esophagus_oncoregimenfinder_results %>%
          tibble::as_tibble() %>% 
          dplyr::mutate_all(as.character) %>%
          rubix::normalize_all_to_na() 

head(esophagus_oncoregimenfinder_results) %>%
          kableExtra::kable()


## ----data_summary, echo=FALSE,eval=TRUE---------------------------------------

data_summary <-
  esophagus_oncoregimenfinder_results %>%
    rubix::summarize_variables() %>%
    dplyr::select(-contains("DISTINCT_VALUES"))


## ----data_summary2, echo=FALSE,eval=TRUE--------------------------------------

data_summary %>%
    kableExtra::kable()


## ----redcap_data,echo=FALSE,eval=TRUE,message=FALSE,warning=F,results='hide'----

input <-
fantasia::processRedcapData(data_csv_file = "~/GitHub/MSK-patelm9/escritoire/Esophagus/data_with_phi/STGIEsophagogastricS_DATA_2020-07-28_1354.csv",
                  parsed_metadata_csv_file = "~/GitHub/MSK-patelm9/escritoire/Esophagus/data_without_phi/STGIEsophagogastricSandbox_DataDictionary_2020-06-24_Parsed.csv",
                    identifier_variables = "ptid")

redcapData <- input$ProcessedData


## ----redcap_vars, echo=TRUE,eval=TRUE-----------------------------------------

identifier_vars <- "ptid"
treatment_vars <-
          c('neoadj_regimen',
          'neoadj_tx_additional_drugs',
          'neoadj_tx_addtl_drugs_2',
          'crt_name',
          'neoadjcrt_tx_additional_drugs',
          'neoadjcrt_tx_addtl_drugs_2',
          'adj_regimen',
          'adj_tx_additional_drugs',
          'adj_tx_addtl_drugs_2',
          'adj_rt_concurrent',
          'adjcrt_tx_additional_drugs',
          'adjcrt_tx_addtl_drugs_2',
          'induction_regimen',
          'periop_neo_regimen',
          'periop_adj_regimen',
          'tx_name',
          'advanced_tx_additional_drugs',
          'advanced_tx_addtl_drugs_2',
          'tx_maintenance_drugs',
          'advanced_tx_addtl_drugsm1_1',
          'advanced_tx_addtl_drugsm1_2',
          'tx_maintenance2_drugs',
          'advanced_tx_addtl_drugsm2_1',
          'advanced_tx_addtl_drugsm2_2',
          'palliative_rt_concurrent',
          'neoadj_tx_base_regimen',
          'neoadjcrt_tx_base_regimen',
          'adj_tx_base_regimen',
          'adjcrt_tx_base_regimen',
          'advanced_tx_base_regimen',
          'regimen_name_m1',
          'regimen_name_m2',
          'hipec_drugs')


## ----qa, echo=FALSE,eval=TRUE-------------------------------------------------
qa <- treatment_vars[!(treatment_vars %in% colnames(input$ProcessedData))]
treatment_vars <- treatment_vars[(treatment_vars %in% colnames(input$ProcessedData))]

## ----redcapfilter, echo=FALSE,eval=TRUE---------------------------------------

output <-
      treatment_vars %>%
        rubix::map_names_set(function(x) redcapData %>%
                                         tibble::as_tibble() %>%
                                         rubix::normalize_all_to_na() %>%
                                         dplyr::filter_at(vars(all_of(x)),
                                                          any_vars(!is.na(.))) %>%
                                        dplyr::select(all_of(identifier_vars),
                                                      all_of(x),
                                                      contains("start"),
                                                      contains("stop")) %>%
                                        rubix::deselect_if_all_na()) %>%
        purrr::keep(~nrow(.) > 0) %>% 
        # If the df has less than 2 columns, that means there wasn't a date associated with the variable
        purrr::keep(~ncol(.) > 2)


## ----regimen_name_m2,echo=FALSE,eval=TRUE-------------------------------------
print(output$regimen_name_m2)

## ----redcap_data2,echo=FALSE,eval=TRUE----------------------------------------
output2 <-
  output %>%
  purrr::map2(names(output), function(x, y) x %>%
                          tidyr::pivot_longer(cols = c(contains("start"), contains("stop")),
                                              names_to = c("Context",
                                                           "DateType"),
                                              names_pattern = "(^.*)_([start|stop].*$)",
                                              values_to = "Date")) %>%
  purrr::map(function(x) x %>%
                          dplyr::rename_at(vars(2),
                                           ~paste("PV"))) %>%
  dplyr::bind_rows(.id = "VARIABLE")

print(output2)

## ----redcap_data3, echo=FALSE,eval=TRUE---------------------------------------
output3 <-
  output2 %>% 
  dplyr::mutate(DateType = forcats::as_factor(DateType)) %>% 
  dplyr::mutate(DateType = forcats::fct_collapse(DateType,
                                                 EVENT_START_DATE = c("start", "start_date"),
                                                 EVENT_END_DATE = c("stop", "stop_date"))) %>%
  tidyr::pivot_wider(id_cols = c(!DateType, !Date),
                     names_from = DateType,
                     values_from = Date,
                     values_fn = list(Date = function(x) paste(unique(x), collapse = "\n")))

print(output3)


## ----redcap_data4,echo=FALSE,eval=TRUE----------------------------------------

output4 <-
  output3 %>%
  dplyr::full_join(esophagus_cohort) %>%
  dplyr::select(all_of(colnames(output3)),
                person_id) %>%
  rubix::normalize_all_to_na() %>%
  dplyr::filter_at(vars(c(EVENT_START_DATE, EVENT_END_DATE)),
                   any_vars(!is.na(.))) %>%
  dplyr::mutate(NORMALIZE_START_DATE = EVENT_START_DATE,
                NORMALIZE_END_DATE = EVENT_END_DATE)

print(output4)

## ----redcap_data5,echo=FALSE,eval=TRUE----------------------------------------
output5 <- split(output4, output4$person_id)

## ----esophagus_results2,echo=FALSE,eval=TRUE----------------------------------

esophagus_results2 <-
esophagus_oncoregimenfinder_results %>%
  dplyr::mutate(NORMALIZE_START_DATE = ingredient_start_date,
                NORMALIZE_END_DATE = ingredient_end_date) %>%
  dplyr::mutate_at(vars(person_id), as.integer) 
print(esophagus_results2)
esophagus_results3 <- split(esophagus_results2, esophagus_results2$esophagus_person_id)


## ----final, echo=FALSE,eval=TRUE----------------------------------------------

final_output <-
list(REDCAP = output5,
     OMOP = esophagus_results3) %>%
  purrr::transpose() %>% 
  purrr::map(dplyr::bind_rows, .id = "DATA_SOURCE")


## -----------------------------------------------------------------------------
print(final_output$`1558617`)
print(final_output$`1557156`)

## ----echo=FALSE,eval=TRUE,message=FALSE,results="hide"------------------------
fantasia::dcOMOP(conn = conn,
                 remove = TRUE)

