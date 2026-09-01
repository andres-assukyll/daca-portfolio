-- Lihtne INNER JOIN: kliendid, kes on ostnud    
SELECT c.first_name, c.last_name, c.email, c.city, s.sale_id, s.sale_date, s.total_price    
FROM sales s    
INNER JOIN customers c ON s.customer_id = c.customer_id    
LIMIT 20;  

-- TOP 10 klienti kogumüügi järgi:
   SELECT c.first_name || ' ' || c.last_name AS klient, c.city AS linn,        
   COUNT(DISTINCT s.sale_id) AS "ostude arv",        
   SUM(s.total_price) AS kogumüük    
   FROM sales s    
   INNER JOIN customers c ON s.customer_id = c.customer_id    
   GROUP BY c.customer_id, c.first_name, c.last_name, c.city    
   ORDER BY kogumüük DESC    
   LIMIT 10; 

-- TOP 10 kliendid koos lojaalsustasemega + COALESCE kui lojaalsustase NULL
SELECT 
    c.first_name || ' ' || c.last_name AS klient,
    c.city AS linn,
    COALESCE(c.loyalty_tier, 'puudub') AS lojaalsustase,
    COUNT(DISTINCT s.sale_id) AS "ostude arv",
    SUM(s.total_price) AS kogumüük
FROM sales s
INNER JOIN customers c 
    ON s.customer_id = c.customer_id
GROUP BY 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.loyalty_tier
ORDER BY kogumüük DESC
LIMIT 10;

    -- Müük linnade kaupa    
    SELECT c.city AS linn,        
    COUNT(DISTINCT c.customer_id) AS kliente,        
    COUNT(s.sale_id) AS oste,        
    SUM(s.total_price) AS kogumüük    
    FROM sales s    
    INNER JOIN customers c ON s.customer_id = c.customer_id    
    GROUP BY linn    
    ORDER BY kogumüük DESC;  -- aga siin näitab, millisest linnast klient pärit on

 -- Müük linnade kaupa poodide asukohas
SELECT 
    COALESCE(s.store_location, 'veebimüük') AS "müügikoht",
    COUNT(DISTINCT s.customer_id) AS kliente,
    COUNT(DISTINCT s.sale_id) AS oste,
    SUM(s.total_price) AS kogumüük
FROM sales s
GROUP BY COALESCE(s.store_location, 'veebimüük')
ORDER BY kogumüük DESC;

-- Müük lojaalsustasemete kaupa    
SELECT c.loyalty_tier AS lojaalsusaste,        
COUNT(DISTINCT c.customer_id) AS kliente,        
SUM(s.total_price) AS kogumüük    
FROM sales s    
INNER JOIN customers c ON s.customer_id = c.customer_id    
GROUP BY lojaalsusaste    
ORDER BY kogumüük DESC;

-- täiendan eelmist: COALESCE kui NULL
SELECT 
    COALESCE(c.loyalty_tier, 'puudub') AS lojaalsusaste,
    COUNT(DISTINCT c.customer_id) AS kliente,
    SUM(s.total_price) AS kogumüük
FROM sales s
INNER JOIN customers c 
    ON s.customer_id = c.customer_id
GROUP BY COALESCE(c.loyalty_tier, 'puudub')
ORDER BY kogumüük DESC;