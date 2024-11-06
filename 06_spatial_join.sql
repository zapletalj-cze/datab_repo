/*
Vybrat obce z RUIAN, ve kterých se nachází požární stanice z OSM
*/

SELECT ogc_fid, nazev
FROM ruian.obce as obce
JOIN osm.pozarni_stanice as stanice 
ON St_Contains(obce.geom, stanice.geom)


/*
Vybrat obce z RUIAN, ve kterých se nachází více neý jedna pořární stanice z OSM
*/
SELECT obce.ogc_fid, obce.nazev, COUNT(stanice.*) AS stanice_count
FROM ruian.obce as obce
JOIN osm.pozarni_stanice as stanice 
ON St_Contains(obce.geom, stanice.geom)
GROUP BY obce.ogc_fid, obce.nazev
HAVING COUNT(stanice.*) > 1


-- Na území které obce leží nejvíce požárních stanic?

SELECT ogc_fid, nazev, COUNT(stanice.*)
FROM ruian.obce as obce
JOIN osm.pozarni_stanice as stanice 
ON St_Contains(obce.geom, stanice.geom)
GROUP BY obce.ogc_fid
HAVING COUNT(stanice.*) > 1
ORDER BY COUNT(stanice.*) DESC
LIMIT 1


--- Kterymi obcemi prochazi 50. rovnobezka
SELECT ogc_fid, nazev, geom
FROM ruian.obce as obce
WHERE ST_Intersects(obce.geom, ST_Transform(ST_GeomFromText('LINESTRING(10.5 50, 18.5 50)', 4326), 5514))


-- Ktere ulice sousedi s ulici Albertov
----  Solution 01
SELECT ulice.nazev, ulice.ogc_fid, ulice.geom
FROM ruian_praha.ulice as ulice
JOIN
	(SELECT * FROM ruian_praha.ulice WHERE nazev = 'Albertov') as sel 
	ON St_Touches(ulice.geom, sel.geom)

UNION

SELECT ulice.nazev, ulice.ogc_fid, ulice.geom
FROM ruian_praha.ulice as ulice
JOIN
	(SELECT * FROM ruian_praha.ulice WHERE nazev = 'Albertov') as sel 
	ON st_crosses(ulice.geom, sel.geom)


----  Solution 02
SELECT ulice.nazev, ulice.ogc_fid, ulice.geom
FROM ruian_praha.ulice as ulice
JOIN
	(SELECT * FROM ruian_praha.ulice WHERE nazev = 'Albertov') as sel 
	ON St_Intersects(ulice.geom, sel.geom) AND NOT St_Equals(ulice.geom, sel.geom)
	


-- Ktere mesto lezi v zemi s ID 154
SELECT name, geom
FROM populated_places
JOIN
	(SELECT id, geom as selgeom FROM countries WHERE id = '154') as sel 
	ON ST_Within(populated_places.geom, sel.selgeom)

-- V jake zemi lezi mesto s ID 154
SELECT name, pop2020, geom
FROM populated_places
JOIN
    (SELECT id, admin, geom as selgeom FROM countries WHERE id = '154') as sel 
    ON St_Within(populated_places.geom, sel.selgeom)
ORDER BY pop2020 DESC
LIMIT 10 
	

SELECT name, pop2020, max_areakm, geom
FROM populated_places
JOIN
    (SELECT id, admin,  geom as selgeom FROM countries) as sel 
    ON St_Within(populated_places.geom, sel.selgeom)
ORDER BY max_areakm DESC
LIMIT 10 


-- Vyber zeme, kterymi proteka Duunaj
SELECT admin, geom
FROM countries
JOIN
    (SELECT name, geom as selgeom FROM rivers_lake_centerlines WHERE name = 'Donau') as sel 
    ON St_intersects(countries.geom, sel.selgeom)


-- Pridej hlavni mesta zemi, kterymi proteka Dunaj
SELECT countries.admin, populated_places.name, countries.geom, populated_places.geom, St_Contains(countries.geom, populated_places.geom)
FROM countries
JOIN
    (SELECT name, rivers_lake_centerlines.geom FROM rivers_lake_centerlines WHERE name = 'Donau') as rivers_lake_centerlines
    ON St_intersects(countries.geom,  rivers_lake_centerlines.geom)


	

	