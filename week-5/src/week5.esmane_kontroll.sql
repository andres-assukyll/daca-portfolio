-- Grupitöö : nädal 5
-- Vaatan kolme tabeli veerge ja andmetüüpe
SELECT
    table_name,
    ordinal_position,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name IN ('sales', 'inventory', 'products')
ORDER BY table_name, ordinal_position;

-- Kontrollin andmete põhitervist.
-- Kas tabelid sisaldavad mõistlikul hulgal kirjeid?
SELECT 'sales' AS table_name, COUNT(*) AS row_count
FROM public.sales

UNION ALL

SELECT 'inventory', COUNT(*)
FROM public.inventory

UNION ALL

SELECT 'products', COUNT(*)
FROM public.products;

-- Kontrollin kuupäevade vahemikku
SELECT
    MIN(sale_date) AS first_sale_date,
    MAX(sale_date) AS last_sale_date,
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (
        WHERE sale_date IS NULL
    ) AS missing_dates
FROM public.sales;

-- Kontrollin võtmeväljade NULL-väärtusi
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_id,
    COUNT(*) FILTER (
        WHERE product_id IS NULL
    ) AS missing_product_id,
    COUNT(*) FILTER (
        WHERE sale_date IS NULL
    ) AS missing_sale_date
FROM public.sales;
