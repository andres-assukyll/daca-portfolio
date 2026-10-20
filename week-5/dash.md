Samm 5. Ehita dashboard’i visuaalid
Power BI raportivaates lisa elemendid sellises järjekorras.

Ülemine rida: KPI-kaardid

Card-visual: kogukäive, käibe kasv, ostnud kliendid, probleemsed müügiread.




Keskmine vasak pool: müük

Line chart kuude lõikes; bar chart Tallinna, online'i, Tartu ja Pärnu võrdluseks.




Keskmine parem pool: laoseis

Staatuskaartide rida ja tabel madala või negatiivse laoseisuga toodetest.




Alumine osa: andmekvaliteet

Tabel kontrolli nime, kirjete arvu, staatuse ja soovitatud tegevusega.



Samm 6. Rakenda UrbanStyle'i värvid
Power BI-s saad määrata värvid iga visualiseeringu Format visual paneelil. Lehe taustaks määra valge, sektsioonidele helehall ning põhiaktsentvärviks #009B8D.
- Teal: #009B8D
- Navy: #1A1A2E
- Valge: #FFFFFF
- Helehall: #F5F5F5
- Roheline: positiivne tulemus
- Oranž: kontrollimist vajav tulemus
Kasuta Calibrit, pealkirjadel 18–24 pt, põhitekstil 12–14 pt ja siltidel 10–12 pt.

Alustame sinu tegelikest andmetest
Et saaksin anda järgmises etapis täpsed DAX-valemid ja õiged seosed ilma veerunimesid oletamata, oleks mul vaja näha sinu tabelite struktuuri.

Kõige lihtsam on avada Supabase'i SQL Editor ja käivitada järgmine päring:
SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name IN (
      'sales',
      'customers',
      'products',
      'inventory'
  )
ORDER BY table_name, ordinal_position;
