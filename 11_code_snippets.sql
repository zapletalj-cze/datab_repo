-- Create PostgreSQL database and enable PostGIS extension
-- Command line instructions
createdb -h osgeo.natur.cuni.cz -U annab T2brazdova;
psql -d T2brazdova -h osgeo.natur.cuni.cz -U annab;
CREATE EXTENSION postgis;

-- Convert shapefiles into SQL files
shp2pgsql -s 4326 J:\databaze\test_2_geodata\countries_cities_shp\countries.shp public.countries > countries.sql;
shp2pgsql -s 4326 J:\databaze\test_2_geodata\countries_cities_shp\cities.shp public.cities > cities.sql;

-- Load SQL files into the database
psql -U annab -d T2brazdova -h osgeo.natur.cuni.cz -a -f countries.sql;
psql -U annab -d T2brazdova -h osgeo.natur.cuni.cz -a -f cities.sql;

-- Create temporary tables for cities and countries
CREATE TABLE tmp_cities (
    id serial NOT NULL,
    city_name char(50),
    country_iso3_code char(50),
    featurecla char(50),
    population numeric(50),
    geog geometry NOT NULL,
    CONSTRAINT pk_id PRIMARY KEY (id)
);

CREATE TABLE tmp_countries (
    id serial NOT NULL,
    formal_name char(50),
    country_iso3 char(50),
    population numeric,
    gdp numeric,
    economy char(50),
    income_group char(50),
    continent char(50),
    subregion char(50),
    region_world_bank char(50),
    geog geometry NOT NULL,
    CONSTRAINT pk_id2 PRIMARY KEY (formal_name)
);

-- Populate temporary tables
INSERT INTO tmp_cities (city_name, country_iso3_code, featurecla, population, geog)
SELECT cities.nameascii, cities.adm0_a3, cities.featurecla, cities.pop2020, cities.geom
FROM cities;

INSERT INTO tmp_countries (formal_name, country_iso3, population, gdp, economy, income_group, continent, subregion, region_world_bank, geog)
SELECT c.name, c.iso_a3, c.pop_est, c.gdp_md_est, c.economy, c.income_grp, c.continent, c.subregion, c.region_wb, c.geom
FROM countries AS c;

-- Create and populate table for European countries
CREATE TABLE eu_countries (
    id serial NOT NULL,
    formal_name char(50),
    country_iso3 char(50),
    population numeric,
    gdp numeric,
    economy char(50),
    income_group char(50),
    continent char(50),
    subregion char(50),
    region_world_bank char(50),
    geog geometry NOT NULL,
    CONSTRAINT pk_id3 PRIMARY KEY (formal_name)
);

INSERT INTO eu_countries
SELECT * FROM tmp_countries
WHERE continent = 'Europe';

-- Create and populate table for European cities
CREATE TABLE eu_cities (
    id serial NOT NULL,
    city_name char(50),
    country_iso3_code char(50),
    featurecla char(50),
    population numeric(50),
    geog geometry NOT NULL,
    CONSTRAINT pk_id4 PRIMARY KEY (id)
);

INSERT INTO eu_cities
SELECT ci.id, ci.city_name, ci.country_iso3_code, ci.featurecla, ci.population, ci.geog
FROM tmp_cities AS ci
JOIN tmp_countries ON ci.country_iso3_code = tmp_countries.country_iso3
WHERE continent = 'Europe';

-- Modify geometry columns to a new coordinate reference system (EPSG:3035)
ALTER TABLE eu_countries
RENAME COLUMN geog TO geom;

ALTER TABLE eu_countries
ALTER COLUMN geom TYPE geometry(MULTIPOLYGON, 3035)
USING ST_Transform(geom::geometry, 3035);

ALTER TABLE eu_cities
RENAME COLUMN geog TO geom;

ALTER TABLE eu_cities
ALTER COLUMN geom TYPE geometry(POINT, 3035)
USING ST_Transform(geom::geometry, 3035);

-- Query countries containing a specific point
SELECT eu_countries.formal_name, point.geom
FROM eu_countries
JOIN (
    SELECT 1 AS id, ST_Transform('SRID=4326;POINT(7.917 45.953)', 3035) AS geom
) AS point
ON ST_Contains(eu_countries.geom, point.geom);

-- Calculate area of a specific country in square kilometers
SELECT formal_name, ST_Area(geom) / 1000000 AS areakm2
FROM eu_countries
WHERE formal_name = 'Switzerland';

-- Calculate distance from a specific point to a city
SELECT
    CAST(
        ST_Distance(
            ST_Transform(ST_SetSRID(ST_MakePoint(7.917, 45.953), 4326), 3035),
            (SELECT geom FROM eu_cities WHERE city_name = 'Prague')
        ) / 1000 AS numeric
    ) AS distance_km;

-- Export European countries and cities as shapefiles
pgsql2shp -u annab -h osgeo.natur.cuni.cz -P gkDPZ23 -f J:\databaze\eu_countries.shp T2brazdova public.eu_countries;
pgsql2shp -u annab -h osgeo.natur.cuni.cz -P gkDPZ23 -f J:\databaze\eu_cities.shp T2brazdova public.eu_cities;
