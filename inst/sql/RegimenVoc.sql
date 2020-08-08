--3: (optional) Create @writeDatabaseSchema.@vocabularyTable
drop table if exists @writeDatabaseSchema.@vocabularyTable;

--Creating a component-based "combo_name" for each reimgne by getting all concepts in HemOnc
--that has a "is antineoplastic of" relationship and performing a comma-separated string aggregate of all
--concept_names of its components
with CTE as (
select cs.concept_synonym_name as regimen_name,
     string_agg(c2.concept_name, ', '   order by c2.concept_name asc) as component_comb_name,
     c1.concept_id as component_id
from @cdmDatabaseSchema.concept_relationship 
join @cdmDatabaseSchema.concept c1 on c1.concept_id=concept_id_1
join @cdmDatabaseSchema.concept c2 on c2.concept_id=concept_id_2
join @cdmDatabaseSchema.concept_synonym cs ON cs.concept_id=concept_id_1
where c1.vocabulary_id='HemOnc' and relationship_id='Has antineoplastic'
group by c1.concept_name,c1.concept_id
order by c1.concept_name
),
CTE_second as (
--After replacing all " and " with "," in the combo_name, if it equals the native regimen concept_name, it receives a rank of 0
--All obs that does not rank 0, the combo_name is ranked in sequential order by the length of c.reg_name
select c.*, (case when lower(regimen_name) = regexp_replace(component_comb_name,', ',' and ') then 0
			 else row_number() over (partition by component_comb_name order by length(c.regimen_name)) end ) as rank
from CTE c
order by rank desc
),
--Minimum rank value by combo_name is filtered for
CTE_third as (
select *,min(rank) over (partition by component_comb_name)
from CTE_second
),
CTE_fourth as (
select ct.reg_name, ct.component_comb_name, ct.concept_id
from CTE_third ct
where rank = min
)

select *
into @writeDatabaseSchema.@vocabularyTable
from CTE_fourth
