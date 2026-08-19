-- Millised linnad on esindatud?
SELECT DISTINCT city FROM customers;

-- ühtlustame nimed
SELECT DISTINCT UPPER(TRIM(city)) AS city
FROM customers;