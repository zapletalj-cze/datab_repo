-- Úvod do SQL: Příklady a základní příkazy

-- Připojení k databázi naturalearth

-- Příkaz SELECT
-- Čtení dat z databáze
-- Nejjednodušší forma SELECTu


-- Příklad z databáze Naturalearth
SELECT name_long
FROM countries; -- Vybereme dlouhý název zemí

-- Úkol: Přidejte atributy postal a pop2020, přejmenujte name_long na Zeme
SELECT name_long AS "Zeme", postal, pop2020
FROM countries;

-- COUNT: Spočítejte, kolik je zemí v DB Naturalearth
SELECT COUNT(*)
FROM countries; -- Vrátí počet záznamů v tabulce countries

-- Podmínka WHERE: Filtrace dat
SELECT "co" FROM "odkud" WHERE "podminka"; -- Syntaxe s podmínkou WHERE

-- Příklad: Vyberte evropské země
SELECT name_long
FROM countries
WHERE region_un = 'Europe'; -- Výběr zemí z Evropy

-- Úkol: Vyberte všechny neevropské země
SELECT name_long
FROM countries
WHERE region_un <> 'Europe'; -- Všechny země kromě evropských

-- Test na hodnoty: Nepřesnost s LIKE
SELECT "co" FROM "odkud" WHERE atribut LIKE 'Čern%'; -- Hledání vzoru s LIKE

-- Negace NOT
SELECT name_long
FROM countries
WHERE region_un NOT LIKE 'Eu%'; -- Všechny země kromě těch, které začínají na 'Eu'

-- Kombinace AND
SELECT name_long
FROM countries
WHERE region_un = 'Europe' AND name_long LIKE 'C%'; -- Země v Evropě začínající na 'C'

-- Alespoň jedno OR
SELECT name_long
FROM countries
WHERE name_long LIKE 'A%' OR name_long LIKE 'C%'; -- Země začínající na 'A' nebo 'C'

-- Operátor IN
SELECT name_long
FROM countries
WHERE name_len IN (20, 24); -- Země s délku názvu 20 nebo 24 znaků

-- Test rozmezí BETWEEN
SELECT name_long
FROM countries
WHERE label_y BETWEEN 40 AND 60; -- Země s label_y v rozmezí 40-60

-- Přepsání testu rozmezí pomocí <>
-- Tato část je spíše pro demonstraci, nemá smysl přepisovat BETWEEN
-- ale zde je příklad pro ilustraci
SELECT name_long
FROM countries
WHERE label_y < 40 OR label_y > 60; -- Záznamy mimo rozmezí

-- Priorita operátorů
-- Porovnání =, NOT, AND, OR

-- Řazení výsledků
SELECT name_long
FROM countries
ORDER BY name_long; -- Řazení zemí podle abecedy

-- Dvě řadící kritéria
SELECT name_long, continent
FROM countries
ORDER BY region_un, name_long; -- Primární a sekundární řazení

-- Řazení a výběr v jednom
SELECT name_long, continent, HDP
FROM countries
WHERE region_un = 'Europe'
ORDER BY label_y DESC, region_un, name_long; -- Řazení s podmínkou

-- Přímý výpočet
SELECT 1 + 1 AS "1+1"; -- Výpočet a pojmenování sloupce

SELECT name_long, pop_est/1000000 as pop, geom
FROM countries
WHERE pop > 10 and GDP < 10000

-- CASE na hodnoty
SELECT name_long,
CASE att
    WHEN 1 THEN 'Prvni'
    WHEN 2 THEN 'Druhy'
    WHEN 3 THEN 'Treti'
    ELSE 'Neznamy'
END AS Atribut
FROM countries; -- Příklad použití CASE

-- CASE na podmínky
SELECT name_long,
CASE
    WHEN GDP < 1000 THEN 'Posledni'
    WHEN GDP > 5000 THEN 'Treti'
    ELSE 'Prostredni'
END AS GDP
FROM countries; -- Úprava výstupu podle hodnoty GDP

-- Správný test na NULL
SELECT atribut FROM db WHERE atribut IS NULL; -- Záznamy s NULL hodnotou

-- Funkce ISNULL
SELECT
ISNULL(att, 'Nahradni hodnota'), -- Náhrada za NULL
ISNULL(NULL, 'Nahradni hodnota');


--Alternativa nahrazovani
SELECT COALESCE(name_alt, 'cokolvek') AS Result, name, name_alt
FROM countries;


SELECT NAME_LONG, name_alt
FROM countries
WHERE NAME_ALT IS NULL;


-- Výpis unikátních hodnot
SELECT DISTINCT region_un
FROM countries; -- Unikátní regiony

-- Seskupování GROUP BY
SELECT region_un
FROM countries
GROUP BY region_un; -- Sesbírejte podle regionu

-- Seskupování s počtem
SELECT region_un, COUNT(*) AS pocet
FROM countries
GROUP BY region_un
ORDER BY pocet; -- Počet zemí podle regionu

-- Klauzule HAVING
SELECT COUNT(CustomerID), Country
FROM Customers
GROUP BY Country
HAVING COUNT(CustomerID) > 5; -- Filtrace seskupených dat


-- francky kupec samo je zmaten