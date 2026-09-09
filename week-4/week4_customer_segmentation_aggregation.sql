-- kogukäive, sealh ka mittekliendid
SELECT
    SUM(total_price) AS kogukäive
FROM sales;

-- kõikide klientide kogukäive
SELECT SUM(total_price) AS klientide_kogukäive
FROM sales
WHERE customer_id IS NOT NULL;

-- keskmine kogukäive kliendi kohta
WITH kliendi_käive AS (
    SELECT
        customer_id,
        SUM(total_price) AS kogukäive
    FROM sales
    -- WHERE customer_id IS NOT NULL -- kui võtan arvesse ainult kliendid
    GROUP BY customer_id
)

SELECT
    ROUND(AVG(kogukäive), 2) AS klientide_keskmine_kogukäive
FROM kliendi_käive;

-- klientide kogukulutus
WITH kliendi_kokkuvõte AS (      
  SELECT c.customer_id, c.first_name || ' ' || c.last_name AS nimi, c.city,        
  COUNT(o.sale_id) AS tellimuste_arv,        
  SUM(o.total_price) AS kogukäive      
FROM customers c      
JOIN sales o ON c.customer_id = o.customer_id      
GROUP BY c.customer_id, c.first_name, c.last_name, c.city    )    
SELECT nimi, city, tellimuste_arv, kogukäive,      
CASE        
WHEN kogukäive > 5000 THEN 'VIP'       -- vali ise piir!        
WHEN kogukäive > 1000 THEN 'Regular'    -- vali ise piir!        
ELSE 'Uus'      
END AS segment    
FROM kliendi_kokkuvõte    
ORDER BY kogukäive DESC;    

-- ainult VIP kogukäive
WITH kliendi_kokkuvõte AS (
    SELECT
        c.customer_id,
        SUM(o.total_price) AS kogukäive
    FROM customers c
    JOIN sales o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
)
SELECT
    SUM(kogukäive) AS vip_kogukäive
FROM kliendi_kokkuvõte
WHERE kogukäive > 5000;

-- leian kogu VIP käibe % osakaalu kõikide klientide kogukäibest
SELECT 
    ROUND(346313.28 / 2622731.78 * 100, 2) AS protsent;

-- palju on kliente igas segmendis
WITH kliendi_kokkuvõte AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS nimi,
        c.city,
        COUNT(o.sale_id) AS tellimuste_arv,
        SUM(o.total_price) AS kogukäive
    FROM customers c
    JOIN sales o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city
),

kliendi_segment AS (
    SELECT
        *,
        CASE
            WHEN kogukäive > 5000 THEN 'VIP'
            WHEN kogukäive > 1000 THEN 'Regular'
            ELSE 'Uus'
        END AS segment
    FROM kliendi_kokkuvõte
)

SELECT
    segment,
    COUNT(DISTINCT customer_id) AS klientide_arv
FROM kliendi_segment
GROUP BY segment
ORDER BY
    CASE segment
        WHEN 'VIP' THEN 1
        WHEN 'Regular' THEN 2
        WHEN 'Uus' THEN 3
    END;

-- lisana järjestan kliendid
WITH kliendi_kokkuvõte AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS nimi,
        c.city,
        COUNT(o.sale_id) AS tellimuste_arv,
        SUM(o.total_price) AS kogukäive
    FROM customers c
    JOIN sales o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city
)

SELECT
    nimi,
    city,
    tellimuste_arv,
    kogukäive,
    CASE
        WHEN kogukäive > 5000 THEN 'VIP'
        WHEN kogukäive > 1000 THEN 'Regular'
        ELSE 'Uus'
    END AS segment,
    RANK() OVER (
        PARTITION BY city
        ORDER BY kogukäive DESC
    ) AS koht_linnas
FROM kliendi_kokkuvõte
ORDER BY city, koht_linnas;

-- segmendi keskmine käive
WITH kliendi_kokkuvõte AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS nimi,
        c.city,
        COUNT(o.sale_id) AS tellimuste_arv,
        SUM(o.total_price) AS kogukäive
    FROM customers c
    JOIN sales o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city
),

kliendi_segment AS (
    SELECT
        *,
        CASE
            WHEN kogukäive > 5000 THEN 'VIP'
            WHEN kogukäive > 1000 THEN 'Regular'
            ELSE 'Uus'
        END AS segment
    FROM kliendi_kokkuvõte
)

SELECT
    segment,
    ROUND(AVG(kogukäive), 2) AS keskmine_käive
FROM kliendi_segment
GROUP BY segment
ORDER BY keskmine_käive DESC;

-- kõige rohkem VIP-e on kus?
WITH kliendi_kokkuvõte AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS nimi,
        c.city,
        COUNT(o.sale_id) AS tellimuste_arv,
        SUM(o.total_price) AS kogukäive
    FROM customers c
    JOIN sales o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city
),

kliendi_segment AS (
    SELECT
        *,
        CASE
            WHEN kogukäive > 5000 THEN 'VIP'
            WHEN kogukäive > 1000 THEN 'Regular'
            ELSE 'Uus'
        END AS segment
    FROM kliendi_kokkuvõte
)

SELECT
    city AS linn,
    COUNT(DISTINCT customer_id) AS vip_klientide_arv
FROM kliendi_segment
WHERE segment = 'VIP'
GROUP BY city
ORDER BY vip_klientide_arv DESC;

-- TOP 10 kogukäive
SELECT
    customer_id,
    SUM(total_price) AS kogukäive,
    COUNT(DISTINCT sale_id) AS tellimuste_arv
FROM sales
GROUP BY customer_id
HAVING COUNT(DISTINCT sale_id) >= 2
ORDER BY kogukäive DESC
LIMIT 10; -- tulid ka NULL kliendid

-- TOP 10 kogukäive, kel kliendinr olemas
SELECT
    c.customer_id AS kliendikood, c.first_name || ' ' || c.last_name AS nimi, 
    c.city AS linn,
    SUM(total_price) AS kogukäive,
    COUNT(DISTINCT sale_id) AS "tellimuste arv"
FROM customers c      
JOIN sales s ON c.customer_id = s.customer_id      
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
HAVING COUNT(DISTINCT sale_id) >= 2
ORDER BY kogukäive DESC
LIMIT 10;

-- vaatan TOP 10 klientide käivet asukohast lähtuvalt
WITH top_10_kliendid AS (
    SELECT
        s.customer_id,
        SUM(s.total_price) AS kliendi_kogukäive
    FROM sales s
    WHERE s.customer_id IS NOT NULL
    GROUP BY s.customer_id
    HAVING COUNT(DISTINCT s.sale_id) >= 2
    ORDER BY kliendi_kogukäive DESC
    LIMIT 10
)

SELECT
    c.customer_id AS kliendikood,
    c.first_name || ' ' || c.last_name AS nimi,
    c.city AS linn,
    COALESCE(s.store_location, 'veebimüük') AS asukoht,
    SUM(s.total_price) AS asukoha_kogukäive,
    COUNT(DISTINCT s.sale_id) AS "asukoha tellimuste arv",
    t.kliendi_kogukäive
FROM top_10_kliendid t
JOIN customers c
    ON c.customer_id = t.customer_id
JOIN sales s
    ON s.customer_id = t.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    COALESCE(s.store_location, 'veebimüük'),
    t.kliendi_kogukäive
ORDER BY
    t.kliendi_kogukäive DESC,
    asukoha_kogukäive DESC;

-- sama asi, aga ei näita tabelis customer_id
WITH top_10_kliendid AS (
    SELECT
        s.customer_id,
        SUM(s.total_price) AS kliendi_kogukäive
    FROM sales s
    WHERE s.customer_id IS NOT NULL
    GROUP BY s.customer_id
    HAVING COUNT(DISTINCT s.sale_id) >= 2
    ORDER BY kliendi_kogukäive DESC
    LIMIT 10
)

SELECT
    c.first_name || ' ' || c.last_name AS nimi,
    c.city AS linn,
    COALESCE(s.store_location, 'veebimüük') AS asukoht,
    SUM(s.total_price) AS asukoha_kogukäive,
    COUNT(DISTINCT s.sale_id) AS "asukoha tellimuste arv",
    t.kliendi_kogukäive
FROM top_10_kliendid t
JOIN customers c
    ON c.customer_id = t.customer_id
JOIN sales s
    ON s.customer_id = t.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    COALESCE(s.store_location, 'veebimüük'),
    t.kliendi_kogukäive
ORDER BY
    t.kliendi_kogukäive DESC,
    asukoha_kogukäive DESC;

-- täiendan seda TO_CHAR funktsiooniga, et kuvaks käibeid kohe valuutana (1 000 EUR)
WITH top_10_kliendid AS (
    SELECT
        s.customer_id,
        SUM(s.total_price) AS kliendi_kogukäive
    FROM sales s
    WHERE s.customer_id IS NOT NULL
    GROUP BY s.customer_id
    HAVING COUNT(DISTINCT s.sale_id) >= 2
    ORDER BY kliendi_kogukäive DESC
    LIMIT 10
)

SELECT
    c.first_name || ' ' || c.last_name AS nimi,
    c.city AS linn,
    COALESCE(s.store_location, 'veebimüük') AS asukoht,
    REPLACE(
        TO_CHAR(SUM(s.total_price), 'FM999,999,999,990'),
        ',',
        ' '
    ) || ' EUR' AS asukoha_kogukäive,
    COUNT(DISTINCT s.sale_id) AS "asukoha tellimuste arv",
    REPLACE(
        TO_CHAR(t.kliendi_kogukäive, 'FM999,999,999,990'),
        ',',
        ' '
    ) || ' EUR' AS kliendi_kogukäive
FROM top_10_kliendid t
JOIN customers c
    ON c.customer_id = t.customer_id
JOIN sales s
    ON s.customer_id = t.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    COALESCE(s.store_location, 'veebimüük'),
    t.kliendi_kogukäive
ORDER BY
    t.kliendi_kogukäive DESC,
    SUM(s.total_price) DESC;