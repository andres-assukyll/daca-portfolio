-- TOP 10 kogumüük summeeritult
SELECT SUM(kogumüük) AS top10_kogumüük
FROM (
    SELECT 
        c.first_name || ' ' || c.last_name AS klient,
        c.city,
        COUNT(DISTINCT s.sale_id) AS ostude_arv,
        SUM(s.total_price) AS kogumüük
    FROM sales s
    INNER JOIN customers c 
        ON s.customer_id = c.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
    ORDER BY kogumüük DESC
    LIMIT 10
) AS top10;

--  kliendid, kelle kogumüük on üle keskmise:
SELECT c.first_name || ' ' || c.last_name AS klient,       
SUM(s.total_price) AS kogumüük   
FROM sales s   
INNER JOIN customers c ON s.customer_id = c.customer_id   
GROUP BY c.customer_id, c.first_name, c.last_name   
HAVING SUM(s.total_price) > 
(       
  SELECT AVG(kliendi_müük)       
  FROM 
  (           
    SELECT SUM(total_price) AS kliendi_müük           
    FROM sales           
    GROUP BY customer_id       
    ) 
    AS keskmised     
  )   
ORDER BY kogumüük DESC;  -- 762

-- leian lihtsalt keskmise müügi summa 2 komakohaga
SELECT ROUND(AVG(total_price), 2) AS keskmine_müük
FROM sales;

-- mitu unikaalset klienti on ostnud
SELECT 
COUNT(DISTINCT c.customer_id) AS "unikaalsed kliendiostud"
FROM sales s
INNER JOIN customers c 
    ON s.customer_id = c.customer_id; -- 2551

-- leiame protsendi vastu kogu ostjate arvu
SELECT ROUND(762.0 / 2551 * 100, 2) AS protsent;