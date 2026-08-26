# Product Data Cleaner - Week 2

---

**Meeskond:** Sales Analytics <br>
**Roll:** C – Product Data Cleaner <br>
**Link grupitööle:** [Sales Analytics](https://github.com/andres-assukyll/urbanstyle-sales-analytics/blob/main/week2/README.md)

Eesmärk analüüsida ja puhastada tooteandmete tabel.

---

#### 📌 Duplikaadid toodetes: *tuvastati* ⚠️

| Tooted                            | Koopiaid |
| --------------------------------- | :----------: |
| Moodne keraamiline sall           | 2            |
| Luksuslik teksane polo särk       | 2            |
| Stiilne puust müts                | 2            |
| Moodne villane nahk sandaalid     | 2            |
| Luksuslik keraamiline elastne vöö | 2            |
| Minimalistlik kashmiir bleiser    | 2            |
| Klassikaline kashmiir pusa        | 2            |
| Stiilne orgaaniline pidžaama      | 2            |
| Praktiline trikoo sukkpüksid      | 2            |
| Kerge siidine nahkkindad          | 2            |
| Elegantne keraamiline rahakott    | 2            |
| Vintage nahkne tossud             | 2            |
| **KOKKU**                         | **12**       |
---

#### 📌 NULL väärtusi tooteandmetes: *ei tuvastatud, puudusid* ✅

| Nimi |  Kategooria | Jaehind | Omahind |
| :---:| :---------:| :------:| :------:|
| 0    | 0           | 0       | 0       |

---

#### 📌 Hinnainfo ebakõlad: *ei tuvastatud, puudusid* ✅

| Kõrgeim hind | Madalaim hind | Negatiivne hind | Äärmuslik hind |
| :----------: | :-----------: | :-------------: | :------------: |  
| 434.08 EUR   | 13.53 EUR     | 0 tk            | 0 tk           |

| Ridu kokki | Tootenimed olemas | Kategooria olemas | Omahind olemas | Jaehind olemas | Omahind puudub | Jaehind puudub|
| :----------: | :-----------: | :-------------: | :------------: | :-----------: | :-------------: | :------------: |   
| 362        | 362               | 362             | 362               | 362                 | 0                  | 0                    |

---

#### 📌 Ebajärjekindlad kategooriad: *ei tuvastatud, puudusid* ✅

| Kategooria    | Arv |
| :-----------: | :-: |
| aksessuaarid  | 67  |
| jalanõusid    | 73  |
| laste_riided  | 70  |
| meeste_riided | 82  |
| naiste_riided | 70  |

---

## 📊 Kokkuvõtteks

![Probleemide kokkuvõte](./probleemid.svg)

> #### 💡 Soovitus
>
> *Soovitus on esmalt duplikaatsed tootenimed üle kontrollida ja vajadusel kirjed ühendada või korrigeerida. Duplikaadid võivad moonutada toodete arvu ning müügi- ja laoseisu analüüsi.*



---

### 🔎 Üllatus

Tooteandmete tabelit uurides leiti, et andmestik on üsna puhas. Tabelis tuvastati vaid 12 korduvat toodet.

---

### 💡 Järeldus

Andmestik on kasutatav edasiseks analüüsik, kui puhastada duplikaadid.
