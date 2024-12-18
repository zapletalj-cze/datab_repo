/*
VYTVORIME SI TABULKU PRO STAGING LUCAS POINTS
 */

CREATE TABLE staging_lucas_points (
POINT_ID SERIAL PRIMARY KEY,
GPS_LAT DOUBLE PRECISION,
GPS_LONG DOUBLE PRECISION,
LC1 VARCHAR(50),
LC1_PERC DOUBLE PRECISION,
PARCEL_AREA_HA DOUBLE PRECISION
);

CREATE TABLE staging_lucas_points (
POINT_ID SERIAL PRIMARY KEY,
GPS_LAT DOUBLE PRECISION,
GPS_LON DOUBLE PRECISION,
LC1 VARCHAR(50)
);


/* 
Vytvorime si tabulku pro lookup mezi kodem a nazvem land cover
*/
CREATE TABLE land_cover_types (
 LC1 VARCHAR(5) PRIMARY KEY,
 description TEXT
);


/*
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

/*MUSIME SE PRIHLASIT PRES PSQL*/


/*Do staging_lucas_points nacteme data z csv souboru*/
--TAKHLE NE
COPY lucas.staging_lucas_points (POINT_ID, GPS_LAT, GPS_LON, LC1)
FROM 'J:\lukas_data\lucas_data.csv' WITH CSV HEADER;

-- TAK TAKY NE
COPY lucas.staging_lucas_points (POINT_ID, GPS_LAT, GPS_LON, LC1)
FROM 'J:\lukas_data\lucas_data.csv' WITH CSV HEADER;


\copy lucas.staging_lucas_points ("point_id", "gps_lat", "gps_long", "lc1", "lc1_perc", "parcel_area_ha") FROM 'J:/lukas_data/lucas_data_filter.csv' DELIMITER ',' CSV HEADER;
