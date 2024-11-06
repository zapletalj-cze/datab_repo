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
