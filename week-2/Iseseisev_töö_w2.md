# Nädal 2: SQL Cleaning

> ***Iseseisev töö, kus otsiti puuduvad ja korduvaid andmeid ning uuriti andmeformaate ja tüübikonversioone müügiandmetes.***

---

### 🔄 Andmete puhastamise protsess

```mermaid
flowchart LR
    A[(Raw Data)] --> B[🔍 Quality Check]
    B --> C{Problems Found?}

    C -->|Yes| D[🧹 Data Cleaning]
    C -->|No| E[✅ Data Ready]

    D --> F[🔁 Remove Duplicates]
    D --> G[⚠️ Handle Missing Values]
    D --> H[🧾 Validate invoice_id]

    F --> I[(Clean Data)]
    G --> I
    H --> I

    I --> E
```

---

### 🔍 OSA 1. Duplikaadid ja nende tuvastamine

Leiti **4013** korduvat `sale_id`väärtust. Neist enim korratud, **6** korda, olid `sale_id`**2706** ja **4256**. <br>
Uuriti korduste rahalist kogumõju ja saadi, et vahe on ca **66%**.


[Duplikaadid](./w2_duplicates_query.sql)

---

### ⚠️ OSA 2. NULL väärtused

---

### 🔄 OSA 3. Andmeformaadid ja tüübikonversioonid
