# Nädal 1: SQL Basics

## Uuriti müüke ja topeltkandeid. 

## 📊 Müügi kokkuvõte (koondtabel)

| **Näitaja**                          |          **Tulemus** |
| ------------------------------------ | -------------------: |
| ⚫ Tehinguid kokku                    |               15 234 |
| 🔴 Duplikaate                        |                3 456 |
| - millest NULL väärtusega duplikaate |                2 972 |
| 🟢 Müüke                             |               14 929 |
| - suurim müük                        |         2 170.40 EUR |
| - väikseim müük                      |            15.09 EUR |
| 🔴 Tagastusi                         |                  305 |
| - suurim tagastus.                   |         1 405.32 EUR |
| - väikseim tagastus.                 |            16.37 EUR |
| 🟢 Tulud                             |     4 462 863,88 EUR |
| 🔴 Kulud                             |        88 632,61 EUR |
| **⚫ Netotulu**                       | **4 374 231,27 EUR** |

> *NB! Tegemist on puhastamata andmestikuga, mistõttu andmed ei peegelda tegelikkust.*

---


🔍 **Andmestikus tuvastati, millised konkreetsed kirjed on dubleeritud:**

```sql
SELECT *
FROM (
    SELECT
        sales.*,
        COUNT(*) OVER (
            PARTITION BY
                sale_id,
                invoice_id,
                sale_date,
                customer_id,
                product_id,
                quantity,
                unit_price,
                total_price,
                channel,
                store_location,
                payment_method
        ) AS duplikaate
    FROM sales
) tulemused
WHERE duplikaate > 1;
``` 

---

🔍 **Kirjetes leiti kokku 3456 duplikaati:**

```sql
SELECT
    COUNT(*) AS duplikaate_kokku
FROM (
    SELECT
        sale_id,
        invoice_id,
        sale_date,
        customer_id,
        product_id,
        quantity,
        unit_price,
        total_price,
        channel,
        store_location,
        payment_method
    FROM sales
    GROUP BY
        sale_id,
        invoice_id,
        sale_date,
        customer_id,
        product_id,
        quantity,
        unit_price,
        total_price,
        channel,
        store_location,
        payment_method
    HAVING COUNT(*) > 1
) tulemused;
``` 

---

🔍 **Tuvastati, kas andmestikus üleüldse esineb NULL väärtusi:**

```sql
-- Leiame, kas NULL väärtused üldse on tabelis olemas.
SELECT EXISTS (
  SELECT 1
  FROM sales
  WHERE sale_id IS NULL
     OR invoice_id IS NULL
     OR sale_date IS NULL
     OR customer_id IS NULL
     OR product_id IS NULL
     OR quantity IS NULL
     OR unit_price IS NULL
     OR total_price IS NULL
     OR channel IS NULL
     OR store_location IS NULL
     OR payment_method IS NULL
);

-- sama asi, aga kuvame eestikeelselt (if, else, elseif loogika)
SELECT CASE
    WHEN EXISTS (
        SELECT 1
        FROM sales
        WHERE sale_id IS NULL
           OR invoice_id IS NULL
           OR sale_date IS NULL
           OR customer_id IS NULL
           OR product_id IS NULL
           OR quantity IS NULL
           OR unit_price IS NULL
           OR total_price IS NULL
           OR channel IS NULL
           OR store_location IS NULL
           OR payment_method IS NULL
    )
    THEN 'Olemas'
    ELSE 'Ei ole'
END AS null_väärtused;
```

---

🔍 **Määrati NULL väärtuste asukohad konkreetsetes veergudes:**

```sql
SELECT
    CONCAT_WS(', ',
        CASE WHEN sale_id IS NULL THEN 'sale_id' END,
        CASE WHEN invoice_id IS NULL THEN 'invoice_id' END,
        CASE WHEN sale_date IS NULL THEN 'sale_date' END,
        CASE WHEN customer_id IS NULL THEN 'customer_id' END,
        CASE WHEN product_id IS NULL THEN 'product_id' END,
        CASE WHEN quantity IS NULL THEN 'quantity' END,
        CASE WHEN unit_price IS NULL THEN 'unit_price' END,
        CASE WHEN total_price IS NULL THEN 'total_price' END,
        CASE WHEN channel IS NULL THEN 'channel' END,
        CASE WHEN store_location IS NULL THEN 'store_location' END,
        CASE WHEN payment_method IS NULL THEN 'payment_method' END
    ) AS null_väärtused,
    *
FROM sales
WHERE sale_id IS NULL
   OR invoice_id IS NULL
   OR sale_date IS NULL
   OR customer_id IS NULL
   OR product_id IS NULL
   OR quantity IS NULL
   OR unit_price IS NULL
   OR total_price IS NULL
   OR channel IS NULL
   OR store_location IS NULL
   OR payment_method IS NULL;
```

---

🔍 **Tuvastati, kas NULL väärtuste seas on duplikaate:**

```sql
SELECT *,
       COUNT(*) OVER (
           PARTITION BY
               sale_id,
               invoice_id,
               sale_date,
               customer_id,
               product_id,
               quantity,
               unit_price,
               total_price,
               channel,
               store_location,
               payment_method
       ) AS duplikaate
FROM sales
WHERE sale_id IS NULL
   OR invoice_id IS NULL
   OR sale_date IS NULL
   OR customer_id IS NULL
   OR product_id IS NULL
   OR quantity IS NULL
   OR unit_price IS NULL
   OR total_price IS NULL
   OR channel IS NULL
   OR store_location IS NULL
   OR payment_method IS NULL;
   ```

---

🔍 **Nende seast leiti 2972 NULL väärtustega duplikaati:**

```sql
SELECT COUNT(*) AS null_duplikaate
FROM (
    SELECT COUNT(*) OVER (
        PARTITION BY
            sale_id,
            invoice_id,
            sale_date,
            customer_id,
            product_id,
            quantity,
            unit_price,
            total_price,
            channel,
            store_location,
            payment_method
    ) AS duplikaate
    FROM sales
    WHERE sale_id IS NULL
       OR invoice_id IS NULL
       OR sale_date IS NULL
       OR customer_id IS NULL
       OR product_id IS NULL
       OR quantity IS NULL
       OR unit_price IS NULL
       OR total_price IS NULL
       OR channel IS NULL
       OR store_location IS NULL
       OR payment_method IS NULL
) t
WHERE duplikaate > 1;
   ```
---

🔍 **Seejärel leiti suurimad ja vähimad müügid:**

```sql
SELECT *
FROM sales
WHERE total_price = (SELECT MAX(total_price) FROM sales)
   OR total_price = (SELECT MIN(total_price) FROM sales);
```

🔍 Kuna MIN müük kuvas negatiivse tulemuse, loeti sellised tinglikult "tagastusteks", ning kohendati kood väljastama vaid positiivseid ehk "müügi" tulemusi:

```sql
SELECT *
FROM sales
WHERE total_price = (SELECT MAX(total_price) FROM sales)
   OR total_price = (SELECT MIN(total_price) FROM sales WHERE total_price >= 0);

-- väljastame 1 suurima müügi
SELECT *
FROM sales
ORDER BY total_price DESC
LIMIT 1;

-- väljastame 1 väikseima müügi
SELECT *
FROM sales
WHERE total_price >= 0
ORDER BY total_price ASC 
LIMIT 1;
```

🔍 Lisaks uuriti maks. ja min. "tagastuste" väärtusi:

```sql
-- väljastame 1 suurima tagastuse
SELECT *
FROM sales
ORDER BY total_price ASC
LIMIT 1;

-- väljastame 1 väiksema tagastuse
SELECT *
FROM sales
WHERE total_price <= 0
ORDER BY total_price DESC
LIMIT 1;
```

