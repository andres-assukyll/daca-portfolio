
-- =========================================================
-- Grupitöö : nädal 5
-- 1. MÜÜGIANDMETE ÜLDINE KVALITEEDIKONTROLL
-- Kontrollin ridade arvu, unikaalseid ID-sid, käivet, kliente, puuduvaid kliendi-ID-sid ja kuupäevavahemikku.
-- Võrdlen käivet €2 910 000 ja unikaalseid kliente 2551-ga.
-- =========================================================

SELECT
    COUNT(*) AS sales_rows,
    COUNT(DISTINCT id) AS unique_row_ids,
    COUNT(DISTINCT sale_id) AS unique_sale_ids,
    COUNT(DISTINCT invoice_id) AS unique_invoices,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(SUM(total_price), 2) AS total_revenue,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_ids,
    COUNT(*) FILTER (WHERE total_price < 0) AS negative_total_rows,
    MIN(sale_date) AS first_sale_date,
    MAX(sale_date) AS last_sale_date
FROM public.sales;


-- =========================================================
-- 2. AASTAKÄIVE JA KÄIBE KASV 2023–2024
-- Kontrollin, kas 2024. aasta käibekasv oli 19,08%.
-- =========================================================

WITH yearly_sales AS (
    SELECT
        EXTRACT(YEAR FROM sale_date)::int AS sales_year,
        SUM(total_price) AS revenue
    FROM public.sales
    WHERE sale_date >= TIMESTAMP '2023-01-01'
      AND sale_date < TIMESTAMP '2025-01-01'
    GROUP BY EXTRACT(YEAR FROM sale_date)
)
SELECT
    ROUND(
        MAX(revenue) FILTER (WHERE sales_year = 2023),
        2
    ) AS revenue_2023,
    ROUND(
        MAX(revenue) FILTER (WHERE sales_year = 2024),
        2
    ) AS revenue_2024,
    ROUND(
        100.0 * (
            MAX(revenue) FILTER (WHERE sales_year = 2024)
            - MAX(revenue) FILTER (WHERE sales_year = 2023)
        ) / NULLIF(
            MAX(revenue) FILTER (WHERE sales_year = 2023),
            0
        ),
        2
    ) AS growth_percent
FROM yearly_sales;


-- =========================================================
-- 3. KÄIVE MÜÜGIKANALI JA ASUKOHA JÄRGI
-- Millistes kanalite ja asukohtade kombinatsioonides käive tekib?
-- =========================================================

SELECT
    channel,
    store_location,
    COUNT(*) AS sales_rows,
    ROUND(SUM(total_price), 2) AS revenue
FROM public.sales
GROUP BY channel, store_location
ORDER BY revenue DESC;


-- =========================================================
-- 4. KÄIVE JA KANALITE OSAKAAL
-- Kontrollin, kui suure osa kogukäibest moodustab iga kanal.
-- =========================================================

SELECT
    channel,
    COUNT(*) AS sales_rows,
    ROUND(SUM(total_price), 2) AS revenue,
    ROUND(
        100.0 * SUM(total_price)
        / NULLIF(
            (SELECT SUM(total_price) FROM public.sales),
            0
        ),
        2
    ) AS revenue_share_percent
FROM public.sales
GROUP BY channel
ORDER BY revenue DESC;


-- =========================================================
-- 5. LAOVARUD TOOTEKATEGOORIATE KAUPA
-- Leian laokoguseid, tellimispunkte ja tooteid, mille laoseis on alla tellimispunkti.
-- =========================================================

SELECT
    p.category,
    SUM(i.quantity_available) AS stock_units,
    SUM(i.reorder_point) AS total_reorder_points,
    COUNT(DISTINCT p.product_id) AS product_count,
    COUNT(*) FILTER (
        WHERE i.quantity_available < i.reorder_point
    ) AS inventory_rows_below_reorder
FROM public.inventory i
JOIN public.products p
    ON p.product_id = i.product_id
GROUP BY p.category
ORDER BY stock_units DESC;


-- =========================================================
-- 6. LAOANDMETE KVALITEEDIKONTROLL
-- Kontrollin unikaalseid laorea ID-sid, negatiivseid ja
-- nullkoguseid, tellimispunktist madalamaid koguseid ning
-- tooteviiteid, millele vastavat toodet ei leidu.
-- =========================================================

SELECT
    COUNT(*) AS inventory_rows,
    COUNT(DISTINCT inventory_id) AS unique_inventory_ids,
    COUNT(*) FILTER (
        WHERE quantity_available < 0
    ) AS negative_stock_rows,
    COUNT(*) FILTER (
        WHERE quantity_available = 0
    ) AS zero_stock_rows,
    COUNT(*) FILTER (
        WHERE quantity_available < reorder_point
    ) AS below_reorder_rows,
    COUNT(*) FILTER (
        WHERE p.product_id IS NULL
    ) AS unmatched_product_rows
FROM public.inventory i
LEFT JOIN public.products p
    ON p.product_id = i.product_id;


-- =========================================================
-- 7. MÜÜGISUMMA JA KOGUSE × ÜHIKUHINNA VASTAVUS
-- Kontrollib, kas total_price vastab arvutusele
-- quantity * unit_price.
-- Erinevused võivad tuleneda ka allahindlustest,
-- maksudest või tagastustest.
-- =========================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (
        WHERE ABS(total_price - quantity * unit_price) > 0.01
    ) AS rows_with_price_mismatch,
    ROUND(
        SUM(total_price - quantity * unit_price),
        2
    ) AS total_difference
FROM public.sales;

