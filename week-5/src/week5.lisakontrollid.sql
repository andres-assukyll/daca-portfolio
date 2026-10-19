-- LISAKONTROLLID
-- Negatiivsete müügisummade näited
SELECT
    id,
    sale_id,
    invoice_id,
    sale_date,
    customer_id,
    product_id,
    quantity,
    unit_price,
    total_price,
    channel,
    store_location
FROM public.sales
WHERE total_price < 0
ORDER BY sale_date DESC
LIMIT 100;


-- Müügiread, kus summa ei vasta kogusele × ühikuhinnale
SELECT
    id,
    sale_id,
    invoice_id,
    sale_date,
    product_id,
    quantity,
    unit_price,
    total_price,
    ROUND(quantity * unit_price, 2) AS expected_total,
    ROUND(total_price - quantity * unit_price, 2) AS difference
FROM public.sales
WHERE ABS(total_price - quantity * unit_price) > 0.01
ORDER BY ABS(total_price - quantity * unit_price) DESC
LIMIT 100;


-- Negatiivse või müügikohas madalama laoseisuga tooted
SELECT
    i.inventory_id,
    i.product_id,
    p.product_name,
    p.category,
    i.location,
    i.quantity_available,
    i.reorder_point,
    i.last_updated
FROM public.inventory i
JOIN public.products p
    ON p.product_id = i.product_id
WHERE i.quantity_available < 0
   OR i.quantity_available < i.reorder_point
ORDER BY
    CASE WHEN i.quantity_available < 0 THEN 0 ELSE 1 END,
    i.quantity_available ASC;

