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





