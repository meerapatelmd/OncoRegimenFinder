--4 Create @writeDatabaseSchema.@regimenIngredientTable
drop table if exists  @writeDatabaseSchema.@regimenIngredientTable;

--Aggregating ingredients in @writeDatabaseSchema.@regimenTable in a comma-separated string based on patient and ingredient_start_date,
--now regimen_start_date
with cte as (
select r.person_id, 
       r.ingredient_start_date AS derived_regimen_start_date,
       string_agg(distinct r.ingredient_name, ', '   order by r.ingredient_name asc) as derived_regimen_name
from @writeDatabaseSchema.@regimenTable r
group by r.person_id, r.ingredient_start_date
)
--Joining ingredient details with regimen information and regimen_end_date is derived from max ingredient end date in groupings of regimen_start_date and patient identifier
select  cte.person_id, 
        orig.drug_exposure_id, 
        i.ingredient_name, i.ingredient_start_date, i.ingredient_end_date,
        cte.derived_regimen_name, 
        vt.regimen_id, 
        vt.regimen_name, 
        cte.derived_regimen_start_date, 
        max(i.ingredient_end_date) over (partition by cte.derived_regimen_start_date, cte.person_id) as derived_regimen_end_date
into @writeDatabaseSchema.@regimenIngredientTable
from @writeDatabaseSchema.@regimenTable orig
left join cte on cte.person_id = orig.person_id and cte.derived_regimen_start_date = orig.ingredient_start_date
left join @writeDatabaseSchema.@cohortTable i on i.person_id = orig.person_id and i.drug_exposure_id = orig.drug_exposure_id
left join @writeDatabaseSchema.@vocabularyTable vt on cte.derived_regimen_name = vt.ingredient_combination
order by cte.person_id, cte.derived_regimen_start_date
