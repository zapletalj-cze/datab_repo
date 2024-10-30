
-- This query retrieves the area of the first geometry in the dibavod.vodni_nadrze table:
SELECT gid, ST_Perimeter(dibavod.vodni_nadrze) AS length
FROM dibavod.vodni_nadrze
LIMIT 1


-- This query retrieves the spatial reference as EPSG code and geometry type of the first geometry in the ruian.okresy table:
SELECT st_srid(geom), st_geometrytype(geom)
from ruian.okresy
limit 1 



-- This query retrieves various spatial properties of the first geometry in the ruian.okresy table:
-- 1. ST_CoordDim(geom): Coordinate dimension (e.g., 2D, 3D)
-- 2. ST_Dimension(geom): Inherent dimension (e.g., point, line, polygon)
-- 3. ST_IsCollection(geom): Checks if the geometry is a collection (boolean)
-- 4. ST_NumGeometries(geom): Number of geometries in a collection
-- 5. ST_NumInteriorRings(geom): Number of interior rings (holes) in a polygon
-- 6. ST_IsValid(geom): Checks if the geometry is valid (boolean)
-- 7. ST_IsClosed(geom): Checks if the geometry is closed (e.g., a linestring)
-- 8. ST_IsRing(geom): Checks if the geometry is a ring (e.g., a closed linestring)

SELECT ST_CoordDim(geom), 
       ST_Dimension(geom), 
       ST_IsCollection(geom),
       ST_NumGeometries(geom), 
       ST_NumInteriorRings(geom), 
       ST_IsValid(geom),
FROM ruian.okresy
LIMIT 1;

-- This query retrieves the area of the first geometry in the dibavod.vodni_nadrze table:
-- 1. ST_IsClosed(geom): Checks if the geometry is closed (e.g., a linestring)
-- 2. ST_IsRing(geom): Checks if the geometry is a ring (e.g., a closed linestring)
-- 2. ST_IsRing(geom): Returns TRUE if this LINESTRING is both ST_IsClosed (ST_StartPoint(g) ~= ST_Endpoint(g)) and ST_IsSimple (does not self intersect).

SELECT ST_IsClosed(geom), ST_IsRing(geom)
FROM osm.silnice
LIMIT 1;


-- SQL CODE SNIPPETS for spatial queries and conversions

-- Query snippet for spatial reference database
SELECT *
FROM spatial_ref_sys
WHERE srid = 4326

-- Query snippet for geometry columns database
SELECT * 
FROM geometry_columns

-- Creates point geometry from coordinates
SELECT ST_GeomFromText('POINT(2 2)', 4326);

-- Sets spatial reference of a geometry 
SELECT ST_SetSRID(ST_GeomFromText('POINT(2 2)'),4326);

-- Creates point geometry from coordinates with specified spatial reference
SELECT ST_SetSRID(ST_MakePoint(2, 2), 4326);

-- Converts string POINT to geometry
SELECT ST_SetSRID('POINT(2 2)'::geometry, 4326);

-- Creates WKB point from coordinates and checks if point is valid
SELECT ST_IsValid(ST_GeomFromText('POINT(14.42 50.06)'), 4326);

    -- Append geometry attribute as geometry
    SELECT ST_GeomFromText('POINT(14.42 50.06)', 4326) AS geometry,
        ST_IsValid(ST_GeomFromText('POINT(14.42 50.06)', 4326)) AS is_valid;




-- Creates WKB line from coordinates, checks if line is valid
SELECT 1 as ID, 

ST_GeomFromText('LINESTRING(14.47055532816262158 50.04017046097344945, 
                             14.47295859695484488 50.03982714263224807, 
                             14.47656349815048316 50.03982714986974401, 
                             14.48119836833829233 50.04034214492455845, 
                             14.48531825776978721 50.0398271674462336, 
                             14.48840817987100493 50.03845387798442346, 
                             14.49029646790634906 50.03708058611020704, 
                             14.49184143759497623 50.03450565946450013, 
                             14.49304308245953088 50.03227405629573354, 
                             14.49407306308122578 50.03038577694860578, 
                             14.49578969119487226 50.02866916056311908)', 4326) as geometry,
							 
st_isvalid(ST_GeomFromText('LINESTRING(14.47055532816262158 50.04017046097344945, 
                             14.47295859695484488 50.03982714263224807, 
                             14.47656349815048316 50.03982714986974401, 
                             14.48119836833829233 50.04034214492455845, 
                             14.48531825776978721 50.0398271674462336, 
                             14.48840817987100493 50.03845387798442346, 
                             14.49029646790634906 50.03708058611020704, 
                             14.49184143759497623 50.03450565946450013, 
                             14.49304308245953088 50.03227405629573354, 
                             14.49407306308122578 50.03038577694860578, 
                             14.49578969119487226 50.02866916056311908)')) as is_valid


-- Creates geometry collection from point and polygon
SELECT ST_GeomFromText('GEOMETRYCOLLECTION(POINT(2 0), POLYGON((0 0,1 0,1 1,0 1,0 0)))') AS geom;

