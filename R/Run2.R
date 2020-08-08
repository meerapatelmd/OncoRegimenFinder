
# vocabulary <-
#         fantasia::qOMOP(pg13::buildQuery(schema = "patelm9",
#                                          tableName = "oncoregimenfinder_vocabulary"),
#                         override_cache = T)
# 
# vocabulary %>% 
#         dplyr::arrange(ingredient_name) %>% 
#         rubix::group_by_unique_aggregate(regimen_id, regimen_name,
#                                   agg.col = ingredient_name,
#                                   collapse = ", ") %>%
#         dplyr::rename(ingredient_combination = ingredient_name) %>%
#         group_by(ingredient_combination) %>% 
#         mutate(unique_ingr_comb_count = length(unique(regimen_id))) %>% 
#         dplyr::filter(unique_ingr_comb_count > 1) %>%
#         dplyr::arrange(desc(unique_ingr_comb_count))
