-- leian duplikaatsed sales-id
SELECT    sale_id,    COUNT(*) AS koopiate_arv
FROM sales_test
GROUP BY sale_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;
-- vajadusel limiteerin LIMIT 10;

-- Anna igale reale number oma grupi sees
SELECT    
sale_id,    
customer_id,    
total_price,    
sale_date,    
ROW_NUMBER() OVER (PARTITION BY sale_id ORDER BY sale_date) AS rn
FROM sales_test; -- rn = 1 on vanim ehk originaal, rn > 1 on dupl.

-- Duplikaatide mõju müüginumbritele
SELECT    
COUNT(*) AS ridu_kokku,    
COUNT(DISTINCT sale_id) AS unikaalseid,    
COUNT(*) - COUNT(DISTINCT sale_id) AS duplikaate,    
SUM(total_price) AS summa_duplikaatidega,    
(SELECT SUM(total_price) 
FROM (        
  SELECT DISTINCT ON (sale_id) total_price        
  FROM sales_test        
  ORDER BY sale_id, sale_date    ) 
  unikaalsed) AS summa_ilma_duplikaatideta
  FROM sales_test;

  select 2896951::numeric / 4374231; -- lisan numeric, et väljastaks vastuse komakohtadega