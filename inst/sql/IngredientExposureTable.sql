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
into @writeDatabaseSchema.@drugExposureIngredientTable
from ingredient_exposures;
