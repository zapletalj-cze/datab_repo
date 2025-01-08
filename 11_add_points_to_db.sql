
INSERT INTO final_points (id, year, geometry)
SELECT 
    id, 
    year, 
    geometry
FROM stage_points
WHERE 
    -- Check if geometry is valid AND is not empty
    ST_IsValid(geometry)  
    AND NOT ST_IsEmpty(geometry)
    AND id IS NOT NULL 
    AND year IS NOT NULL;
