-- ==========================================
-- ISESEISEV TÖÖ : Harjutused – nädal 3
-- ==========================================
-- OSA 1. INNER JOIN
-- ==========================================
-- H1A. INNER JOIN: kliendid koos nende müükidega
SELECT    c.first_name,    c.last_name,    c.city,    s.sale_id,    s.sale_date,    s.total_price
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
ORDER BY s.total_price DESC
LIMIT 20;

-- edasi järjestan need müügid linnade kaupa
SELECT
    first_name,
    last_name,
    city,
    sale_id,
    sale_date,
    total_price
FROM (
    SELECT
        c.first_name,
        c.last_name,
        c.city,
        s.sale_id,
        s.sale_date,
        s.total_price
    FROM sales s
    INNER JOIN customers c
        ON s.customer_id = c.customer_id
    ORDER BY s.total_price DESC
--    LIMIT 20
) AS top20
ORDER BY city ASC;

-- H1B. minu koostatud päring, mis ühendab sales ja products tabelid
SELECT
    p.product_name,
    p.category,
    s.quantity,
    s.unit_price,
    s.total_price
FROM sales s
INNER JOIN products p
    ON s.product_id = p.product_id
ORDER BY s.quantity DESC
LIMIT 15;

-- H1C. minu koostatud päring: millised kliendid tellisid?
SELECT
    c.first_name,
    c.last_name,
    s.sale_date,
    s.total_price
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
ORDER BY s.sale_date DESC;

-- H1C. minu koostatud päring: kallimad müügid?
SELECT
    p.product_name,
    p.category,
    s.unit_price,
    s.total_price,
    s.quantity
FROM sales s
INNER JOIN products p
    ON s.product_id = p.product_id
ORDER BY s.total_price DESC
LIMIT 20;

-- ==========================================
-- OSA 2. LEFT JOIN
-- ==========================================
--  — kõik kliendid, ka need kes pole ostnud:
SELECT c.first_name, c.last_name, c.city, s.sale_id, s.total_price
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
ORDER BY s.total_price DESC NULLS LAST;

-- Kliendid, kes pole KUNAGI ostnud
SELECT    c.first_name,    c.last_name,    c.email,    c.city,    c.registration_date
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;

-- H2A. Kadunud kliendid: LEFT JOIN + WHERE IS NULL
SELECT    c.customer_id,    c.first_name || ' ' || c.last_name AS nimi,    c.email,    c.city,    c.registration_date
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
ORDER BY c.registration_date ASC;

-- Võrdluseks: INNER JOIN (ainult aktiivsed kliendid)
SELECT COUNT(DISTINCT c.customer_id) AS aktiivseid_kliente
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id;

-- klientide arv
SELECT COUNT(*) AS klientide_arv
FROM customers;

select 599 + 2551;

-- H2B. Tooted ilma müügita
select 
p.product_name as toode,
p.category as kategooria,
p.cost_price as omahind,
p.retail_price as jaehind
from products p
Left join sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL
order by p.category;

-- H2C. kadunud kliendid linnade kaupa
SELECT
    c.city,
    COUNT(c.customer_id) AS "kadunud klientide arv"
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL
GROUP BY c.city
ORDER BY "kadunud klientide arv" DESC;

-- =============================================
-- OSA 3. RIGHT JOIN ja mitme tabeli ühendamine
-- =============================================
-- LEFT JOIN (kõik kliendid):
SELECT c.first_name, s.sale_id
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id;

-- RIGHT JOIN (sama tulemus, aga tabelid vastupidi):
SELECT c.first_name, s.sale_id
FROM sales s
RIGHT JOIN customers c ON s.customer_id = c.customer_id;

-- mitu tabelit ühes päringus. Iga JOIN lisab ühe "kihi" andmeid:
SELECT    c.first_name || ' ' || c.last_name AS klient,    c.city,    s.sale_date,    s.total_price,    p.product_name,    p.category,    s.quantity,    s.unit_price
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
ORDER BY s.total_price DESC
LIMIT 20;

-- H3A. 3 tabeli JOIN: kes ostis mida?
SELECT    c.first_name || ' ' || c.last_name AS klient,    c.city AS linn,    s.sale_date AS müügi_kuupäev,    p.product_name AS toode,    p.category AS kategooria,    s.quantity AS kogus,    s.unit_price AS ühikuhind,    s.total_price AS rea_summa
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
ORDER BY rea_summa DESC
LIMIT 20;

-- H3B. raport Annale: Millised tootekategooriad müüvad igas linnas kõige rohkem? var.1
select 
s.store_location as linn, 
p.category as kategooria,
sum(s.total_price) as kliendikäive
from sales s
INNER JOIN products p ON s.product_id = p.product_id
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY kategooria, linn
ORDER BY kliendikäive, linn DESC;

-- H3B. var2.
SELECT
    s.store_location as linn,
    p.category as kategooria,
    SUM(s.total_price) AS kliendikäive
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
INNER JOIN products p
    ON s.product_id = p.product_id
GROUP BY linn, kategooria
ORDER BY linn, kliendikäive DESC; -- näitab kõigi 5 kategooria käivet linnade/NULL kaupa

select * from sales;
select * from products;
select * from customers;

-- mitu erinevat kategooriat on?
SELECT COUNT(DISTINCT category) AS kategooriate_arv
FROM products;

-- arvutan iga poe asukoha + kategooria kogumüügi, seejärel valin igast linnast suurima müügiga kategooria.
SELECT
    linn,
    kategooria,
    kogukäive
FROM (
    SELECT
        s.store_location AS linn,
        p.category AS kategooria,
        SUM(s.total_price) AS kogukäive,
        RANK() OVER (
            PARTITION BY s.store_location
            ORDER BY SUM(s.total_price) DESC
        ) AS asukoht
    FROM sales s
    INNER JOIN products p
        ON s.product_id = p.product_id
    INNER JOIN customers c
        ON s.customer_id = c.customer_id
    GROUP BY s.store_location, p.category
) x
WHERE asukoht = 1
ORDER BY linn, kategooria DESC; -- suurima müügi tootekategoorias iga asukoha kohta

-- H3C. Millised kliendid ostavad kõige kalleimaid tooteid ja kui palju kokku (kogus, lõppsumma)?
SELECT
    c.first_name,
    c.last_name,
    p.product_name,
    p.category,
    s.unit_price,
    s.quantity,
    s.total_price
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
INNER JOIN products p
    ON s.product_id = p.product_id
ORDER BY s.unit_price DESC
LIMIT 20;

-- kuna koguhind on vahel < kui ühikuhind, vaatan, mis andmed ja mis tüüpi on sales tbl.
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'sales'
ORDER BY ordinal_position;

-- sama kliendi tbl.
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'customers'
ORDER BY ordinal_position;

select * from customers; -- nb! loyalty_tier

-- miks mõnel real on unit_price > total_price?
SELECT
    s.sale_id,
    c.loyalty_tier,
    s.quantity,
    s.unit_price,
    s.total_price,
    s.unit_price * s.quantity AS arvutatud_total,
    s.total_price / s.unit_price * 100 AS protsent_jaehinnast
FROM sales s
LEFT JOIN customers c
    ON s.customer_id = c.customer_id
WHERE s.unit_price > s.total_price
ORDER BY
    CASE
        WHEN c.loyalty_tier = 'gold' THEN 1
        WHEN c.loyalty_tier = 'silver' THEN 2
        WHEN c.loyalty_tier = 'bronze' THEN 3
        ELSE 4
    END;

-- leian palju kirjeid kokku ning palju unit > total
SELECT
    COUNT(*) FILTER (WHERE s.quantity > 0) AS müügikirjete_arv,
    COUNT(*) FILTER (
        WHERE s.quantity > 0
          AND s.unit_price > s.total_price
    ) AS jaehind_suurem_müügihinnast
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id;