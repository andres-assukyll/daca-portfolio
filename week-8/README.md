# Python : API ja pipeline – Nädal 8
  
**Meeskond:** Sales Analytics    
**Roll:** B – Data processing
**Link grupitööle:** [Sales Analytics](https://github.com/andres-assukyll/urbanstyle-sales-analytics/blob/main/week8/README.md)

---

## 🎯 Eesmärk

Laadida UrbanStyle.Ltd müügi- ja kliendiandmed Supabase'ist ning luua **modulaarne automatiseeritud ETL-pipeline**, mis:

1. 🔌 Pärib andmed UrbanStyle.Ltd Supabase API-st – `data_fetcher.py`
2. 🧹 Puhastab ja teisendab andmed pandas-teegi abil – `transform.py`
3. 📈 Visualiseerib tulemused ja salvestab need failidesse – `visualize_export.py`
4. ⚙️ Automatiseerib kogu protsessi, ühendades etapid ajastamisloogika, töödeldava perioodi valiku ja e-posti teavitusega – `pipeline.py`

### 🧹 **Peamine ülesanne: andmete puhastamine ja analüüs**

Koostada `transform.py` fail, mis impordib müügi- ja kliendiandmed `data_fetcher.py` failist, kontrollib nende kvaliteeti ning teostab andmete puhastamise ja transformeerimise. Valmistada andmed ette edasiseks analüüsiks ja visualiseerimiseks failis `visualize_export.py`.

Lisaks rakendada logimise funktsionaalsus (`logging`), et salvestada protsessi käigus olulised sündmused, teated ja vead ning lihtsustada andmetöötluse jälgimist ja probleemide tuvastamist.

🔗 [Vaata kogu Python koodi](individual/transform.py)


#### ✨ **Lisaülesanded**

🔄 **Korduskatsete (*retry*) seadistuste haldamine**

Lisada `data_fetcher.py` faili funktsioon `get_retry_settings()`, mis loeb `config.yaml` failist andmete päringute korduskatsete seadistused, sealhulgas maksimaalse korduskatsete arvu (`max_retries`) ja korduskatsete vahelise viivituse (`retry_delay_seconds`). Luua eraldi `config.yaml` konfiguratsioonifail, et korduskatsete parameetreid saaks hallata ja muuta Python-koodi väliselt. Hoida seadistuste lugemise funktsioon eraldi, et selle vastutus oleks selgelt piiritletud ning konfiguratsiooni kasutamine lihtsasti hallatav.

⚙️ **Töödeldava perioodi valik ja ETL-pipeline'i täiendamine**

Täiendada `pipeline.py` faili käsurea argumentide töötlemisega, kasutades `argparse` moodulit. Lisada `--period` argument, mille kaudu saab määrata ühe või mitu andmete töötlemise perioodi. See võimaldab käivitada ETL-pipeline'i ühe käsuga ning töödelda valitud ajavahemike müügi- ja kliendiandmeid ilma iga perioodi jaoks eraldi käivitust tegemata. Tagada, et iga määratud periood läbib vajalikud andmete hankimise, puhastamise, transformeerimise, analüüsi ja tulemuste väljastamise etapid.

📧 **Kogu pipeline'i tulemusi koondav teavitus e-kirja teel**

Lisada `pipeline.py` faili e-kirja teavituse funktsionaalsus, mis koondab ühe käivitamise käigus töödeldud perioodide tulemused ühte kokkuvõtvasse e-kirja. Teavitus peab sisaldama töödeldud perioodide infot, peamisi tulemusi ja KPI-sid, loodud väljundfailide asukohti ning vajaduse korral infot töötlemise käigus tekkinud vigade kohta. Kujundada teavituse sisu nii, et see annaks kiire ülevaate kogu pipeline'i käivitamise tulemusest, mitte ainult üksiku perioodi töötlemisest.

Lisada käivitamise lõpus üldise staatuse määramine (`SUCCESS`, `WARNING` või `FAILURE`), et eristada edukat töötlemist, osaliste probleemidega käivitamist ja ebaõnnestumist. Saata koondteavitus pärast perioodide töötlemist ning kuvada lõplik staatus ka terminalis. Eesmärk on muuta andmetöötlusprotsess paremini jälgitavaks, lihtsamini hallatavaks ja automatiseerimiseks sobivaks.

