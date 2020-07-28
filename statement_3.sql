with CTE_second as (
select
       lower(c.concept_name) as concept_name,
       de.drug_exposure_id,
       de.person_id,
       de.drug_concept_id,
       de.drug_exposure_start_date as ingredient_start_date,
       de.drug_exposure_end_date as ingredient_end_date
from omop_cdm_2.drug_exposure de
inner join omop_cdm_2.cohort ch on ch.drug_exposure_id = de.drug_exposure_id
inner join omop_cdm_2.concept_ancestor ca on ca.descendant_concept_id = de.drug_concept_id
inner join omop_cdm_2.concept c on c.concept_id = ca.ancestor_concept_id
    where c.concept_id in (
          select descendant_concept_id as drug_concept_id from omop_cdm_2.concept_ancestor ca1
          where ancestor_concept_id in (21601387,35807188,35807277,35807189)  --(21601387) /* Antineoplastic Agents ATC classification*/
)
and c.concept_class_id = 'Ingredient'
)

select *
into patelm9.ONCOREGIMENFINDER_COHORT
from CTE_second