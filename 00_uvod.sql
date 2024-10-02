/*
Zakladni commands v SQL

*/

/*
Select by single condition
*/

SELECT *
from aopk.velkoplosna_chranena_uzemi_zonace
WHERE nazev = 'Šumava'


/*
Select by multiple conditions
*/
SELECT *
from aopk.velkoplosna_chranena_uzemi_zonace
WHERE nazev = 'Šumava' or nazev = 'Krkonoše'


/*
SORT BY
*/

SELECT *
from aopk.velkoplosna_chranena_uzemi_zonace
-- WHERE nazev = 'Šumava' or nazev = 'Krkonoše'
ORDER BY nazev ASC;


/*
GROUP BY NAME, GET COUNT AND SORT BY COUNT
*/

SELECT nazev, COUNT(*) AS count
from aopk.velkoplosna_chranena_uzemi_zonace
-- WHERE nazev = 'Šumava' or nazev = 'Krkonoše'
GROUP BY nazev
ORDER BY COUNT ASC


/*
GET ROW WITH MAX COUNT (using limit 1)
*/

SELECT nazev, COUNT(*) AS count
from aopk.velkoplosna_chranena_uzemi_zonace
-- WHERE nazev = 'Šumava' or nazev = 'Krkonoše'
GROUP BY nazev
ORDER BY COUNT DESC
LIMIT 1



