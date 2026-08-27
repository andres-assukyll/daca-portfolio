# Nädal 2: SQL Cleaning

> ***Iseseisev töö, kus otsiti puuduvad ja korduvaid andmeid ning uuriti andmeformaate ja tüübikonversioone.***

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

---

### ⚠️ OSA 2. NULL väärtused

---

### 🔄 OSA 3. Andmeformaadid ja tüübikonversioonid
