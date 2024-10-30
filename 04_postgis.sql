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
    (ST_GeomFromText('POINT(14.4 50.2)', 4326), 2, 'b'),
    (ST_GeomFromText('POINT(14.7 50.3)', 4326), 3, 'c');
