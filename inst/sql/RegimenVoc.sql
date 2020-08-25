--3: (optional) Create @writeDatabaseSchema.@vocabularyTable
drop table if exists @writeDatabaseSchema.@vocabularyTable;

--Creating a component-based "combo_name" for each reimgne by getting all concepts in HemOnc
--that has a "is antineoplastic of" relationship and performing a comma-separated string aggregate of all
--concept_names of its components
CREATE TABLE @writeDatabaseSchema.@vocabularyTable  AS (
select 
        c1.concept_id as regimen_id,
        c1.concept_name as regimen_name,
        c2.concept_id as component_id,
        c2.concept_name as component_name,
        c3.concept_id as ingredient_id,
        c3.concept_name as ingredient_name
from @cdmDatabaseSchema.concept_relationship cr1
join @cdmDatabaseSchema.concept c1 on c1.concept_id=cr1.concept_id_1
join @cdmDatabaseSchema.concept c2 on c2.concept_id=cr1.concept_id_2
join @cdmDatabaseSchema.concept_relationship cr2 ON cr1.concept_id_2 = cr2.concept_id_1 
join @cdmDatabaseSchema.concept c3 ON c3.concept_id = cr2.concept_id_2 
where 
        c1.vocabulary_id='HemOnc' AND
        cr1.relationship_id='Has antineoplastic' AND 
        c3.concept_class_id IN ('Ingredient', 'Precise Ingredient') AND
        c1.concept_id NOT IN (
                        SELECT  c.concept_id
                        FROM @cdmDatabaseSchema.concept c 
                        LEFT JOIN @cdmDatabaseSchema.concept_relationship cr 
                        ON c.concept_id = cr.concept_id_1 
                        WHERE 
                                c.vocabulary_id = 'HemOnc' AND 
                                c.concept_class_id = 'Regimen' AND 
                                cr.relationship_id = 'Has modality' AND
                                cr.concept_id_2 = 35803411
                                )
order by c1.concept_id
);

grant all on @writeDatabaseSchema.@vocabularyTable to etl_dev;
