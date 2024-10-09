/*1. Napiste dotaz pro zobrazeni jmena zeme (name_long), zkratky (postal) a populatce 2020 (pop_est) 
z databaze NaturalEarth2 tabulky countries (DB soucasti OSGeo nebo z
https://www.naturalearthdata.com/). Kolik je v tabulce zaznamu?*/

SELECT name_long, postal, pop_est
from countries;

SELECT COUNT(*)
FROM countries;


/*
2. Napiste dotaz pro vypis unikatnich hodnot pro atribut continent z tabulky countries.
*/
SELECT DISTINCT continent
FROM countries;


/* 
3. Napiste dotaz pro vypis 10 nejlidnatejsich zemi. Vyuzij atributy name_long a pop_est.
*/

SELECT name_long, pop_est
FROM countries
ORDER BY pop_est DESC
LIMIT 10;

/*
4. Napiste dotaz pro vypocet "per capita GDP". Vyuzij atributy name_long, gdp_md a pop_est. 
Vysledny sloupec vypoctu aliasuje jako per_capita_GDP.
*/

SELECT name_long, gdp_md, pop_est, gdp_md/pop_est*1000000 AS per_capita_GDP
FROM countries
ORDER BY per_capita_GDP DESC;


/*5. Napiste dotaz pro ziskani ID zeme (gid), jeji cely nazev a "per capita GDP" indikator serazeny 
vzestupne.
*/
SELECT id, name_long, gdp_md/pop_est AS per_capita_GDP
FROM countries
ORDER BY per_capita_GDP ASC;

/*
6. Napiste dotaz pro ziskani celkoveho poctu obyvatel v Evrope.
*/
SELECT CAST(SUM(pop_est) AS INT) as total_population
FROM countries
WHERE continent = 'Europe';

/*
7. Napiste dotaz pro vypis zeme s nejmensim a nejvetsim poctem obyvatel.
*/
-- from stackoverflow
(SELECT name_long, pop_est
FROM countries
ORDER BY pop_est DESC
LIMIT 1)

UNION ALL

(SELECT name_long, pop_est
FROM countries
ORDER BY pop_est ASC    
LIMIT 1
WHERE pop_est > 0);

/*
8. Napiste dotaz pro vypocet prumernaho GDP v Evrope.
*/
SELECT continent, AVG(gdp_md) AS avg_gdp
from countries
GROUP BY continent
HAVING continent = 'Europe';

/*
9. Napiste dotaz pro vypis poctu obyvatel v jednotlivych kontinentech.
*/
SELECT continent, sum(pop_est) AS total_population
from countries
GROUP BY continent;
SORT BY total_population DESC;


/*
10. Napiste dotaz, kterym ziskate jedinecny pocet rozlisenych ekonomik (atribut economy) zemi sveta v 
tabulce countries.
*/
SELECT DISTINCT economy
FROM countries;

/*
11. Napiste dotaz, ktery ziska prvni dva znaky atributu iso_a3, a cely atribut iso_a2.
*/
SELECT LEFT(iso_a3, 2) AS iso_a3, iso_a2

/*
12. Napiste dotaz pro vypocet vyrazu 171 * 214 + 625.
*/
SELECT 171 * 214 + 625 AS ahoj

/*
13. Napiste dotaz, kterym ziskate jmeno zeme (name_long) a zkratku (postal) spojenou podtrzitkem v 
jedinem sloupci
*/

SELECT name_long || '_' || postal AS name_postal
FROM countries;

/*
14. Napiste dotaz, kterym ziskate jmena zemi po odstraneni vsech pocatecnich a koncovych mezer z 
tabulky countries.
*/


/*
15. Napiste dotaz, kterym ziskate jmeno zeme, zkratku zeme (postal) a delku jmena a zkratky (pocet 
znaku).
 */
SELECT NAME_LONG, postal, LENGTH(NAME_LONG) AS name_length, LENGTH(postal) AS postal_length
FROM countries;
ORDER BY name_length DESC;


/*
16. Napiste dotaz, ktery zkontroluje zda sloupec jmeno zeme (name_long) a typ administrativni jednotky 
(featurecla) obsahuje nejake cislo.
-- pouzijte 
SIMILAR TO '%0|1|2|3|4|5|6|7|8|9%'
*/
SELECT name_long, featurecla, name_long SIMILAR TO '%0|1|2|3|4|5|6|7|8|9%' AS number_name, featurecla SIMILAR TO '%0|1|2|3|4|5|6|7|8|9%' AS number_featurecla
FROM countries;

/*
17. Napiste dotaz pro vyber prvnich deseti zaznamu z tabulky countries.
*/
SELECT * 
FROM countries
LIMIT 10;

/*
18. Napiste dotaz pro vypocet zmeny populace mezi roky 1950 a 2020.
*/
SELECT name, pop2020 - pop1950 AS population_change
FROM populated_places
WHERE pop1950 > 0;


-- NENDE
/*
19. Napiste dotaz pro vypocet procentickeho narustu populace mezi roky 1950 a 2020 vzhedem k roku 
1950.
*/
SELECT name , pop2020/pop1950) AS population_change_pct
FROM populated_places;
WHERE pop1950 > 0;


--NENDE

/*
20. Prohledejte vsechny ostatni tabulky z databaze naturalearth2
*/