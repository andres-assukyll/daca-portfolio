-- ====================================
-- Iseseisev töö : nädal 4
-- ====================================
-- Osa 1. GROUP BY
-- ====================================

-- H1A. Müük kuude kaupa 2024. aastal
SELECT
    TO_CHAR(sale_date, 'YYYY-MM') AS kuu,
    COUNT(*) AS tellimusi,
    SUM(total_price) AS käive,
    ROUND(AVG(total_price), 2) AS keskmine_tellimus
FROM sales
WHERE sale_date >= '2024-01-01'
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY kuu;

-- H1B. Minu päring: müük linnade kaupa. Näita: linn, tellimuste arv, kogukäive, keskmine tellimus
SELECT
    c.city AS linn,
    COUNT(*) AS tellimuste_arv,
    SUM(s.total_price) AS kogukäive,
    ROUND(AVG(s.total_price), 2) AS keskmine_tellimus
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.city
ORDER BY kogukäive DESC;

-- H1C. Minu päring: müük kanalite kaupa
SELECT
    channel AS müügikanal,
    COUNT(*) AS tehingute_arv,
    SUM(quantity) AS müüdud_kogus,
    SUM(total_price) AS kogukäive,
    ROUND(AVG(total_price), 2) AS keskmine_tehing
FROM sales
GROUP BY channel
ORDER BY kogukäive DESC;

-- =====================================================
-- Osa 2: HAVING ja Agregaatfunktsioonid — Filtreerimine 
-- =====================================================
-- H2A. Kliendid, kes ostnud üle 500€
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS nimi,
    COUNT(s.sale_id) AS tellimuste_arv,
    SUM(s.total_price) AS kogukäive
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(s.total_price) > 500
ORDER BY kogukäive DESC;

-- H2B. Liisi varude audit
SELECT
    p.category AS kategooria,
    SUM(s.quantity) AS müüdud_kogus,
    ROUND(AVG(p.retail_price), 2) AS keskmine_jaehind,
    COUNT(DISTINCT s.product_id) AS erinevaid_tooteid
FROM products p
JOIN sales s
    ON p.product_id = s.product_id
GROUP BY p.category
HAVING SUM(s.quantity) > 100
ORDER BY müüdud_kogus DESC;

-- H2C. WHERE + HAVING koos kasutamine.
-- Milliste müügikanalite käive oli 2024. aasta esimeses kvartalis üle 5000€?
SELECT
    channel AS müügikanal,
    COUNT(*) AS tehingute_arv,
    SUM(total_price) AS kogukäive
FROM sales
WHERE sale_date >= '2024-01-01'
  AND sale_date < '2024-04-01'
GROUP BY channel
HAVING SUM(total_price) > 5000
ORDER BY kogukäive DESC;

-- ==========================================
-- Osa 3: CTE ja Window Functions harjutused 
-- ==========================================
-- H3A. CTE mall 
WITH kuu_myyk AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS kuu,
        SUM(total_price) AS käive
    FROM sales
    WHERE sale_date >= '2024-01-01'
    GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT
    kuu,
    käive,
    LAG(käive) OVER (ORDER BY kuu) AS eelmine_kuu,
    käive - LAG(käive) OVER (ORDER BY kuu) AS kasv,
    ROUND(
        100.0 * (käive - LAG(käive) OVER (ORDER BY kuu))
        / LAG(käive) OVER (ORDER BY kuu), 1
    ) AS kasv_protsent
FROM kuu_myyk
ORDER BY kuu;

-- H3B. Kliendianalüüs CTE-ga 
-- Koostan kokku 2 päringut: põhipäring klientide segmenteerimine eri tasemetesse ja lisapäring loeb klientide arvu segmendi kaupa
WITH kliendi_kokkuvõte AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS nimi,
        c.city AS linn,
        COUNT(s.sale_id) AS tellimuste_arv,
        SUM(s.total_price) AS kogukäive
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city
),
kliendi_segmenteerimine AS (
    SELECT
        nimi,
        linn,
        tellimuste_arv,
        kogukäive,
        CASE
            WHEN kogukäive > 1000 THEN 'VIP'
            WHEN kogukäive > 300 THEN 'Aktiivne'
            ELSE 'Tavaline'
        END AS segment
    FROM kliendi_kokkuvõte
)
SELECT
    segment,
    COUNT(*) AS klientide_arv
FROM kliendi_segmenteerimine
GROUP BY segment
ORDER BY klientide_arv DESC;

-- H3C. Koostan oma CTE-päringu kasutades ROW_NUMBER() funktsiooni, et leida iga kategooria TOP 3 toodet müüdud koguse järgi.
WITH toote_müük AS (
    SELECT
        p.category,
        p.product_name,
        SUM(s.quantity) AS müüdud_kogus
    FROM products p
    JOIN sales s
        ON p.product_id = s.product_id
    GROUP BY
        p.category,
        p.product_name
),
toodete_järjestus AS (
    SELECT
        category,
        product_name,
        müüdud_kogus,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY müüdud_kogus DESC
        ) AS koht
    FROM toote_müük
)
SELECT
    category AS kategooria,
    product_name AS toode,
    müüdud_kogus,
    koht
FROM toodete_järjestus
WHERE koht <= 3
ORDER BY kategooria, koht;

