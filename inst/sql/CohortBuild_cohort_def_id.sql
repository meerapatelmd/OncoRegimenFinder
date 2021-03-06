--1: create @writeDatabaseSchema.@cohortTable and @writeDatabaseSchema.@regimenTable
---that incorporates a cohort definition id in a @cdmResultSchema.cohort table
--Build the cohort and regimen tables in the database schema to write to
DROP TABLE IF EXISTS @writeDatabaseSchema.@cohortTable;
DROP TABLE IF EXISTS @writeDatabaseSchema.@regimenTable;

--Taking all drug_exposures and their start and end dates in a cohort as determined by a Cohort Definition Identifier
--filtered for the drugs in drug_exposures that are concept_class_id "Ingredient" and also descendant of 21601387) /* Antineoplastic Agents ATC classification*/
with CTE_second as (
select
       lower(c.concept_name) as concept_name,
       de.drug_exposure_id,
       de.person_id,
       de.drug_concept_id,
       de.drug_exposure_start_date as ingredient_start_date,
       de.drug_exposure_end_date as ingredient_end_date
from @cdmDatabaseSchema.drug_exposure de
inner join @cdmDatabaseSchema.cohort ch on ch.drug_exposure_id = de.drug_exposure_id
inner join @cdmResultSchema.cohort c2 on ch.person_id = c2.subject_id and c2.cohort_definition_id = @cohortDefinitionId
inner join @cdmDatabaseSchema.concept_ancestor ca on ca.descendant_concept_id = de.drug_concept_id
inner join @cdmDatabaseSchema.concept c on c.concept_id = ca.ancestor_concept_id
    where c.concept_id in (
          select descendant_concept_id as drug_concept_id from @cdmDatabaseSchema.concept_ancestor ca1
          where ancestor_concept_id in (@drug_classification_id_input)  --(21601387) /* Antineoplastic Agents ATC classification*/
) OR c.concept_id IN ()
and c.concept_class_id = 'Ingredient'
)

select *
into @writeDatabaseSchema.@cohortTable
from CTE_second;

select * into  @writeDatabaseSchema.@regimenTable
from @writeDatabaseSchema.@cohortTable;

grant all on @writeDatabaseSchema.@cohortTable to etl_dev;
grant all on @writeDatabaseSchema.@regimenTable to etl_dev;
