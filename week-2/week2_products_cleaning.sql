-- ridade arv tabelis
SELECT COUNT(*) AS ridade_arv FROM products_test;

-- leian koopiad
SELECT product_name, COUNT(*) AS koopiaid
FROM products_test
GROUP BY product_name
HAVING COUNT(*) > 1
ORDER BY koopiaid DESC;

-- eestistan
SELECT product_name AS "Tooted", COUNT(*) AS "Koopiaid"
FROM products_test
GROUP BY product_name
HAVING COUNT(*) > 1
ORDER BY "Koopiaid" DESC;

-- leian NULL väärtused
SELECT    
COUNT(*) FILTER (WHERE product_name IS NULL OR product_name = '') AS null_nimi,    
COUNT(*) FILTER (WHERE category IS NULL OR category = '') AS null_kategooria,    
COUNT(*) FILTER (WHERE retail_price IS NULL) AS null_jaehind,    COUNT(*) FILTER (WHERE cost_price IS NULL) AS null_omahind
FROM products_test;

-- Kas on negatiivseid hindu?
SELECT COUNT(*) AS negatiivne_hind
FROM products_test
WHERE retail_price < 0;

-- Kas on äärmuslikke hindu (> 1000€)?
SELECT product_name, retail_price
FROM products_test
WHERE retail_price > 1000
ORDER BY retail_price DESC;

-- max ja min toote hind
SELECT 
MAX(retail_price) AS "Kõrgeim hind",
MIN(retail_price) AS "Madalaim hind"
FROM products_test;

-- Kontrolli kategooriate järjekindlust:
SELECT category AS "Kategooria", 
COUNT(*) AS "Arv"
FROM products_test
GROUP BY category
ORDER BY category;

--- vaatan nt neid 67 toodet "aksessuaaride" ja 73 "jalanõude" reas
SELECT *
FROM products_test
WHERE category = 'aksessuaarid';

SELECT *
FROM products_test
WHERE category = 'jalanõusid';

-- Kontrollin, kas on teisendeid
SELECT
    LOWER(TRIM(category)) AS normalized_category,
    STRING_AGG(DISTINCT category, ', ') AS variants,
    COUNT(*) AS count
FROM products_test
WHERE category IS NOT NULL
GROUP BY LOWER(TRIM(category))
HAVING COUNT(DISTINCT category) > 1
ORDER BY normalized_category;

--- puuduvad väärtused
SELECT
    COUNT(*) AS total_rows,
    COUNT(product_id) AS product_id_filled,
    COUNT(category) AS category_filled,
    COUNT(cost_price) AS cost_price_filled,
    COUNT(retail_price) AS retail_price_filled,
    COUNT(*) - COUNT(cost_price) AS cost_price_missing,
    COUNT(*) - COUNT(retail_price) AS retail_price_missing
FROM products_test;

-- NULL hindade kontroll
SELECT *
FROM products_test
WHERE retail_price < 0
   OR retail_price IS NULL
   OR cost_price < 0
   OR cost_price IS NULL;

-- duplikaatide kontroll
SELECT product_id, COUNT(*)
FROM products_test
GROUP BY product_id
HAVING COUNT(*) > 1;

-- leiame need duplikaadid
SELECT *
FROM products_test
WHERE product_name IN (
    SELECT product_name
    FROM products_test
    GROUP BY product_name
    HAVING COUNT(*) > 1
)
ORDER BY product_name;
-- lisaks kontroll
SELECT *
FROM products_test
WHERE product_id NOT IN (
    SELECT MIN(product_id)
    FROM products_test
    GROUP BY product_name, cost_price, retail_price, category
)
ORDER BY product_name;

-- puhastus
DELETE FROM products_test
WHERE product_id NOT IN (
    SELECT MIN(product_id)
    FROM products_test
    GROUP BY product_name, cost_price, retail_price, category
);