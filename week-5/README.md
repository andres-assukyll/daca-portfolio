# Visual Design & SQL — Week 5

**Meeskond:** Sales Analytics <br>
**Roll:** E+F – Valideerija & Kvaliteedikontroll + Ärisünteesi koondaja <br>
**Link grupitööle:** [Sales Analytics](https://github.com/andres-assukyll/urbanstyle-sales-analytics/blob/main/week5/README.md)

## 🎯 Eesmärk

Teha meeskonna töö **usaldusväärseks** ja **tervikuks**. Enne kui tulemus
stakeholderini jõuab, peab kontrollima, et numbrid klapiksid ja lugu oleks ühtne.

**Ülesanne**: Rollide A–D väljundid.


## 📋 Kvaliteedikontroll

### Esmane tabelite põhikontroll

[SQL päring](src/week5.esmane_kontroll.sql)

### UrbanStyle’i andmete valideerimise kokkuvõte

[SQL päring](src/week5.andmete_kvaliteedikontroll.sql)

### Päringute kontroll: OK / PARANDA

| Päring | Hinnang | Põhjendus |
|---|---|---|
| 1. Müügiandmete üldkontroll | **PARANDA / kontrolli** | 10 118 müügirida ja 10 118 unikaalset rearea ID-d. Puuduva kliendi-ID-ga on 988 rida ning negatiivse müügisummaga 195 rida. |
| 2. Aastakäive ja kasv | **OK** | 2023. aasta käive oli 1 234 758,90 € ja 2024. aastal 1 470 358,02 €. Käibe kasv **19,08%** vastab varasemale tulemusele. |
| 3. Käive kanali ja asukoha järgi | **OK, kontrolli perioodi** | Tallinn 1 092 083,15 €, online 1 006 747,68 €, Tartu 521 603,11 € ja Pärnu 288 744,04 €. |
| 4. Kanalite osakaal | **OK** | Füüsiliste poodide osakaal on 65,39% ja online-kanali osakaal 34,61%. |
| 5. Laoseis kategooriate kaupa | **VAJA LISAKONTROLLI** | Meeste riietel on suurim laokogus ja aksessuaaridel väikseim. Kogused üksi ei näita, kas laovaru on müügiga võrreldes sobiv. |
| 6. Laoandmete kvaliteet | **PARANDA** | 10 negatiivse laoseisuga rida, 7 nullkogusega rida ja 226 tellimispunktist madalama kogusega rida. Toodete vasted on olemas. |
| 7. Müügisumma kontroll | **PARANDA / uuri** | 501 rida ei vasta kontrollile `quantity × unit_price`; erinevuste summa on −117 003,03 €. Põhjuseks võivad olla allahindlused, maksud, tagastused või andmevead. |

## Olulisemad leiud

| Valdkond | Tulemus | Hinnang | Järeldus |
|---|---|---|---|
| Müügikasv | 2023: 1 234 758,90 €; 2024: 1 470 358,02 €; kasv 19,08% | **OK** | 2024. aasta müügikasv on kinnitatud. |
| Kogukäive | 2 909 177,98 € | **OK, kontrolli perioodi** | Kogukäive on ligikaudu 2,91 miljonit eurot. |
| Negatiivsed müügiread | 195 rida | **VAJA LISAKONTROLLI** | Selgita, kas tegemist on tagastuste, kreeditarvete või andmevigadega. |
| Puuduvad kliendi-ID-d | 988 rida | **VAJA LISAKONTROLLI** | Kontrolli, kas anonüümsed või tuvastamata kliendid on äriprotsessi järgi lubatud. |
| Müügisummade erinevused | 501 rida; erinevuste summa −117 003,03 € | **VAJA LISAKONTROLLI** | Kontrolli allahindluste, maksude ja tagastuste arvestust enne summade korrigeerimist. |
| Laoseis | 10 negatiivse laoseisuga rida | **PARANDA / uuri** | Kontrolli laoliikumisi ja võimalikke arvestusvigu. |
| Tellimispunktist madalam laoseis | 226 rida | **VAJA TEGEVUST** | Hinda täiendamise vajadust asukoha, müügikiiruse ja tarnetingimuste järgi. |
| Toodete seosed laoga | 0 vasteta tooterida | **OK** | Kõik kontrollitud laokirjed seostuvad olemasoleva tootega. |

### Järeldus

- **Kinnitatud:** 2024. aasta müügitulu kasvas 2023. aastaga võrreldes 19,08%.
- **Vajab uurimist:** negatiivsed müügiread, puuduvad kliendi-ID-d ja müügisummade erinevused.
- **Vajab tegevust:** negatiivsed laoseisud ja tellimispunktist madalamad laokogused.
- **Enne lõplike otsuste tegemist:** kontrolli, kas kõik analüüsid kasutavad sama ajavahemikku ja sama käibe arvestamise loogikat.

### Lisakontrollid

[SQL päring](src/week5.lisakontrollid.sql)

Need päringud aitavad eristada tegelikke andmevigu tavapärastest äritehingutest.
Lisakontrollid A ja B mõjutavad kõige otsesemalt käibe usaldusväärsust. 
Seejärel kontrolliti negatiivseid laoseise päringuga C. Hetkel on aastase kasvu näitaja kooskõlas varasema analüüsiga, kuid kogu andmestiku kvaliteeti ei saa veel lõplikult heaks kiita.

### Lisakontrolli tulemused

| Päring | Mida tulemus näitab | Hinnang |
|---|---|---|
| A — negatiivsed müügiread | Müügiandmetes on 195 negatiivse summaga rida. | Vajab põhjuste kontrolli: tagastused, kreeditarved või vigased kanded. |
| B — müügisumma võrdlus | Väljavõte näitab negatiivseid summasid ning mitme rea puhul erineb ka summa absoluutväärtus koguse ja ühikuhinna korrutisest. | Kontrollida eraldi märgikonventsiooni ja arvutuslikke lahknevusi. |
| C — probleemne laoseis | Väljavõttes esineb negatiivseid laokoguseid, nullseise ja koguseid, mis jäävad alla tellimispunkti. | Vajab laoandmete ning täiendamise protsessi kontrolli. |

## Koondvalideerimine: mis on kinnitatud?

| Näitaja | Tulemus | Järeldus |
|---|---:|---|
| Müügiridade arv | 10 118 | Kõikidel ridadel on unikaalne `id`. |
| Kogukäive | 2 909 177,98 € | Ümardatult 2,91 mln €. |
| Ostnud kliendid | 2 551 | Kooskõlas varasema koondtulemusega; tühjad kliendi-ID-d ei kuulu arvestusse. |
| Käibe kasv 2024 vs 2023 | 19,08% | Kinnitatud. |
| Puuduv `customer_id` | 988 rida | Kliendipõhine analüüs võib olla puudulik. |
| Negatiivne `total_price` | 195 rida | Vajab ärilise tähenduse selgitamist. |
| Müügisumma arvutuslik lahknevus | 501 rida | Vajab uuesti kontrollimist pärast negatiivsete summade käsitlemist. |
| Negatiivne laoseis | 10 rida | Laoandmete või laoliikumiste kontroll vajalik. |
| Null-laoseis | 7 rida | Võib tähendada läbimüüki või laopuudust. |
| Alla tellimispunkti | 226 rida | Vajab prioriseerimist. |
| Tooteta vastendamata laoread | 0 | Kontrollitud seos `inventory` ja `products` vahel on korras. |

> *Need tulemused kinnitavad, et põhilised müüginäitajad on arvutatavad, kuid andmete kvaliteet ei ole veel piisav kõigi juhtimisotsuste tegemiseks ilma täiendavate kontrollideta*.

### Müügikanalite ja asukohtade võrdlus

| Kanal või asukoht | Käive | Osakaal kogukäibest |
|---|---:|---:|
| Tallinna pood | 1 092 083,15 € | 37,5% |
| Online | 1 006 747,68 € | 34,6% |
| Tartu pood | 521 603,11 € | 17,9% |
| Pärnu pood | 288 744,04 € | 9,9% |
> *Osakaalud on arvutatud ligikaudsest kogukäibest 2,91 mln eurot; ümardamise tõttu ei pruugi need kokku anda täpselt 100%*.

Tallinna pood on suurima käibega müügikoht ja online-kanal on sellele lähedal. Füüsiliste poodide koondkäive on 1 902 430,30 € ehk 65,39% ning online-kanali osakaal 34,61%.
Laokategooriate koondpildi järgi on suurim laokogus meeste rõivastel ja väikseim aksessuaaridel. Seda ei saa siiski tõlgendada automaatselt optimaalse varude jaotusena: vaja on võrrelda varusid müügikiiruse, hooajalisuse ja tellimispunktidega.

## Ärilised järeldused ja soovitused

- **Müügikasv:** 2024. aasta käive kasvas 2023. aastaga võrreldes 19,08%. See on andmetega kinnitatud positiivne tulemus.
- **Kanalite juhtimine:** Tallinn ja e-pood on suurimad käibeallikad. Nende tulemuslikkust tasub analüüsida eraldi, sh marginaali ja tagastuste järgi, mitte ainult käibe põhjal.
- **Varude juhtimine:** tellimispunkti ületamise asemel tuleks prioriseerida tooteid, mille laoseis on negatiivne, nullis või alla tellimispunkti ning mille müügikiirus on kõrge.
- **Augusti–septembri kampaaniad:** varasemates rollide tulemustes esitatud soovitus tugevdada turundust suve lõpus ja sügise alguses on esialgne hüpotees. Enne eelarve muutmist tuleb kuude kaupa võrrelda müüki, uute klientide lisandumist ja kampaaniate mõju.
- **2025.–2026. aasta müügilangus:** seda ei tohiks käsitleda kinnitatud trendina enne, kui perioodid on võrreldavad. 2026. aasta andmed lõpevad 28. juunil ning seetõttu on aasta osaline.

## Kokkuvõte Kristile ja Annale

UrbanStyle’i müügiandmete esialgne valideerimine kinnitab, et 2024. aasta müügitulu kasvas võrreldes 2023. aastaga 19,08%, ulatudes 1,47 miljoni euroni. Suurima käibega müügikanal on Tallinna pood 1,09 miljoni euroga, millele järgneb e-poodligikaudu 1,01 miljoni euroga; füüsiliste poodide koondosakaal on 65,39%. Andmekvaliteedi kontroll tõi esile 195 negatiivse müügisummaga rida, 501 rida, kus müügisumma erineb koguse ja ühikuhinna korrutisest, ning 10 negatiivse laoseisuga rida, mis vajavad täiendavat uurimist. Enne lõplike juhtimisotsuste tegemist tuleb selgitada nende erinevuste põhjused ning hinnata laoseisu tellimispunktide ja toodete müügikiiruse põhjal.

