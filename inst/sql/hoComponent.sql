SELECT DISTINCT concept_id 
FROM @schema.concept c 
WHERE c.vocabulary_id = 'HemOnc' 
        AND c.concept_class_id = 'Component'
;
