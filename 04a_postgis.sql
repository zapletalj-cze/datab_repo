-- Create table to natur.cuni server using PostGIS extension

-- Connect to server using credentials provided
-- C:\Users\zapletajaku\TEMP\postgresql15postgis3_cmd_win\postgresql15postgis3_win\bin> .\psql -d pdbzapletal -h osgeo.natur.cuni.cz -U zapletal

-- Check if extension is installed
SELECT * FROM pg_available_extensions;

-- CREATE TABLE
CREATE TABLE jtable
(geom geometry NOT NULL);

-- ADD COLUMNS to table
ALTER TABLE jtable
ADD column id SERIAL PRIMARY KEY,
ADD COLUMN kodbodu CHAR(20);


-- INSERT DATA INTO TABLE

INSERT INTO jtable (geom, id, kodbodu)
VALUES 
    (ST_GeomFromText('POINT(14.1 50.0)', 4326), 1, 'a'),
    (ST_GeomFromText('POINT(14.4 50.2)', 4326), 2, 'b'),
    (ST_GeomFromText('POINT(14.7 50.3)', 4326), 3, 'c');



-- OGR COMMAND to import data to db

-- Modify the ogr2ogr command to include the necessary parameters for importing data into the PostgreSQL database
-- Use double quotes for the connection string and escape the backslashes in the file path

ogr2ogr -f PostgreSQL "PG:dbname=pdbzapletal host=osgeo.natur.cuni.cz user=zapletal password=gkd2024" J:/datab_repo/data/04_postgis/mesta.shp -a_srs EPSG:4326

.\ogr2ogr -f PostgreSQL "PG:dbname=pdbzapletal host=osgeo.natur.cuni.cz user=zapletal password=gkd2024" J:/datab_repo/data/04_postgis/mesta.shp -a_srs EPSG:4326

.\ogr2ogr -f PostgreSQL PG:'dbname=pdbzapletal host=osgeo.natur.cuni.cz user=zapletal password=gkd2024' J:\datab_repo\data\04_postgis\zeme_sveta.gpkg -a_srs EPSG:4326



-- Step 1: Create the table
CREATE TABLE body (
    id INTEGER PRIMARY KEY,
    X DOUBLE PRECISION,
    Y DOUBLE PRECISION
);

\copy body (id, x, y) FROM 'J:/datab_repo/data/04_postgis/body_4326.csv' DELIMITER ',' CSV HEADER;