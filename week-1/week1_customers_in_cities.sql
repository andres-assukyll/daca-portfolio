-- kliendid linnade kaupa
SELECT
    UPPER(TRIM(city)) AS city,
    COUNT(*) AS klientide_arv
FROM customers
GROUP BY UPPER(TRIM(city))
ORDER BY klientide_arv DESC;