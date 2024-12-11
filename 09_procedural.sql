-- UKOL 01
-- Vytvořte a ověřte SQL funkci která vrací součet dvou celých čísel.
CREATE FUNCTION soucet(integer, integer) 
RETURNS integer AS $$ 
SELECT $1+$2; 
$$ LANGUAGE SQL

-- Spustit funkci:
SELECT soucet(5, 5); 


/*
-- UKOL 02
Vytvořte a ověřte SQL funkci která převádí stupně 
Fahrenheita na stupně Celsia. 
C_st = (F_st - 32.0) / (5.0 / 9.0)
*/

CREATE FUNCTION fartocelc(float)
RETURNS float as $$ 
SELECT ($1 - 32.0) / (5.0 / 9.0);
$$ LANGUAGE SQL

-- Spustit funkci:
SELECT fartocelc(32.0);


-- UKOL 03 
-- Přepište funkci součet do PL/pgSQL
CREATE OR REPLACE FUNCTION soucet_pg(a int, b int) 
RETURNS int AS $$
BEGIN
RETURN a + b;
END;
$$ LANGUAGE plpgsql;

SELECT soucet_pg(1,2)


/*
Vytvořte PL/pgSQL funkci procento s oznámením o 
deleni nulou 
RAISE NOTICE ‘Pozor deleni nulou!’; 
pouzite datový typ double precision
*/
-- NEVIM PROC NEVRACI RAISE NOTICE
CREATE OR REPLACE FUNCTION procento(a double precision, b double precision)
RETURNS double precision AS $$
BEGIN
    IF b = 0 THEN
        RAISE NOTICE 'Pozor deleni nulou!';
        RETURN NULL;
    ELSE
        RETURN a / b * 100;
    END IF;
END;
$$ LANGUAGE plpgsql;


/*
UKOL 04 translace kodu v CLC18
*/

CREATE FUNCTION clc2lc1(input db )
RETURNS integer AS $$
BEGIN
    UPDATE clc_18_cz_lc1
    SET lc1 = CASE 
        WHEN code_18 = '142' THEN '14'
        WHEN code_18 LIKE '1%' THEN '1'
        WHEN code_18 LIKE '2%' THEN '2'
        WHEN code_18 LIKE '3%' THEN '3'
        WHEN code_18 LIKE '4%' THEN '4'
        WHEN code_18 LIKE '5%' THEN '5'
        ELSE '0'
    END;

    -- RETURN (
    --     SELECT COUNT(*) 
    --     FROM clc_18_cz_lc1
    --     WHERE code_18 = '142'
    -- );
END;
$$ LANGUAGE plpgsql;

FOR item IN SELECT *
from cviceni7.clc18_cz_3035
LOOP
    PERFORM clc2lc1(item.code_18);
END LOOP;


