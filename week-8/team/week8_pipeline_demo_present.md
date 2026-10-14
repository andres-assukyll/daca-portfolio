# 📊 Sales Data Pipeline demo : Sales Analytics : Week 8

## 📝 Projekti ülevaade

See projekt hõlmab ETL-pipeline’i loomist, mille eesmärk on hankida müügi- ja kliendiandmed Supabase’ist, need valideerida ja puhastada: Seejärel arvutada nädalapõhiseid müügi koondnäitajad ja peamised tulemusnäitajad (KPI-d) ning eksportida tulemused CSV-failide ja graafikutena.

## 📈 Pipeline'i tulemused

| Periood | Müügikirjete arv | Kogutulu | Unikaalseid kliente | Keskmine tellimuse väärtus |
|---|---:|---:|---:|---:|
| Jaanuar 2023 | 261 | €79,735.03 | 217 | €305.50 |
| Märts 2023 | 343 | €91,499.55 | 283 | €266.76 |
| Mai 2023 | 343 | €95,316.25 | 277 | €277.89 |

## 🧹 Andmekvaliteet

Pipeline kontrollib kohustuslike veergude olemasolu, kuupäevade vormingut ja arvuliste väärtuste korrektsust. Samuti käsitleb see puuduvaid kliendi-ID-sid ja kaupluste asukohti, kontrollib duplikaatkirjeid ning ühendab müügi- ja kliendiandmed.

## 🚀 Käivitamine

Pipeline'i käivitamiseks kasutati järgmist käsku:

```bash
python3 pipeline.py \
    --period 2023-01-01:2023-01-31 \
    --period 2023-03-01:2023-03-31 \
    --period 2023-05-01:2023-05-31
```

## ✅ Käivitamise tulemus

**Staatus:** SUCCESS

## 📁 Väljundfailid

#### 📂 CSV failid
- [Jaanuar 2023 tulemused](output/results_20261007_2023Jan.csv)
- [Märts 2023 tulemused](output/results_20261007_2023Mar.csv)
- [Mai 2023 tulemused](output/results_20261007_2023May.csv)

### 📈 KPI raportid

- [Jaanuar 2023 tulemused](https://andres-assukyll.github.io/daca-portfolio/kpi_summary_20261007_2023Jan.html)
- [Märts 2023 tulemused](https://andres-assukyll.github.io/daca-portfolio/kpi_summary_20261007_2023Mar.html)
- [Mai 2023 tulemused](https://andres-assukyll.github.io/daca-portfolio/kpi_summary_20261007_2023May.html)

### 📅 Nädalapõhise müügitulu raportid

- [Jaanuar 2023 tulemused](https://andres-assukyll.github.io/daca-portfolio/weekly_revenue_20261007_2023Jan.html)
- [Märts 2023 tulemused](https://andres-assukyll.github.io/daca-portfolio/weekly_revenue_20261007_2023Mar.html)
- [Mai 2023 tulemused](https://andres-assukyll.github.io/daca-portfolio/weekly_revenue_20261007_2023May.html)

## 📧 Saadetud e-kirja teavitus

✅ UrbanStyle pipeline valmis!

UrbanStyle pipeline tulemused

━━━━━━━━━━━━━━━━━━━━ <br>
📅 2023-01-01 – 2023-01-31
<br><br>
💰 Kogutulu: €79,735.03<br>
👥 Unikaalsed kliendid: 217<br>
🛒 Keskmine tellimuse väärtus: €305.50<br><br>

📁 Tulemused: /output/2023-01-01_2023-01-31<br>
━━━━━━━━━━━━━━━━━━━━<br>
📅 2023-03-01 – 2023-03-31<br><br>

💰 Kogutulu: €91,499.55<br>
👥 Unikaalsed kliendid: 283<br>
🛒 Keskmine tellimuse väärtus: €266.76<br><br>

📁 Tulemused: /output/2023-03-01_2023-03-31<br>
━━━━━━━━━━━━━━━━━━━━<br>
📅 2023-05-01 – 2023-05-31<br><br>

💰 Kogutulu: €95,316.25<br>
👥 Unikaalsed kliendid: 277<br>
🛒 Keskmine tellimuse väärtus: €277.89<br><br>

📁 Tulemused: /output/2023-05-01_2023-05-31<br>
━━━━━━━━━━━━━━━━━━━━
