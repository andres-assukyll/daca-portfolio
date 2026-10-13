-- ================================================
-- ISESEISEV TÖÖ : Praktilised harjutused – nädal 3
-- ================================================

-- inventory_test tabeli loomine
CREATE TABLE inventory_test AS
SELECT *
FROM inventory;
-- unustasin andmed importida, kustutan inv_test tabeli 
DROP TABLE inventory_test;

-- Lähteül. kasutada 4 tabelit. Vaatame tabelitesse, et leida JOIN jaoks ühised *_id
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name IN ('sales', 'customers', 'products', 'inventory')
ORDER BY table_name, ordinal_position;

-- P1. TOP 20 klienti koos tootekategooriatega
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS klient, -- võtan ees- ja perenime kokku ühte veergu
    c.city AS linn,
    p.category AS kategooria,
    SUM(s.total_price) AS "summa kokku"
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN products p
    ON s.product_id = p.product_id
JOIN inventory i
    ON p.product_id = i.product_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    p.category
ORDER BY
    "summa kokku" DESC
LIMIT 20;

-- kontrollin i tabelis product_id kirjeid
SELECT
    product_id,
    COUNT(*) AS ridade_arv
FROM inventory
GROUP BY product_id
HAVING COUNT(*) > 1
ORDER BY ridade_arv DESC; -- igat toodet 4 >> ladude/asukoha erinevus?

-- kontrollin asukoha erinevust
SELECT
    product_id,
    location,
    quantity_available
FROM inventory
ORDER BY product_id, location; -- olemas

-- lisan eelmisele ka tootenimed p tabelist
SELECT
    i.product_id,
    p.product_name AS toote_nimi,
    i.location,
    i.quantity_available
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
ORDER BY
    i.product_id,
    i.location;

-- täiendame TOP 20 otsingut EXIST, et ei 4-kordistaks
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS klient,
    c.city AS linn,
    p.category AS kategooria,
    SUM(s.total_price) AS "kogu summa"
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN products p
    ON s.product_id = p.product_id
WHERE EXISTS (
    SELECT 1
    FROM inventory i
    WHERE i.product_id = p.product_id
)
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    p.category
ORDER BY
    "kogu summa" DESC
LIMIT 20;

-- P2: Kadunud kliendid linnade kaupa
SELECT c.city AS linn, 
COUNT(*) AS "kadunud kliendid"
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL
GROUP BY linn;

-- P3: Müümata tooted kategooriate kaupa
SELECT p.category AS kategooria, 
COUNT(*) AS "müümata tooted"
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.product_id IS NULL
GROUP BY kategooria;



