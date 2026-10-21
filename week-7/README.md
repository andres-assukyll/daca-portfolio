# Python : RFM-analüüs — Week 7

**Meeskond:** Sales Analytics <br>
**Roll:** A – Andmete laadimine ja puhastamine <br>
**Link grupitööle:** [Sales Analytics](https://github.com/andres-assukyll/urbanstyle-sales-analytics/blob/main/week7/README.md)

---

## 🎯 Eesmärk

Laadida UrbanStyle.ltd müügi- ja kliendiandmed Supabase'ist pandas
DataFrame'i. <br>
Kontrollida andmete struktuuri ja kvaliteeti ning liita tabelid üheks töötavaks DataFrame'iks.

#### 🗄️ **Andmeallikad**: Nädal 1 CSV failid (`sales.csv` + `customers.csv`)
> *Supabase'i ühenduse probleemide tõttu kasutati lõpliku lahendusena lokaalset fallback-lahendust*.

---

### 📈 RFM-analüüsi ettevalmistus

Müügi- ja kliendiandmete töötlemiseks koostati **Pythonis** andmetöötluse lahendus **Jupyter Notebooki** keskkonnas. Lokaalsed CSV-failid laaditi **pandase DataFrame**'idesse ning kontrolliti andmete struktuuri ja kvaliteeti. Seejärel ühendati tabelid ühtseks **DataFrame**'iks ning koostati andmete **puhastusraport** edasise **RFM-analüüsi** ettevalmistamiseks.

📓 [Ava Jupyter Notebooki fail](./individual/week7_rfm_role_A.ipynb)

---

### ✨ Lisaülesanne: RFM-segmentatsioon ja visualiseerimine

RFM-mudeli abil segmenteeriti kliendid nende ostukäitumise põhjal ning visualiseeriti analüüsi tulemused, et tuua esile kliendisegmentide erinevused ja toetada andmepõhiste turundusotsuste tegemist.

📊 [Vaata täpsemalt RFM-analüüsi ja visualiseeringuid](./individual/rfm_analysis.md)

#### 🤖 Kasutamine ✨
> Jupyter...
