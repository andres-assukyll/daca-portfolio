SELECT
    COUNT(*) AS total_customers,
    COUNT(email) AS email_count,
    COUNT(*) - COUNT(email) AS null_email_count,
    COUNT(DISTINCT email) AS unique_email_count
FROM customers;