-- 3.1. Z dat v tabulce `tmp_okresy` vytvořte tabulku jihočeského kraje `jk_okresy` (krajkod=33).
-- 3.2 Vytvořte tabulku požárních stanic sídlící v jihočeském kraji, `jk_pozarni_stanice`.
-- 3.3 Zkontrolujte projekce jednotlivých tabulek, případně re-projektujte do společného 

INSERT INTO zapocet.okresy (ogc_fid, kod, nazev, krajkod, vusckod, geom)
SELECT ogc_fid, kod, nazev, krajkod, vusckod, geom
FROM zapocet.tmp_okresy;
WHERE krajkod = 33;

-- rename tables
ALTER TABLE zapocet.okresy
RENAME TO jk_okresy;

ALTER TABLE zapocet.pozarni_stanice
RENAME TO jk_pozarni_stanice;

-- insert new column to tmp_stanice and set data type to boolean
ALTER TABLE zapocet.tmp_stanice
ADD COLUMN jk_pozarni_stanice BOOLEAN;


-- update column
UPDATE zapocet.tmp_stanice
SET jk_pozarni_stanice = TRUE
WHERE ST_Within(geom,(SELECT ST_Union(geom) FROM zapocet.jk_okresy));


-- INSERT TO jk_pozarni_stanice all fire stations JCK based on newly created atb
INSERT INTO zapocet.jk_pozarni_stanice (id, osm_id, geom)
SELECT id, osm_id, geom
FROM zapocet.tmp_stanice
WHERE jk_pozarni_stanice = TRUE;









