
/*
KROK 1
INICIALIZUJEME SI SI TABULKU PRO STAGING LUCAS POINTS
 */

CREATE TABLE lucas.staging_lucas_points (
POINT_ID SERIAL PRIMARY KEY,
GPS_LAT DOUBLE PRECISION,
GPS_LONG DOUBLE PRECISION,
LC1 VARCHAR(50),
LC1_PERC DOUBLE PRECISION,
PARCEL_AREA_HA DOUBLE PRECISION
);

-- A PRO LOOKUP
CREATE TABLE lucas.land_cover_types (
code VARCHAR(50) PRIMARY KEY,
name VARCHAR(50)
);

-- A PRO FINALNI TABULKU
CREATE TABLE lucas.lucas_points (
POINT_ID SERIAL PRIMARY KEY,
latitude DOUBLE PRECISION NOT NULL,
longitude DOUBLE PRECISION NOT NULL,
land_cover VARCHAR(50) REFERENCES land_cover_types(code),
year INT DEFAULT 2018 NOT NULL,
geom GEOMETRY(Point, 4326)
);




/* 
KROK 2
Vytvorime si tabulku pro lookup mezi kodem a nazvem land cover
*/
CREATE TABLE land_cover_types (
 LC1 VARCHAR(5) PRIMARY KEY,
 description TEXT
);




/*
TENTO KROK ZATIM PRESKOCIME
VYTVORIME SI TABULKU PRO LUCAS POINTS
pozor, nemuze fungovat dokud neni naplnena tabulka land_cover_types
*/
CREATE TABLE IF NOT EXISTS lucas_points (
POINT_ID VARCHAR(50) PRIMARY KEY,
latitude DOUBLE PRECISION NOT NULL,
longitude DOUBLE PRECISION NOT NULL,
land_cover VARCHAR(50) REFERENCES land_cover_types(LC1),
year INT DEFAULT 2018 NOT NULL,
geom GEOMETRY(Point, 4326)
);


-- KROK 3
/*MUSIME SE PRIHLASIT PRES PSQL*/
-- C:\Users\zapletajaku\TEMP\postgresql15postgis3_cmd_win\postgresql15postgis3_win\bin> .\psql -d pdbzapletal -h osgeo.natur.cuni.cz -U zapletal




/*
KROK 4
Do staging_lucas_points nacteme data z csv souboru*/
--TAKHLE NE
COPY lucas.staging_lucas_points (POINT_ID, GPS_LAT, GPS_LON, LC1)
FROM 'J:\lukas_data\lucas_data.csv' WITH CSV HEADER;

-- TAK TAKY NE
COPY lucas.staging_lucas_points (POINT_ID, GPS_LAT, GPS_LON, LC1)
FROM 'J:\lukas_data\lucas_data.csv' WITH CSV HEADER;

-- TAKHLE TO FUNGUJE
\copy lucas.staging_lucas_points ("point_id", "gps_lat", "gps_long", "lc1", "lc1_perc", "parcel_area_ha") FROM 'J:/lukas_data/lucas_data_filter.csv' DELIMITER ',' CSV HEADER;




-- KROK 5
-- Nyni vybereme vsechny unikatni ids a vlozime je do lookup tables, ALE NAKONEC TO UDELAME Z JINE TABULKY!!!
INSERT INTO lucas.land_cover_types (lc1, description)
SELECT DISTINCT lc1, NULL
FROM lucas.staging_lucas_points;

-- A sice takto:
\copy lucas.land_cover_types ("code", "name") FROM 'J:\lukas_data\11_LUCAS_kody_nazvy.csv' DELIMITER ';' CSV HEADER;


/*
KROK 6
Nyni si incializujeme tabulku pro konecne ulozeni LUCAS points
*/
CREATE TABLE lucas.lucas_points (
id SERIAL PRIMARY KEY,
latitude DOUBLE PRECISION NOT NULL,
longitude DOUBLE PRECISION NOT NULL,
land_cover VARCHAR(50) REFERENCES lucas.land_cover_types(code),
year INT NOT NULL,
geom GEOMETRY(Point, 4326)
)



/*
KROK 7
Přenos čistých dat do konečné tabulky
Transformujte a přesuňte data z tabulky staging do tabulky lucas_points a přidejte 
geometrii:
*/

INSERT INTO lucas.lucas_points (latitude, longitude, land_cover, year, geom)
SELECT
gps_lat,
gps_long,
lc1,
2018,
ST_SetSRID(ST_MakePoint(gps_long, gps_lat), 4326)
FROM lucas.staging_lucas_points


/*
KROK 8
Naimportujeme geometrii okresu do databaze
*/


ogr2ogr -f "PostgreSQL" PG:"dbname=pdb_zapletal user=zapletal password=gkd2024 host=osgeo.natur.cuni.cz" "J:/lukas_data/okresy_4326.shp" -nln lucas.obce -overwrite


-- POCET bodu, ktere zacinaji C v okresu - agregace

SELECT lucas.okresy_4326.nazev, lucas.okresy_4326.geom, COUNT(*)
FROM lucas.lucas_points
JOIN lucas.okresy_4326
ON ST_Within(lucas.lucas_points.geom, lucas.okresy_4326.geom)
WHERE lucas.lucas_points.land_cover LIKE 'C%'
GROUP BY lucas.okresy_4326.nazev, lucas.okresy_4326.geom
ORDER BY COUNT(*) DESC