SELECT
    (SELECT COUNT(*) FROM customers) AS ridade_arv,
    (SELECT COUNT(*)
     FROM information_schema.columns
     WHERE table_name = 'customers') AS veergude_arv;