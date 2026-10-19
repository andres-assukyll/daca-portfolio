# Visual Design & Python — Week 6

**Meeskond:** Sales Analytics <br>
**Roll:** E+F – Valideerija & Kvaliteedikontroll + Ärisünteesi koondaja <br>
**Link grupitööle:** [Sales Analytics](https://github.com/andres-assukyll/urbanstyle-sales-analytics/blob/main/week6/README.md)

## 🎯 Eesmärk

Teha meeskonna töö **usaldusväärseks** ja **tervikuks**. Enne kui tulemus
stakeholderini jõuab, peab kontrollima, et numbrid klapiksid ja lugu oleks ühtne.

**Ülesanne**: Rollide A–D väljundid.

---

## 📋 Kvaliteedikontroll

### Peamised leiud

| Kontroll | Tulemus | Hinnang |
|---|---:|---|
| Kõik müügiread | 10 118 | Kontrolli alus |
| Unikaalsed kontrollitud ID-d | Duplikaate 0 | Hea |
| Puuduv kliendi-ID | 988 (9,8%) | Vajab uurimist |
| Negatiivse summaga read | 195 | Võimalikud tagastused |
| Positiivse summaga, kuid vastuolulised read | 306 | Vajab kontrolli |
| Puuduvate klientide müügitulu | 286 446,20 € | Kliendianalüüsis oluline piirang |

Puuduvate kliendi-ID-dega müügid koonduvad 2023.–2024. aastasse: kokku 916 rida. See moodustab ligikaudu 92,7% kõigist puuduva kliendi-ID-ga müükidest. See muster võib viidata ajalooliste andmete impordi või kliendiandmete sidumise probleemile, kuid põhjus pole veel tõestatud.

