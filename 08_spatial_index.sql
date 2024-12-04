-- GIST - univerzální na všechno
-- 1. Sestavení indexu
CREATE INDEX idx 
ON table_name(column_name) 
USING GIST;

-- 2. Aktualizace statistik 
VACCUM ANALYZE ...
-- 3. Vypsání prováděcího plánu
EXPLAIN ANALYZE SELECT ...

-- SP-GIST Dobrý pro malá data, 
CREATE INDEX idx 
ON table 
USING SPGIST
(geometry_column); 


-- BRIN - Big data s globálním pokrytím
CREATE INDEX idx 
On table 
USING brin(column) -- sloupec s geometrii
WITH(pages_per_range=10);

-- NEJPRVE JSEM SI IMPORTOVAL DATA DO DATABAZE PBDZAPLETAL
-- DB SCHEME JSEM SI POJMENOVAL JAKO cviceni7

-- UKOL 01
-- Kolik požárních stanic leží uvnitř okresu s kódem nuts='CZ0100’

EXPLAIN analyse
SELECT count(*)
FROM cviceni7.pozarni_stanice AS ps
JOIN (SELECT * FROM cviceni7.okresy WHERE nutslau = 'CZ0100') AS o
ON ST_Within(ps.geom, o.geom);

/*
-- returns: 
BEZ INDEXACE:

QUERY PLAN
Planning Time: 1.483 ms
Execution Time: 19.650 ms

QUERY PLAN
Planning Time: 1.398 ms
Execution Time: 1.505 ms

S INDEXACI:
*/

-- TAKTO SE INDEXUJE: 
CREATE INDEX idx  -- nazev indexu se tvori mimo tabulku, proto je dobre pojmenovat treba idx_silnice, idx_whatever
 ON cviceni7.okresy 
 USING gist (geom);


/* UKOL2 
Kolikrát je rychlejší prostorový dotaz výběru okresů které 
mají na svém území silnici první třídy (typ=1) při 
použití prostorové indexace GIST v PostGIS oproti 
datům neidexovaným? 
*/

EXPLAIN analyse
SELECT count(*)
FROM cviceni7.okresy AS o
JOIN cviceni7.silnice AS s
ON ST_Within(s.geom, o.geom)
WHERE s.typ = 1;

/*
BEZ INDEXACE:
QUERY PLAN
Planning Time: 2.347 ms
Execution Time: 911.460 ms

S INDEXACI:
QUERY PLAN
Planning Time: 1.619 ms
Execution Time: 212.512 ms
--
*/

-- UKOL 03
-- Připravte CORINE land cover 2018 (EPSG:3035) pro území definované hranicemi nutslau='CZ0317’, okresy (EPSG:5514).
-- Výsledná vrstva land cover bude obsahovat kód tříd land cover dle této definice:
-- 1 … Artificial  surfaces (vsechny krome zelene ve mestech)
-- 14 … Urban green
-- 2 … Arable land
-- 3 … Forest
-- 4 ... Wetlands
-- 5 ... Water bodies


EXPLAIN ANALYSE
SELECT clc.objectid, clc.code_18, clc.c18, clc.geom
FROM cviceni7.clc18_cz_3035 AS clc
JOIN cviceni7.okresy AS o
    ON ST_Within(clc.geom, ST_Transform(ST_SETSRID(o.geom,5514), 3035))
    WHERE o.nutslau = 'CZ0317'
    AND clc.code_18 LIKE '1%'  OR clc.code_18 LIKE '24%' OR clc.code_18 LIKE '3%' OR clc.code_18 LIKE '4%' OR clc.code_18 LIKE '5%'


SELECT clc.objectid, clc.code_18, clc.c18, clc.geom
FROM cviceni7.clc18_cz_3035 AS clc
JOIN cviceni7.okresy AS o
ON ST_Intersets(clc.geom, ST_Transform(ST_SETSRID(o.geom, 5514), 3035))
WHERE o.nutslau = 'CZ0317'
    AND (
        clc.code_18 LIKE '1%' 
        OR clc.code_18 LIKE '24%' 
        OR clc.code_18 LIKE '31%' 
        OR clc.code_18 LIKE '4%' 
        OR clc.code_18 LIKE '5%'
    )
    AND NOT clc.code_18 LIKE '14%';