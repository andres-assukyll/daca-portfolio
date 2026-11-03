<div align="center">

# Andres Assuküll | Data Analytics Portfolio

**SQL · Python · Data Quality · Business Intelligence · Automation**

*Andmetest usaldusväärsete järelduste ja praktiliste otsusteni.*

[GitHubi profiil](https://github.com/andres-assukyll) · [UrbanStyle'i meeskonnaprojekt](https://github.com/andres-assukyll/urbanstyle-sales-analytics) · [Interaktiivsed tööriistad](https://andres-assukyll.github.io/daca-portfolio/week-9/index.html)

</div>

## 👋 Minust

Arendan oma andmeanalüüsi oskusi **Data Analyst Career Accelerator (DACA)** programmis. Minu portfoolio ühendab SQL-i ja Pythoni põhise andmetöötluse, andmekvaliteedi kontrolli, visualiseerimise ning äriliste järelduste sõnastamise.

Mind huvitab eriti see, **kuidas muuta andmed kontrollitavaks ja otsuste tegemisel kasutatavaks**: leida vastuolud enne aruandlust, mõista klientide käitumist, automatiseerida korduvaid analüüse ning tõlkida tulemused selgeteks soovitusteks. Täiendavad huvivaldkonnad on finants- ja ärianalüüs ning investeeringute analüüs.

> **Portfoolio kontekst:** tegemist on DACA õppe- ja meeskonnaprojektidega, peamiselt UrbanStyle'i näidisettevõtte andmetel. Esitatud tulemused on projektiandmete analüüsi leiud, mitte väited tegeliku ettevõtte majandustulemuste kohta.

## ⭐ Valitud projektid

### 1. Andmekvaliteedi audit: SQL + Python

**Probleem:** enne müügi- ja juhtimisaruannete koostamist tuli hinnata, kas müügi-, kliendi- ja laoandmed on usaldusväärsed.

**Minu panus:** kontrollisin SQL-is müügitulu, kliendiseoseid ja laoseisu; kasutasin Pythonit müügisummade ristvalideerimiseks ning eristasin uurimist vajavad erinevused võimalikest tavapärastest äritehingutest.

**Dokumenteeritud leiud:** 10 118 müügirida; 988 puuduva `customer_id`-ga rida; 501 rida, mille `total_price` erines arvutusest `quantity × unit_price` rohkem kui 0,01 €; neist 195 negatiivse müügisummaga. Need on **kontrollisignaalid**, mitte automaatselt tõendatud vead — põhjused võivad olla näiteks tagastused või hinnastamisreeglid.

**Tehnoloogiad:** PostgreSQL / Supabase, SQL, Python, pandas, Power BI.

[SQL-audit ja järeldused](week-5/README.md) · [Pythoni ristvalideerimine](week-6/README.md) · [Dashboard](week-6/img/quality_ctrl_dashboard.png) · [Power BI fail](week-6/week6_dashboard_quality.pbix)

### 2. RFM-kliendisegmentatsioon ja ärisoovitused

**Probleem:** kuidas eristada väärtuslikke, lojaalseid ja kaotamisriskiga kliente ning kujundada sihitud tegevusi?

**Minu panus:** valmistasin müügi- ja kliendiandmed pandas'e abil analüüsiks ette ning koostasin täiendava RFM-segmentatsiooni ja visualiseeringud.

**Dokumenteeritud tulemus:** analüüsis 2540 ostnud klienti ja 8923 positiivset müügikirjet; 524 klienti märgiti segmenti **At Risk**. Soovitasin testida kliendihoiu- ja taasaktiveerimiskampaaniaid ning mõõta mõju kontrollrühmaga. Segmentatsioon kajastab analüüsi ajaloolist viitekuupäeva **28.02.2025**, mitte klientide praegust seisu.

**Tehnoloogiad:** Python, pandas, Jupyter Notebook, visualiseerimine.

[RFM-analüüs ja järeldused](week-7/individual/rfm_analysis.md) · [Andmete ettevalmistus](week-7/individual/week7_rfm_role_A.ipynb) · [Segmenteerimise kood](week-7/individual/week7_rfm_role_A_seg.ipynb) · [Visualiseeringud](week-7/individual/week7_rfm_role_A_vis.ipynb)

### 3. Müügiandmete ETL-töövoog ja interaktiivsed aruanded

**Probleem:** korduvat müügiaruandlust on vaja muuta vähem käsitsi tehtavaks ning hõlpsasti jälgitavaks.

**Minu panus:** töötasin Pythoni andmete valideerimise ja transformeerimise mooduliga, lisasin logimisloogikat ning koostasin eraldi lahendusi korduskatsete seadistamiseks, perioodivalikuks ja koondteavitusteks. Projekti **meeskondlik** ETL-lahendus ühendab andmete hankimise, teisendamise, aruandluse ja teavitamise.

**Dokumenteeritud tulemus:** meeskonna demo töötles edukalt jaanuari, märtsi ja mai 2023 ning lõi CSV- ja interaktiivsed HTML-aruanded. Siinses repositooriumis on minu moodulid ja meeskonna demo väljundid; kogu käivitatav pipeline ei asu tervikuna selles kaustas.

**Tehnoloogiad:** Python, pandas, Supabase API, logging, argparse, Plotly.

[Minu transformatsioonikood](week-8/individual/transform.py) · [ETL-demo](week-8/team/week8_pipeline_demo.md) · [Interaktiivne KPI-raport](https://andres-assukyll.github.io/daca-portfolio/kpi_summary_20261007_2023Jan.html) · [Nädalase käibe raport](https://andres-assukyll.github.io/daca-portfolio/weekly_revenue_20261007_2023Jan.html)

### 4. SQL-põhine müügi- ja kliendianalüüs

**Probleem:** millised kliendid ja müügikanalid annavad suurema osa käibest ning kuidas neid rühmitada?

**Minu panus:** ühendasin müügi- ja kliendiandmeid, analüüsisin ostukäitumist ja müügikanaleid ning kasutasin agregeerimist ja kliendisegmentatsiooni äriliste tähelepanekute sõnastamiseks.

**Dokumenteeritud tulemus:** analüüsis tuvastati 2551 ostnud klienti; Tallinna poe müügimaht oli umbes 1,09 mln € ja e-poel 1,01 mln €. Kliendisegmentide analüüs tõi välja VIP-klientide eripärad ja kliendihoiu küsimused.

**Tehnoloogiad:** SQL, JOIN, GROUP BY, HAVING, CTE, aknafunktsioonid.

[Müügi- ja kliendianalüüs](week-3/README.md) · [Kliendisegmentatsioon](week-4/README.md)

### 5. Interaktiivne värbamise tööriistakomplekt

**Probleem:** kuidas muuta kandidaadi pehmete oskuste hindamine struktureeritumaks ja tõenduspõhisemaks?

**Minu panus:** koostasin värbamisjuhendi ning HTML-, CSS- ja JavaScript-põhised tööriistad STAR-intervjuu märkmete ja kompetentsipõhise hindamise jaoks.

**Tulemus:** interaktiivne STAR-vorm ja Hiring Scorecard, mis toetavad hinnete ja põhjenduste talletamist ning tulemuste eksporti. See projekt näitab ka minu võimet kujundada andmeid ja otsuseid toetavaid kasutajaliideseid.

**Tehnoloogiad:** HTML, CSS, JavaScript, struktureeritud hindamismudelid.

[Proovi tööriistu](https://andres-assukyll.github.io/daca-portfolio/week-9/index.html) · [Värbamisjuhend](week-9/individual/pm_full.md) · [Lähtekood](docs/week-9/)

## 🛠️ Oskused ja tööriistad

| Valdkond | Praktiline kasutus portfoolios |
|---|---|
| **SQL / PostgreSQL / Supabase** | JOIN-id, agregeerimine, CTE-d, andmekvaliteet, kliendisegmentatsioon |
| **Python / pandas / Jupyter** | Andmete laadimine, puhastamine, valideerimine, KPI-d, RFM-analüüs |
| **Power BI / Plotly** | Andmekvaliteedi dashboard ja interaktiivsed müügiaruanded |
| **API / ETL** | API-põhise töövoo meeskonnaprojekt, transformeerimine, logimine, perioodivalik ja teavitused |
| **Git / GitHub / VS Code** | Versioonihaldus, kood ja dokumentatsioon |
| **HTML / CSS / JavaScript** | Interaktiivsed värbamisvormid ja hindamistööriistad |

## 🧭 Kuidas portfoolioga tutvuda?

Kui sul on **5 minutit**, alusta [andmekvaliteedi auditist](week-6/README.md) ja [RFM-analüüsist](week-7/individual/rfm_analysis.md). Kui sind huvitab automatiseerimine, vaata [ETL-demo tulemusi](week-8/team/week8_pipeline_demo.md). Kui soovid näha interaktiivset lahendust, [proovi värbamistööriistu](https://andres-assukyll.github.io/daca-portfolio/week-9/index.html).

Kogu õppeteekond ja ülesannete detailid on alles eraldi [nädalakaustades](https://github.com/andres-assukyll/daca-portfolio) (`week-0` kuni `week-9`). Meeskonnaprojekti tervikvaade asub [UrbanStyle Sales Analytics repositooriumis](https://github.com/andres-assukyll/urbanstyle-sales-analytics).

## 📌 Mida edasi arendan?

- Selgem projektide reprodutseerimise juhend, sõltuvuste ja andmeallikate kirjeldus.
- Andmekvaliteedi kontrollide automatiseerimine ja testimine.
- Analüüsi tulemuste tõlgendamine, mõõdikute definitsioonid ning ärilise mõju hindamine.

## 📫 Kontakt

[GitHub](https://github.com/andres-assukyll) · [E-post](mailto:andres.assukyll@gmail.com)

<!-- Lisa siia oma LinkedIni päris profiiliaadress, kui soovid seda avalikult jagada. -->

---
<div align="center">
  
<sub>Data Analyst Career Accelerator (DACA) · Portfoolio algus: 06.08.2026 · Õppeprojektid ja meeskonnatööd</sub>

</div>
