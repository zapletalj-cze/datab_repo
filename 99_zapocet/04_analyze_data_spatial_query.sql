--  3.4 Identifikujte okres se souřadnicí `longitude = 14,217` a `latitude = 49,405`.
--  3.5 Spočítejte počet požárních stanic v tomto okresu.
--  3.6 Vypočítejte podíl stanic v tomto okrese k celkovému počtu v JK.


-- IDENTIFY DISTRICT WITH GIVEN COORDINATES
SELECT nazev, geom, ST_Within(ST_SetSRID(ST_MakePoint(14.217, 49.405), 4326), geom)
FROM zapocet.jk_okresy
WHERE ST_INTERSECTS(ST_SetSRID(ST_MakePoint(14.217, 49.405), 4326), geom);


-- COUNT FIRE STATIONS IN THE DISTRICT
SELECT COUNT(*), ROUND(COUNT(*)::numeric / (SELECT COUNT(*) FROM zapocet.jk_pozarni_stanice)::numeric, 2) as podil_stanic
FROM zapocet.jk_pozarni_stanice
WHERE ST_Within(geom, (SELECT geom FROM zapocet.jk_okresy WHERE nazev = 'Písek'));

SELECT id, osm_id, geom
FROM zapocet.jk_pozarni_stanice
WHERE ST_Within(geom, (SELECT geom FROM zapocet.jk_okresy WHERE nazev = 'Písek'));
