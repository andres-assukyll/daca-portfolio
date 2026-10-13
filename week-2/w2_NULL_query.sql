-- Leia tellimused, kus klient on teadmata
SELECT sale_id, customer_id, total_price
FROM sales_test
WHERE customer_id IS NULL;

-- Palju on kokku neid teadmata kliente?
SELECT COUNT(*) AS null_count
FROM sales_test
WHERE customer_id IS NULL;

-- Leia kliendid, kellel ON e-mail olemas
SELECT customer_id, first_name, email
FROM customers_test
WHERE email IS NOT NULL;

-- Leia klientide arv, kellel on e-mail olemas
SELECT COUNT(*) AS email_count
FROM customers_test
WHERE email IS NOT NULL;

-- Asenda puuduv kliendi e-posti nimi vaikeväärtusega
SELECT    customer_id,    
COALESCE(first_name, 'Tundmatu') AS eesnimi,    
COALESCE(email, 'puudub@urbanstyle.ee') AS email
FROM customers_test;

-- Muuda 0-hinnaga tooted NULL-iks (hind pole tegelikult 0, vaid puudub)
SELECT    
product_id,    
product_name,    
NULLIF(retail_price, 0) AS puhas_hind
FROM products_test order by puhas_hind ASC;

