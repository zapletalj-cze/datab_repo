/*
Z prezentaci

PREDIKATY

*/
 ST_Equals(A, B) -- T / F - totožné
ST_Disjoint(A , B) -- T / F - žádný totožný bod
NOT ST_Intersects(A, B)
ST_Intersects(A, B) -- T/F  alespoň jeden společný 
ST_Crosses(A, B) -- T/F  společné vnitřní bod
T/F ST_Overlaps(A, B) -- - ne všechny, porovnává geometrie stejné dimenze!
ST_Touches(A, B) -- T/F - alespoň jeden společný 
ST_Contains(A, B) -- T/F- ~ T/F ST_Within(B,A)
ST_DWithin(A, B) -- T/F  ve vzdálenosti do B

/*
=========================================




Neprostorový JOIN
SELECT seznam_sloupců
FROM tabulka1 
JOIN tabulka2 
ON tabulka1.nazev=tabulka2.nazev 
[WHERE podmínka] 
[ORDER BY sloupce] 
[LIMIT počet_záznamů];

=========================================

Prostorový JOIN
SELECT seznam_sloupců
FROM tabulka1 AS t1
JOIN tabulka2 AS t2
ON ST_Predikat(t1.geom, t2.geom)
[WHERE podmínka] 
[ORDER BY sloupce] 
[LIMIT počet_záznamů];


treba takto:

SELECT [sloupce_leva_tab], [sloupce_prava_tab]
FROM leva_tab AS l
JOIN prava_tab AS p
-- pravidlo propojeni tabulek
ON ST_Intersets(l.geom, p.geom);
[WHERE podmínka] 
[ORDER BY sloupce]; 

=========================================
*/ 

-- Najděte všechna evropská města s více než 100 000 obyvateli.
SELECT mesta.name, mesta.pop_max, zeme.admin 
FROM populated_places AS mesta
JOIN 
(SELECT *
FROM admin_0_countries
WHERE continent='Europe') AS zeme 
ON ST_Contains(zeme.geom, mesta.geom)
WHERE mesta.pop_max > 100000;


-- Kolik obci sousedi s hranici cr
SELECT o.geom
FROM public.obce AS o
JOIN ( SELECT ST_ExteriorRing(ST_Union(geom)) AS geom
FROM public.kraje) AS h
ON ST_Intersects(h.geom, o.geom);


-- Kolika obcemi neprochází žádná silnice?
select o.nazev as jmeno_obce, count(*) as road_count, o.geom as o_geom
from obce as o
left join silnice as s
on st_intersects(o.geom, s.geom)
where s.geom is null
group by o.nazev, o_geom;


-- Kolik je v Jižních čechách mostů přes vodní toky? V kterém kraji nejvíce?
CREATE TABLE reky_j AS
SELECT r.id, r.geom
FROM vodni_toky as r
JOIN
(SELECT * FROM kraje
WHERE kraje.kod = 33)
AS k
ON ST_Contains(k.geom, r.geom)
GROUP BY r.id;
CREATE TABLE sil_j AS
SELECT s.id, s.geom
FROM silnice as s
JOIN
(SELECT * FROM kraje
WHERE kraje.kod = 33)
AS k
ON ST_Contains(k.geom, r.geom)
GROUP BY s.id;
SELECT COUNT()
FROM sil_j as s
JOIN reky_j as r
ON ST_Intersects(s.geom, r.geom)
GROUP BY ST_Intersection(s.geom, r.geom);


--Kolik vodních nádrží z celkového počtu leží na území Východočeského kraje? Jaké je to procento?
--explain analyze
(select (select count(*) from
(select k.nazev, n.geom
from kraje as k
join(
select *
from vodni_nadrze) as n
on st_intersects(k.geom, n.geom)
where nazev = 'Východočeský'
)) as nadrze_vychodocesky);
--pocet vsech vodnich nadrzi
(select (select count (*) from vodni_nadrze) as vsechny_nadrze);
--vodní nadrze ve Vychodoceskem kraji v prontech
select (100*(select (select count(*) from
(select k.nazev, n.geom
from kraje as k
join(
select *
from vodni_nadrze) as n

on st_intersects(k.geom, n.geom)
where nazev = 'Východočeský'
)) as nadrze_vychodocesky)/(select (select count (*) from vodni_nadrze) as
vsechny_nadrze)) as procento_vysledek
;

-- V kolika obcích Jižních Čech je vymezeno ochranné území?
SELECT COUNT(DISTINCT o.id) AS obce_ch
FROM obce AS o
JOIN (SELECT nazev, geom AS k_geom
FROM kraje
WHERE nazev='Jihočeský') AS k
ON ST_Intersects (o.geom,k.k_geom)
JOIN chranena_uzemi AS chu
ON ST_Intersects(o.geom, chu.geom);


-- Vyberte silnice, které kříží vodní toky. Kolik silnic tvoří silnice první třídy?
EXPLAIN ANALYZE select s.id, count(*)
from silnice as s
join vodni_toky as r
on st_crosses(s.geom, r.geom)
group by s.id;

Kolik silnic tvoří silnice první třídy?
EXPLAIN ANALYZE select count(*) from(select s.id, count(*)
from silnice as s
join vodni_toky as r
on st_crosses(s.geom, r.geom)
where typ = 1
group by s.id);

-- 
--- Celkový počet vodních nádrží v ČR
SELECT count(*) FROM vodni_nadrze;

--- Počet nádrží ležících na území Jihočeského kraje (příklad A)
SELECT count(*) FROM vodni_nadrze AS vn
JOIN (SELECT * FROM kraje WHERE nazev = 'Jihočeský') AS jc
ON ST_Intersects(vn.geom, jc.geom);

--- Počet nádrží ležících pouze na území Jihočeského kraje (příklad B)
SELECT count(*) FROM vodni_nadrze AS vn
JOIN (SELECT * FROM kraje WHERE nazev = 'Jihočeský') AS jc
ON ST_Within(vn.geom, jc.geom);


-- Kolik vodních nádrží z celkového počtu leží na území Jihočeského kraje? Jaké je to procento?

--query1(vypocet)
SELECT ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM vodni_nadrze), 1) AS procento
FROM vodni_nadrze
JOIN kraje
ON ST_Within(vodni_nadrze.geom, kraje.geom)
WHERE kraje.nazev = 'Jihočeský';

--query2(vizualizace)
SELECT vodni_nadrze.geom
FROM vodni_nadrze
JOIN kraje
ON st_within(vodni_nadrze.geom, kraje.geom)
WHERE kraje.nazev = 'Jihočeský'

-- Jaká je celková délka (v km) vodních toků Jihočeského kraje?
--výběr vodních toků, které leží v Jihočeském kraji
SELECT reky.tok_id, reky.geom
FROM vodni_toky AS reky
JOIN
    (SELECT * FROM kraje
     WHERE nazev='Jihočeský')
AS kraje
ON st_contains(kraje.geom, reky.geom);

--výpočet celkové délky vodních toků v Jihočeském kraji v km
SELECT sum(st_length(reky.geom))/1000 AS celkova_delka
FROM vodni_toky AS reky
JOIN
    (SELECT * FROM kraje
     WHERE nazev='Jihočeský')
AS kraje
ON st_contains(kraje.geom, reky.geom);



