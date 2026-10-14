# Python : API ja pipline – Nädal 8
  
**Meeskond:** Sales Analytics    
**Roll:** B – Data processing
**Link grupitööle:** [Sales Analytics](https://github.com/andres-assukyll/urbanstyle-sales-analytics/blob/main/week8/README.md)

---

## 🎯 Eesmärk

Ehitada **modulaarne automatiseeritud pipeline**'i, mis:
1. Pärib andmed UrbanStyle.ltd Supabase API-st : `data_fetcher.py`
2. Töötleb andmed pandas pipeline'iga (puhastamine + transformeerimine) : `transform.py`
3. Visualiseerib tulemused ja salvestab failidesse : `visualize_export.py`
4. Automatiseerib kogu ETL-protsessi, ühendades pipeline'i etapid ajastamisloogika, töödeldava perioodi valiku ja e-posti teavitusega : `pipeline.py`

### 📋 LÜHIKOKKUVÕTE
**Ülesanne**: andmete puhastamine ja analüüs. Koostada `transform.py` fail, mis impordiks andmed `data_fetcher.py`-ist ning valmistaks need ette `visualize_export.py`jaoks.

<details>
<summary>Vaata kogu Python koodi</summary>
    ...
</details>

#### ✨ **Lisaülesanne**:
🔄 Lisada `data_fetcher.py` faili korduskatsete (*retry*) seadistuste lugemise funktsioon ning luua nende haldamiseks `config.yaml` fail. <br>
<details>
<summary>Vaata retry funktsiooni eraldi</summary>
...
</details>

🔄 Lisada `pipeline.py` faili töödeldava perioodi valik käsurea argumentidega, et oleks võimalik ühe päringuga väljastada mitme erineva perioodi andmeid. Samuti lisada kogu pipeline'i tulemusi koondav e-posti teavitus. <br>
<details>
<summary>Vaata perioodi funktsiooni eraldi</summary>
...
</details>

<details>
<summary>Vaata e-post teavituse funktsiooni eraldi</summary>
...
<details>

