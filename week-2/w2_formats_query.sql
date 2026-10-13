-- Kuupäevade formateerimine UrbanStyle'i andmetes
SELECT
    sale_id,
    sale_date,
    TO_CHAR(sale_date, 'DD.MM.YYYY') AS eesti_kuupäev,
    TO_CHAR(sale_date, 'Day') AS nädalapäev,
    TO_CHAR(sale_date, 'YYYY-"Q"Q') AS kvartal,
    EXTRACT(DOW FROM sale_date) AS päeva_nr
FROM sales_test
ORDER BY sale_date DESC
LIMIT 10;

-- Linnade ühtlustamise diagnostika
SELECT
    city AS originaal,
    TRIM(city) AS trimitud,
    INITCAP(TRIM(city)) AS puhastatud,
    COUNT(*) AS kliente
FROM customers_test
GROUP BY city
ORDER BY city;

-- minu koostatud päring nimede ühtlustamiseks
SELECT
    INITCAP(TRIM(city)) AS linn,
    COUNT(*) AS kliente,
    COUNT(DISTINCT city) AS teisendeid
FROM customers_test
GROUP BY INITCAP(TRIM(city))
ORDER BY kliente DESC;

-- Kontrolli hinnaveeru tüüpi ja väärtusi
SELECT
    product_id,
    product_name,
    retail_price,
    CASE
        WHEN retail_price IS NULL THEN 'NULL'
        WHEN retail_price = 0 THEN 'NULL (0 = puudub?)'
        WHEN retail_price < 0 THEN 'NEGATIIVNE!'
        ELSE 'OK'
    END AS hinna_staatus
FROM products_test
WHERE retail_price IS NULL OR retail_price <= 0
ORDER BY retail_price;
