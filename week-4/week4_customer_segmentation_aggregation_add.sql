-- LISATULEMUSTE päringud
-- keskmine kogukäive segmentide põhiselt
WITH kliendi_käive AS (
    SELECT
        customer_id,
        SUM(total_price) AS kogukäive
    FROM sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),

keskmine_käive AS (
    SELECT
        AVG(kogukäive) AS keskmine
    FROM kliendi_käive
)

SELECT
    k.customer_id,
    k.kogukäive,
    ROUND(keskmine, 2) AS klientide_keskmine_käive,
    CASE
        WHEN k.kogukäive > keskmine * 1.5 THEN 'VIP'
        WHEN k.kogukäive > keskmine THEN 'Regular'
        ELSE 'Uus'
    END AS segment
FROM kliendi_käive k
CROSS JOIN keskmine_käive
ORDER BY k.kogukäive DESC;

-- top 10 käive
SELECT
    customer_id AS kliendikood,
    SUM(total_price) AS kogukäive,
    COUNT(DISTINCT sale_id) AS tellimuste_arv
FROM sales
GROUP BY customer_id
HAVING COUNT(DISTINCT sale_id) >= 2
ORDER BY kogukäive DESC
LIMIT 10;

-- kõik, kelle cutomer_id on null
SELECT *
FROM sales
WHERE customer_id IS NULL;

SELECT *
FROM sales
WHERE invoice_id IS NULL;

-- NULL kliendid arvutusse, kus iga NULL on loetud eraldi kliendiks
WITH kliendi_käive AS (
    -- Tuvastatud kliendid: kõik sama kliendi ostud kokku
    SELECT
        'customer_' || customer_id::text AS kliendi_tunnus,
        SUM(total_price) AS kogukäive
    FROM sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id

    UNION ALL

    -- Tuvastamata kliendid: iga arve eraldi
    SELECT
        'invoice_' || invoice_id::text AS kliendi_tunnus,
        SUM(total_price) AS kogukäive
    FROM sales
    WHERE customer_id IS NULL
      AND invoice_id IS NOT NULL
    GROUP BY invoice_id
)

SELECT
    ROUND(AVG(kogukäive), 2) AS klientide_keskmine_kogukäive
FROM kliendi_käive;

-- VIP käibed müügikoha järgi + lojaalsusaste
WITH top_19_kliendid AS (
    SELECT
        s.customer_id,
        SUM(s.total_price) AS kliendi_kogukäive
    FROM sales s
    WHERE s.customer_id IS NOT NULL
    GROUP BY s.customer_id
    HAVING COUNT(DISTINCT s.sale_id) >= 2
    ORDER BY kliendi_kogukäive DESC
    LIMIT 19
)

SELECT
    c.first_name || ' ' || c.last_name AS nimi,
    c.city AS linn,

    COALESCE(c.loyalty_tier, 'puudub') AS lojaalsusaste,

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

FROM top_19_kliendid t

JOIN customers c
    ON c.customer_id = t.customer_id

JOIN sales s
    ON s.customer_id = t.customer_id

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    COALESCE(c.loyalty_tier, 'puudub'),
    COALESCE(s.store_location, 'veebimüük'),
    t.kliendi_kogukäive

ORDER BY
    t.kliendi_kogukäive DESC,
    SUM(s.total_price) DESC;

-- lihtsustatud variant
SELECT
    c.first_name || ' ' || c.last_name AS nimi,
    c.city AS linn,
    COALESCE(c.loyalty_tier::text, 'puudub') AS lojaalsusaste,
    COUNT(DISTINCT s.sale_id) AS tellimuste_arv,
    SUM(s.total_price) AS kliendi_kogukäive
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.loyalty_tier
HAVING COUNT(DISTINCT s.sale_id) >= 2
ORDER BY kliendi_kogukäive DESC
LIMIT 19;

--
WITH vip_kliendid AS (
    SELECT customer_id
    FROM sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
    HAVING COUNT(DISTINCT sale_id) >= 2
    ORDER BY SUM(total_price) DESC
    LIMIT 19
)

SELECT
    c.first_name || ' ' || c.last_name AS nimi,
    COALESCE(c.loyalty_tier::text, 'puudub') AS lojaalsusaste
FROM vip_kliendid v
JOIN customers c
    ON c.customer_id = v.customer_id
ORDER BY
    CASE LOWER(c.loyalty_tier::text)
        WHEN 'gold' THEN 1
        WHEN 'silver' THEN 2
        WHEN 'bronze' THEN 3
        ELSE 4
    END,
    nimi;

-- järjestan kliendid linnade kaupa vastavalt kliendi tähtsusele
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

-- edasi jätan alles 3 tähtsamat linna ja kuidas segmendid jagunevad
WITH kliendi_kokkuvõte AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS nimi,
        c.city,
        COUNT(DISTINCT s.sale_id) AS tellimuste_arv,
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

segmendid AS (
    SELECT
        *,
        CASE
            WHEN kogukäive > 5000 THEN 'VIP'
            WHEN kogukäive > 1000 THEN 'Regular'
            ELSE 'Uus'
        END AS segment,

        ROW_NUMBER() OVER (
            PARTITION BY city
            ORDER BY kogukäive DESC, nimi
        ) AS koht_linnas
    FROM kliendi_kokkuvõte
)

SELECT
    city AS linn,

    COUNT(*) FILTER (
        WHERE segment = 'VIP'
    ) AS vip_kliente,

    COUNT(*) FILTER (
        WHERE segment = 'Regular'
    ) AS regular_kliente,

    COUNT(*) FILTER (
        WHERE segment = 'Uus'
    ) AS uusi_kliente,

    SUM(kogukäive) AS linna_kogukäive,

    MAX(nimi) FILTER (
        WHERE koht_linnas = 1
    ) AS linna_top_klient

FROM segmendid
WHERE city IN ('Tallinn', 'Tartu', 'Pärnu')
GROUP BY city
ORDER BY linna_kogukäive DESC;

-- lisan TO_CHAR käibesummade kuvamiseks
WITH kliendi_kokkuvõte AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS nimi,
        c.city,
        COUNT(DISTINCT s.sale_id) AS tellimuste_arv,
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

segmendid AS (
    SELECT
        *,
        CASE
            WHEN kogukäive > 5000 THEN 'VIP'
            WHEN kogukäive > 1000 THEN 'Regular'
            ELSE 'Uus'
        END AS segment,

        ROW_NUMBER() OVER (
            PARTITION BY city
            ORDER BY kogukäive DESC, nimi
        ) AS koht_linnas
    FROM kliendi_kokkuvõte
)

SELECT
    city AS linn,

    COUNT(*) FILTER (
        WHERE segment = 'VIP'
    ) AS vip_kliente,

    COUNT(*) FILTER (
        WHERE segment = 'Regular'
    ) AS regular_kliente,

    COUNT(*) FILTER (
        WHERE segment = 'Uus'
    ) AS uusi_kliente,

    REPLACE(
        TO_CHAR(SUM(kogukäive), 'FM999,999,999,990'),
        ',',
        ' '
    ) || ' EUR' AS linna_kogukäive,

    MAX(nimi) FILTER (
        WHERE koht_linnas = 1
    ) AS linna_top_klient

FROM segmendid
WHERE city IN ('Tallinn', 'Tartu', 'Pärnu')
GROUP BY city
ORDER BY SUM(kogukäive) DESC;

-- analüüsime keskmist ostukorvi ja -sagedust
WITH kliendi_kokkuvõte AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT s.sale_id) AS tellimuste_arv,
        SUM(s.total_price) AS kogukäive
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
    GROUP BY c.customer_id
),

segmendid AS (
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
    COUNT(*) AS klientide_arv,
    SUM(tellimuste_arv) AS tellimuste_arv,

    REPLACE(
        TO_CHAR(
            SUM(kogukäive) / NULLIF(SUM(tellimuste_arv), 0),
            'FM999,999,990.00'
        ),
        ',',
        ' '
    ) || ' EUR' AS keskmine_ostukorv,

    ROUND(
        AVG(tellimuste_arv),
        2
    ) AS keskmine_ostusagedus

FROM segmendid
GROUP BY segment
ORDER BY
    CASE segment
        WHEN 'VIP' THEN 1
        WHEN 'Regular' THEN 2
        WHEN 'Uus' THEN 3
    END;

-- analüüsin keskmis ostukorvi uuesti jättes välja alla 2 ostu teinud kliendid
WITH kliendi_kokkuvõte AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT s.sale_id) AS tellimuste_arv,
        SUM(s.total_price) AS kogukäive
    FROM customers c

    JOIN sales s
        ON c.customer_id = s.customer_id
    GROUP BY c.customer_id
    HAVING COUNT(DISTINCT s.sale_id) >= 2
),

segmendid AS (
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
    COUNT(*) AS klientide_arv,
    SUM(tellimuste_arv) AS tellimuste_arv,

    REPLACE(
        TO_CHAR(
            SUM(kogukäive) / NULLIF(SUM(tellimuste_arv), 0),
            'FM999,999,990.00'
        ),
        ',',
        ' '
    ) || ' EUR' AS keskmine_ostukorv,

    ROUND(
        AVG(tellimuste_arv),
        2
    ) AS keskmine_ostusagedus

FROM segmendid
GROUP BY segment
ORDER BY
    CASE segment
        WHEN 'VIP' THEN 1
        WHEN 'Regular' THEN 2
        WHEN 'Uus' THEN 3
    END;

-- VIP-klientide lahkumisrisk: viimane ost
WITH kliendi_kokkuvote AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS nimi,
        c.city AS linn,
        SUM(sl.total_price) AS kogukaive,
        MAX(sl.sale_date)::date AS viimane_ost
    FROM customers AS c
    JOIN sales AS sl
        ON c.customer_id = sl.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city
),

segmendid AS (
    SELECT
        nimi,
        linn,
        kogukaive,
        viimane_ost,
        CASE
            WHEN kogukaive > 5000 THEN 'VIP'
            WHEN kogukaive > 1000 THEN 'Regular'
            ELSE 'Uus'
        END AS segment
    FROM kliendi_kokkuvote
)

SELECT
    sg.nimi,
    sg.linn,
    sg.segment,

    REPLACE(
        TO_CHAR(sg.kogukaive, 'FM999,999,999,990'),
        ',',
        ' '
    ) || ' EUR' AS kogukaive,

    sg.viimane_ost,

    ad.viimane_kuupaev - sg.viimane_ost
        AS paevi_viimasest_ostust,

    CASE
        WHEN ad.viimane_kuupaev - sg.viimane_ost >= 180
            THEN 'Kõrge lahkumisrisk'
        WHEN ad.viimane_kuupaev - sg.viimane_ost >= 90
            THEN 'Keskmine lahkumisrisk'
    END AS lahkumisrisk

FROM segmendid AS sg

CROSS JOIN (
    SELECT MAX(sale_date)::date AS viimane_kuupaev
    FROM sales
) AS ad

WHERE sg.segment IN ('VIP', 'Regular')
  AND ad.viimane_kuupaev - sg.viimane_ost >= 90

ORDER BY
    CASE sg.segment
        WHEN 'VIP' THEN 1
        WHEN 'Regular' THEN 2
    END,
    paevi_viimasest_ostust DESC;

-- summeerin palju on lahkumispotentsiaaliga kliente kokku ning vip ja regular eraldi
WITH andmestiku_viimane_kuupaev AS (
    SELECT
        MAX(sale_date)::date AS viimane_kuupaev
    FROM sales
),

korge_riskiga_kliendid AS (
    SELECT
        s.customer_id,
        SUM(s.total_price) AS kogukaive
    FROM sales s
    CROSS JOIN andmestiku_viimane_kuupaev a
    WHERE s.customer_id IS NOT NULL
    GROUP BY
        s.customer_id,
        a.viimane_kuupaev
    HAVING
        SUM(s.total_price) > 1000
        AND a.viimane_kuupaev - MAX(s.sale_date)::date >= 180
)

SELECT
    COUNT(*) AS lahkujate_arv_kokku,

    COUNT(*) FILTER (
        WHERE kogukaive > 5000
    ) AS vip_lahkujad,

    COUNT(*) FILTER (
        WHERE kogukaive > 1000
          AND kogukaive <= 5000
    ) AS regular_lahkujad

FROM korge_riskiga_kliendid;

-- uurin allahindluste osakaalu segmentides
WITH kliendi_kokkuvõte AS (
    SELECT
        customer_id,
        SUM(total_price) AS kogukäive
    FROM sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),

segmendid AS (
    SELECT
        customer_id,
        CASE
            WHEN kogukäive > 5000 THEN 'VIP'
            WHEN kogukäive > 1000 THEN 'Regular'
            ELSE 'Uus'
        END AS segment
    FROM kliendi_kokkuvõte
)

SELECT
    sg.segment,

    COUNT(DISTINCT s.sale_id) AS kõik_ostud,

    COUNT(DISTINCT s.sale_id) FILTER (
        WHERE s.total_price < s.unit_price
    ) AS hinnangulised_kampaaniaostud,

    ROUND(
        100.0 *
        COUNT(DISTINCT s.sale_id) FILTER (
            WHERE s.total_price < s.unit_price
        )
        / NULLIF(COUNT(DISTINCT s.sale_id), 0),
        1
    ) || ' %' AS kampaaniaostude_osakaal

FROM segmendid sg
JOIN sales s
    ON s.customer_id = sg.customer_id

GROUP BY sg.segment

ORDER BY
    CASE sg.segment
        WHEN 'VIP' THEN 1
        WHEN 'Regular' THEN 2
        WHEN 'Uus' THEN 3
    END;
