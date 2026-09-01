# 📊 Sales + Customers — Week 3

<p align="center">
  <strong>Sales Analytics · Roll A – Müügi ja klientide ühendamine</strong>
</p>

<p align="center">
  <a href="https://github.com/andres-assukyll/urbanstyle-sales-analytics/blob/main/week3/README.md">
    🔗 Vaata grupitööd
  </a>
</p>

---

## 🎯 Eesmärk

> Analüüsida klientidega seotud müügiandmeid. Leida **TOP 10 klienti kogumüügi järgi**.

---

# 🏆 TOP 10

### 📌 Kiirülevaade

<table>
<tr>
<td align="center">
<h3>👥 2 551</h3>
Unikaalset ostjat kokku
</td>
<td align="center">
<h3>💰 27 668.02 EUR</h3>
Suurim ostusumma
</td>
<td align="center">
<h3>💳 20 124.61 EUR</h3>
Väikseim ostusumma
</td>
<td align="center">
<h3>📈 228 336.79 EUR</h3>
Kokku
</td>
</tr>
</table>

### 🥇 Parimad kliendid kogumüügi järgi

|  🏅 | 👤 klient        | 🏙️ linn | 💎 lojaalsustase | 🛒 ostude arv |        💰 kogumüük |
| :-: | ---------------- | -------- | ---------------- | ------------: | -----------------: |
|  🥇 | **Tiina Pärn**   | Tartu    | `gold`           |            73 |  **27 668.02 EUR** |
|  🥈 | **Priit Rand**   | Pärnu    | `silver`         |            76 |  **26 286.10 EUR** |
|  🥉 | **Kevin Org**    | Tallinn  | `gold`           |            78 |  **23 467.13 EUR** |
| 4️⃣ | **Laura Tammik** | Pärnu    | `silver`         |            74 |  **23 385.82 EUR** |
| 5️⃣ | **Erkki Ilves**  | Tartu    | `silver`         |            72 |  **22 942.42 EUR** |
| 6️⃣ | **Anu Kuusik**   | Tallinn  | `puudub`         |            77 |  **21 626.10 EUR** |
| 7️⃣ | **Kersti Lill**  | Tallinn  | `puudub`         |            71 |  **21 137.47 EUR** |
| 8️⃣ | **Riina Lill**   | Pärnu    | `puudub`         |            67 |  **20 972.33 EUR** |
| 9️⃣ | **Annika Saar**  | Viljandi | `gold`           |            66 |  **20 726.79 EUR** |
|  🔟 | **Ago Kull**     | Pärnu    | `bronze`         |            64 |  **20 124.61 EUR** |
|     | **KOKKU**        |          |                  |       **718** | **228 336.79 EUR** |

---

# 🏙️ Müük linnade kaupa

## 📍 Kliendi asukohast sõltuvalt

| 🏙️ linn       | 👥 kliente | 🛒 oste |          💰 kogumüük |
| -------------- | ---------: | ------: | -------------------: |
| 🥇 **Tallinn** |       1007 |    3601 | **1 006 252.88 EUR** |
| 🥈 **Tartu**   |        525 |    1764 |   **523 286.64 EUR** |
| 🥉 **Pärnu**   |        276 |    1231 |   **374 005.86 EUR** |
| **Narva**      |        145 |     438 |   **122 226.14 EUR** |
| **Viljandi**   |         94 |     359 |   **102 314.94 EUR** |
| **Rakvere**    |         90 |     338 |    **93 379.03 EUR** |
| **Jõhvi**      |         71 |     290 |    **77 601.15 EUR** |
| **Kuressaare** |         80 |     256 |    **76 509.61 EUR** |
| **Haapsalu**   |         73 |     252 |    **73 492.83 EUR** |
| **Võru**       |         66 |     216 |    **60 983.07 EUR** |
| **Valga**      |         69 |     216 |    **59 530.76 EUR** |
| **Paide**      |         55 |     169 |    **53 148.87 EUR** |

---

## 🏪 Poe asukohast sõltuvalt

| 🏪 müügikanal        | 👥 kliente | 🛒 oste |          💰 kogumüük |
| -------------------- | ---------: | ------: | -------------------: |
| 🥇 **Tallinna pood** |       1789 |    3801 | **1 092 083.15 EUR** |
| 🥈 **veebimüük**     |       1706 |    3462 | **1 006 747.68 EUR** |
| 🥉 **Tartu pood**    |       1119 |    1797 |   **521 603.11 EUR** |
| **Pärnu pood**       |        746 |    1058 |   **288 744.04 EUR** |

---

# 💎 Müük lojaalsusastmete kaupa

| 💎 lojaalsusaste | 👥 kliente |          💰 kogumüük |
| ---------------- | ---------: | -------------------: |
| ⚪ **puudub**     |       1024 | **1 071 805.32 EUR** |
| 🥈 **silver**    |        560 |   **593 470.07 EUR** |
| 🥇 **gold**      |        491 |   **533 601.64 EUR** |
| 🥉 **bronze**    |        476 |   **423 854.75 EUR** |

---

# 🔎 Kokkuvõte

**Uurides TOP kliente INNER JOIN klausliga, leiti:**

> 🏆 Parimad UrbanStyle.ltd kliendid on oodatult peamiselt `kuld-` ja `hõbekliendid` ning eelkõige **Pärnust**.

> ⚠️ Samas kuulus TOP 10 ostleja hulka ka **kolm** `lojaalsustasemeta` klienti.

> 📊 **29.87%** klientidest on üle keskmise kulutajad.

---

## 🏙️ Tallinn vs Tartu

Suurim ostumaht tuleb **Tallinna** klientide poolt, samas on **Tartu** klientide ostumaht vaid u. **6,2%** madalam.

---

## ⭐ Pärnu üllatus

Üllatus tuli **Pärnu** klientidelt:

<table>
<tr>
<td align="center">
<h3>💰 1 355 EUR</h3>
kõrgeim müük kliendi kohta
</td>
<td align="center">
<h3>🛒 303.82 EUR</h3>
kõrgeim müük ostu kohta
</td>
<td align="center">
<h3>📈 4,46</h3>
kõrgeim ostude arv kliendi kohta
</td>
</tr>
</table>

> 💡 ***Pärnakad** pole mitte lihtsalt head ostlejad, vaid iga ost on olnud ka keskmiselt suurema väärtusega.*

---

## 🏪 Müügikohad

Kasumlikuim müügikoht on UrbanStyle.ltd **Tallinna pood**. Sams palju ei jää maha ka **veebimüük**: vaid **4,2%** madalam kui füüsilises poes.

---

## 💎 Kliendisegmendid

Suurima kogumüügiga kliendisegmendil **lojaalsustase puudub**. <br>
Järgnevad ⚪ **hõbe-**, 🟡 **kuld-** ja 🟠 **pronkskliendid**.

---

# 💡 Lisaks

📈 Keskmisest suuremad kulutajad<br>

> *UrbanStyle.ltd klientide seas **29,87%**. Seega ligi kolmandik klientidest tekitab keskmisest suurema ostumahu ning moodustab olulise osa ettevõtte potentsiaalsest müügitulust. <br>
UrbanStyle võiks keskenduda nende väärtuslike klientide hoidmisele ja lojaalsuse suurendamisele, liiati veel neil, kel hetkel lojaalsustase puudub. Nende ostukäitumine võib mõjutada oluliselt ettevõtte müügitulemust. <br>
Ligi **70%** klientidest on aga keskmisest väiksema ostumahuga, mistõttu on oluline potentsiaal suurendada ka nende klientide ostude sagedust või väärtust, et kasvatada ettevõtte kogumüüki.*

💡 Tuleks keskenduda väärtuslike klientide hoidmisele ja lojaalsuse suurendamisele, eriti lojaalsustasemeta klientide puhul.
Samuti tasub täpsemalt uurida Pärnu klientide ostukäitumist, vahest leidub seal mingi muster, mida rakendada ka mujal.

⚠️ Olemasolevad andmed võimaldavad võrrelda klientide kogumüüki, ostude arvu, asukohta, müügikanalit ja lojaalsustaset, kuid detailsemate järelduste tegemiseks oleks vaja täiendavaid kliendi- ja ostuandmeid.

---

<p align="center">
  <strong>📊 Sales Analytics · Week 3</strong><br>
  <sub>UrbanStyle.ltd</sub>
</p>

