-- nummerdan customers emaili järgi rn 1, 2
SELECT
    *,
    ROW_NUMBER() OVER (
        PARTITION BY email
        ORDER BY customer_id
    ) AS rn
FROM customers_test;

-- arendan edasi, et leida ainult dupliaadid
SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY email
            ORDER BY customer_id
        ) AS rn
    FROM customers_test
) AS numbered_customers
WHERE rn > 1;

-- arendan edasi: palju on dupl. kokku
SELECT COUNT(*) AS duplicate_count
FROM (
    SELECT
        ROW_NUMBER() OVER (
            PARTITION BY email
            ORDER BY customer_id
        ) AS rn
    FROM customers
) AS duplicates
WHERE rn > 1;

-- kas dupl. klientidel on erinev nimi?
SELECT
    email,
    COUNT(DISTINCT (first_name, last_name)) AS different_names
FROM customers_test
GROUP BY email
HAVING COUNT(*) > 1;

-- arendan edasi, et näha ka nimesid dupl. emailide taga
SELECT
    email,
    COUNT(DISTINCT (first_name, last_name)) AS erinevad_nimed,
    STRING_AGG(
        DISTINCT first_name || ' ' || last_name,
        ', '
    ) AS nimed
FROM customers_test
GROUP BY email
HAVING COUNT(*) > 1;

--arendan edasi: nimed eraldi real ja selktsiooniga, kumb kirje ehk rn on vanem e. originaal
SELECT
    email,
    first_name,
    last_name,
    customer_id,
    registration_date,
    ROW_NUMBER() OVER (
        PARTITION BY email
        ORDER BY customer_id
    ) AS rn
FROM customers_test
WHERE email IN (
    SELECT email
    FROM customers_test
    GROUP BY email
    HAVING COUNT(*) > 1
)
ORDER BY email, rn;