--0: normalize all Drug Exposures to RxNorm Ingredient or Precise Ingredient
DROP TABLE IF EXISTS @writeDatabaseSchema.@drugExposureIngredientTable;

WITH ingredient_exposures AS (
SELECT de.*, c.concept_id AS ingredient_concept_id 
FROM @cdmDatabaseSchema.drug_exposure de 
LEFT JOIN @cdmDatabaseSchema.concept_ancestor a
    ON a.ancestor_concept_id = de.drug_concept_id 
LEFT JOIN @cdmDatabaseSchema.concept c 
    ON a.descendant_concept_id = c.concept_id 
WHERE c.vocabulary_id IN ('RxNorm', 'RxNorm Extension') 
    AND c.concept_class_id IN ('Ingredient', 'Precise Ingredient')
UNION
SELECT de.*, c.concept_id AS ingredient_concept_id 
FROM @cdmDatabaseSchema.drug_exposure de 
LEFT JOIN @cdmDatabaseSchema.concept_ancestor a
    ON a.descendant_concept_id = de.drug_concept_id 
LEFT JOIN @cdmDatabaseSchema.concept c 
    ON a.ancestor_concept_id = c.concept_id 
WHERE c.vocabulary_id IN ('RxNorm', 'RxNorm Extension') 
    AND c.concept_class_id IN ('Ingredient', 'Precise Ingredient')
)

select *
into @writeDatabaseSchema.@drugExposureIngredientTable;
from ingredient_exposures;


--1: create @writeDatabaseSchema.@cohortTable and @writeDatabaseSchema.@regimenTable without a
---cohort definition identifier
--Build the cohort and regimen tables in the database schema to write to
DROP TABLE IF EXISTS @writeDatabaseSchema.@cohortTable;
DROP TABLE IF EXISTS @writeDatabaseSchema.@regimenTable;
DROP TABLE IF EXISTS @writeDatabaseSchema.@regimenTable_staging;

--Taking all drug_exposures and their start and end dates in a cohort as determined by a Cohort Definition Identifier
--filtered for the drugs in drug_exposures that are concept_class_id "Ingredient" and also descendant of 21601387) /* Antineoplastic Agents ATC classification*/
with CTE_second as (
select
       de.drug_exposure_id,
       de.person_id,
       de.drug_concept_id,
       lower(c.concept_name) as concept_name,
       de.drug_exposure_start_date as ingredient_start_date,
       de.drug_exposure_end_date as ingredient_end_date
from @writeDatabaseSchema.@drugExposureIngredientTable de 
--inner join @cdmDatabaseSchema.cohort ch on ch.drug_exposure_id = de.drug_exposure_id
inner join @cdmDatabaseSchema.concept_ancestor ca 
    on ca.descendant_concept_id = de.ingredient_concept_id
where ca.ancestor_concept_id in (@drug_classification_id_input)  --(21601387) /* Antineoplastic Agents ATC classification*/
    AND de.ingredient_concept_id NOT IN (@false_positive_id) 
)

select *
into @writeDatabaseSchema.@cohortTable
from CTE_second;

select * into  @writeDatabaseSchema.@regimenTable
from @writeDatabaseSchema.@cohortTable;

select * into  @writeDatabaseSchema.@regimenTable_staging
from @writeDatabaseSchema.@cohortTable;
