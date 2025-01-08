/*
Vytvořte ve vlastní DB tabulky: `tmp_okresy` a `tmp_pozarni_stanice`. Tyto vstupní tabulky jsou dočasné (pracovní) tabulky 'staging table'.
Tyto vstupní tabulky jsou dočasné (pracovní) tabulky 'staging table'.
*/

-- Created staging and final tables for the project
-- Refactored fields in okresy shapefile: ogc_fid, kod, nazev, krajkod, vusckod, geom remained in the final version for import to staging table

CREATE TABLE IF NOT EXISTS zapocet.tmp_pozarni_stanice (
id SERIAL PRIMARY KEY,
osm_id FLOAT,
geom GEOMETRY(Point, 4326)
);


CREATE TABLE IF NOT EXISTS zapocet.tmp_okresy (
id SERIAL PRIMARY KEY,
ogc_fid INTEGER PRIMARY KEY,
kod INTEGER,
nazev VARCHAR(32),
krajkod INTEGER,
vusckod INTEGER,
geom GEOMETRY(MULTIPOLYGON, 4326)
);


CREATE TABLE IF NOT EXISTS zapocet.pozarni_stanice (
id SERIAL PRIMARY KEY,
osm_id FLOAT,
geom GEOMETRY(Point, 4326)
);

CREATE TABLE IF NOT EXISTS zapocet.okresy (
id SERIAL PRIMARY KEY,
ogc_fid INTEGER,
kod INTEGER,
nazev VARCHAR(32),
krajkod INTEGER,
vusckod INTEGER,
geom GEOMETRY(MULTIPOLYGON, 4326)
);