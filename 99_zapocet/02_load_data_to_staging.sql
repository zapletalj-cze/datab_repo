-- Convert shapefiles into SQL files
./shp2pgsql -s 4326 J:\zapocet\original\okresy_4326.shp zapocet.tmp_okresy > okresy.sql;
./shp2pgsql -s 4326 J:\zapocet\original\pozarni_stanice_4326.shp zapletal.tmp_pozarni_stanice > pozarni_stanice.sql;

-- Load SQL files into the database
./psql -U zapletal -d pdbzapletal -h osgeo.natur.cuni.cz -a -f okresy.sql;
./psql -U zapletal -d pdbzapletal -h osgeo.natur.cuni.cz -a -f pozarni_stanice.sql;