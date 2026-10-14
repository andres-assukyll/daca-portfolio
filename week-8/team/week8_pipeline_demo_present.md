# 📊 Sales Data Pipeline Demo — Sales Analytics (Week 8)

## 📝 Demo ülevaade

Pythonil põhinev ETL-pipeline, mis hangib müügi- ja kliendiandmed Supabase’ist, valideerib ja puhastab need ning arvutab müügi KPI-d ja nädalapõhise müügitulu. Tulemused eksporditakse CSV-failide ja interaktiivsete HTML-raportitena. <br>
Demo näidiseks valiti kolm perioodi: jaanuar, märts ja mai 2023.

### 🚀 Käivitamine

Pipeline avati VS Code'is, valiti **Terminal → New Terminal** ja käivitati järgmine käsk:

```bash
python3 pipeline.py \
  --period 2023-01-01:2023-01-31 \
  --period 2023-03-01:2023-03-31 \
  --period 2023-05-01:2023-05-31
```

### 🧹 Andmekvaliteet

- Kohustuslike veergude ja kuupäevade valideerimine
- Arvväärtuste ja duplikaatide kontroll
- Puuduvate kliendi-ID-de ja kaupluste asukohtade käsitlemine
- Müügi- ja kliendiandmete ühendamine

### 📈 Tulemused

| Periood | Müügikirjed | Kogutulu | Unikaalsed kliendid | Keskmine tellimus |
|---|:---:|:---:|:---:|:---:|
| Jaanuar 2023 | 261 | €79,735.03 | 217 | €305.50 |
| Märts 2023 | 343 | €91,499.55 | 283 | €266.76 |
| Mai 2023 | 343 | €95,316.25 | 277 | €277.89 |

### 📊 Raportid

**KPI kokkuvõtted:** [Jaanuar](https://andres-assukyll.github.io/daca-portfolio/kpi_summary_20261007_2023Jan.html) · [Märts](https://andres-assukyll.github.io/daca-portfolio/kpi_summary_20261007_2023Mar.html) · [Mai](https://andres-assukyll.github.io/daca-portfolio/kpi_summary_20261007_2023May.html)

**Nädalapõhine müügitulu:** [Jaanuar](https://andres-assukyll.github.io/daca-portfolio/weekly_revenue_20261007_2023Jan.html) · [Märts](https://andres-assukyll.github.io/daca-portfolio/weekly_revenue_20261007_2023Mar.html) · [Mai](https://andres-assukyll.github.io/daca-portfolio/weekly_revenue_20261007_2023May.html)

**CSV-väljundid:** [Jaanuar](./output/results_20261007_2023Jan.csv) · [Märts](./output/results_20261007_2023Mar.csv) · [Mai](./output/results_20261007_2023May.csv)

### ✅ Staatus

**SUCCESS** — pipeline käivitati edukalt ning tulemused genereeriti kõigi kolme perioodi kohta. Lõpetamisel saadeti tulemuste kokkuvõte e-kirja teel. <br>
👉 [Vaata e-kirja teavituse näidist grupitöös](https://github.com/andres-assukyll/urbanstyle-sales-analytics/blob/main/week8/README.md#-e-kirja-teavitus-success)
