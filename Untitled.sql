SELECT DISTINCT concept_id_2 
FROM hemonc_component 
LEFT JOIN @schema.concept_relationship cr 
ON concept_id = cr.concept_id_1 
LEFT JOIN @schema.concept c2 
ON c2.concept_id = cr.concept_id_2 
WHERE c2.concept_class_id = 'Component Class' AND cr.relationship_id = 'Is a' 
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
