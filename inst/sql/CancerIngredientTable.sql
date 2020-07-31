DROP TABLE IF EXISTS @schema.ho_rxnorm_ingredients;

WITH hemonc_component_classes AS (
        SELECT DISTINCT concept_id  
        FROM @schema.concept c 
        WHERE c.vocabulary_id = 'HemOnc' 
                AND c.concept_class_id = 'Component'
),
hemonc_relationships AS (
SELECT DISTINCT concept_id_2 
FROM hemonc_component_classes 
),
hemonc_rxnorm_ingredients AS (
SELECT * 
FROM hemonc_relatives 
LEFT JOIN @schema.concept c2 
ON c2.concept_id = relative_concept_id 
WHERE c2.vocabulary_id IN ('RxNorm', 'RxNorm Extension') 
        AND c2.concept_class_id IN ('Ingredient', 'Precise Ingredient') 
)
SELECT * 
INTO @schema.ho_rxnorm_ingredients 
FROM hemonc_rxnorm_ingredients;
