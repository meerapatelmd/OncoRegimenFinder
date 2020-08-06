WITH relationships AS (
SELECT DISTINCT concept_id_1 AS relationship_concept_id 
FROM @schema.concept_relationship  
WHERE @schema.concept_relationship.concept_id_2 IN (@concept_ids) 
UNION 
SELECT DISTINCT concept_id_2 AS relationship_concept_id   
FROM @schema.concept_relationship  
WHERE @schema.concept_relationship.concept_id_1 IN (@concept_ids) 
)

SELECT * 
FROM relationships 
LEFT JOIN @schema.concept c 
ON c.concept_id = relationship_concept_id  
WHERE c.vocabulary_id IN ('RxNorm', 'RxNorm Extension') 
AND c.concept_class_id IN ('Ingredient', 'Precise Ingredient');
