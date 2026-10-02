## A: Andmete laadimine

#### Kood:

```python
import pandas as pd

# Müügi- ja klienditabeli laadimine

df_sales = pd.read_csv('sales.csv')

print(' === Esimesed 5 müügitabeli rida === \n')
print(df_sales.head())
print('\n === Ridade ja veergude arv sales tabelis === \n')
print(df_sales.shape)

df_customers = pd.read_csv('customers.csv')

print('\n === Esimesed 5 klienditabeli rida === \n')
print(df_customers.head())
print('\n === Ridade ja veergude arv customers tabelis === \n')
print(df_customers.shape)

# Tabelite JOIN by customer_id

df = pd.merge(df_sales, df_customers, on='customer_id', how='left')

print('\n === Esimesed 5 ühendatud tabeli rida === \n')
print(df.head())
print('\n === Ridade ja veergude arv ühendatud tabelis === \n')
print(df.shape)
print('\n === Andmetüübid ühendatud tabelis === \n')
print(df.dtypes)
```

#### Kuvab:

=== Esimesed 5 müügitabeli rida === 

   sale_id        invoice_id   sale_date  customer_id  product_id  quantity  \
0        1  INV-202301-00001  2023-01-10       2588.0        1274         2   
1        2  INV-202301-00002  2023-01-16       4338.0        1207         2   
2        3  INV-202301-00003  2023-01-05       4673.0        1264         1   
3        4  INV-202301-00004  2023-01-02       4677.0        1341         3   
4        5  INV-202301-00005  2023-01-13       2390.0        1284         1   

   unit_price  total_price channel store_location payment_method  
0      234.79       469.58    pood        Tallinn          kaart  
1      241.13       482.26    pood          Pärnu      järelmaks  
2      258.46       221.19    pood          Pärnu      järelmaks  
3       45.21       135.63    pood          Tartu       sularaha  
4       99.57        99.57    pood          Tartu          kaart  

 === Ridade ja veergude arv sales tabelis === 

(15234, 11)

 === Esimesed 5 klienditabeli rida === 

   customer_id first_name last_name                   email           phone  \
0         2001        Eha       Aas        eha.aas@telia.ee  +372 8713 1455   
1         2002      Aivar      Kõiv  aivar.koiv@outlook.com  +372 8943 8684   
2         2003      Maris    Rebane   maris.rebane@telia.ee  +372 5918 5726   
3         2004       Jaak    Talvik     jaak.talvik@mail.ee  +372 8554 4232   
4         2005      Raivo    Koppel  raivo.koppel@yahoo.com  +372 5298 4365   

       city registration_date loyalty_tier  birth_year    
0   Tallinn        2024-02-27          NaN        1973  
1  Haapsalu        2025-01-09       bronze        1988  
2     Tartu        2021-02-03          NaN        1999  
3   Tallinn        2023-11-12       silver        1974  
4   Tallinn        2023-05-22       bronze        2004  

 === Ridade ja veergude arv customers tabelis === 

(3150, 9)

 === Esimesed 5 ühendatud tabeli rida === 

   sale_id        invoice_id   sale_date  customer_id  product_id  quantity  \
0        1  INV-202301-00001  2023-01-10       2588.0        1274         2   
1        2  INV-202301-00002  2023-01-16       4338.0        1207         2   
2        3  INV-202301-00003  2023-01-05       4673.0        1264         1   
3        4  INV-202301-00004  2023-01-02       4677.0        1341         3   
4        5  INV-202301-00005  2023-01-13       2390.0        1284         1   

   unit_price  total_price channel store_location payment_method first_name  \
0      234.79       469.58    pood        Tallinn          kaart      Hille   
1      241.13       482.26    pood          Pärnu      järelmaks      Merle   
2      258.46       221.19    pood          Pärnu      järelmaks      Liina   
3       45.21       135.63    pood          Tartu       sularaha       Aili   
4       99.57        99.57    pood          Tartu          kaart      Triin   

  last_name                 email           phone     city registration_date  \
0      Paju                   NaN  +372 5429 0294  Tallinn        2022-07-28   
1      Luik    merle.luik@mail.ee  +372 5150 1812  Tallinn        2020-09-22   
2      Saar  liina.saar@gmail.com  +372 8809 7990  Tallinn        2020-03-31   
3      Pihl   aili.pihl@yahoo.com  +372 8375 4888    Narva        2021-10-08   
4      Lill   triin.lill@telia.ee  +372 5378 0596    Tartu        2021-04-09   

  loyalty_tier  birth_year  
0       bronze      1997.0  
1          NaN      1996.0  
2       silver      1973.0  
3         gold      1972.0  
4          NaN      1996.0  

 === Ridade ja veergude arv ühendatud tabelis === 

(15234, 19)

 === Andmetüübid ühendatud tabelis === 

sale_id                int64
invoice_id               str
sale_date                str
customer_id          float64
product_id             int64
quantity               int64
unit_price           float64
total_price          float64
channel                  str
store_location           str
payment_method           str
first_name               str
last_name                str
email                    str
phone                    str
city                     str
registration_date        str
loyalty_tier             str
birth_year           float64
dtype: object

--

## B: Andmete puhastamine

#### Kood:

```python
# Algne DF

print(' === Ühendatud tabeli read ja veerud enne puhastamist === \n')
print(df.shape)

# Duplikaatide leidmine 

print('\n === Duplikaatide arv === \n')
print('Duplikaadid:', df.duplicated(subset=['invoice_id']).sum())

# Duplikaatide eemaldamine

df = df.drop_duplicates(subset=['invoice_id'], keep='first')

# NULL väärtused

print('\n === NULL-väärtuste arv === \n')
print("NULL-id:\n", df.isnull().sum())

# NULL-ide eemaldamine veergudes: customer_id, sale_date, total_price

df = df.dropna(subset=['customer_id', 'sale_date', 'total_price'])

# Kuupäeva teisendamine

df['sale_date'] = df['sale_date'].apply(lambda x: pd.to_datetime(x, format='%d/%m/%Y')
                                        if '/' in x else pd.to_datetime(x)
                                        )

# 26 kuud alates 01/2023

before = len(df) # Enne kuupäevavahemiku filtreerimist

df = df[(df['sale_date'] >= '2023-01-01') & (df['sale_date'] < '2025-03-01')]

print('\n === Kuupäevavahemiku tõttu eemaldatud read === \n') 
print(before - len(df))

# Äärmuslikud väärtused total_price veerus

print('\n === Negatiivsete total_price väärtuste arv === \n')
print((df['total_price'] < 0).sum())

# # Negatiivsete total_price väärtuste eemaldamine  

df = df[df['total_price'] > 0]

# PUHASTUSRAPORT

print('\n === Puhastamisraport === \n')
print(f'Puhastatud tabel: {df.shape[0]} rida, {df['customer_id'].nunique()} klienti')
print(f'Kuupäevavahemik: {df['sale_date'].min().date()} - {df['sale_date'].max().date()}')
```
#### Kuvab:

=== Ühendatud tabeli read ja veerud enne puhastamist === 

(15234, 19)

 === Duplikaatide arv === 

Duplikaadid: 5116

 === NULL-väärtuste arv === 

NULL-id:
 sale_id                 0
invoice_id              0
sale_date               0
customer_id           988
product_id              0
quantity                0
unit_price              0
total_price             0
channel                 0
store_location       3462
payment_method          0
first_name            988
last_name             988
email                1944
phone                 988
city                  988
registration_date     988
loyalty_tier         4660
birth_year            988
dtype: int64

 === Kuupäevavahemiku tõttu eemaldatud read === 

28

 === Negatiivsete total_price väärtuste arv === 

179

 === Puhastamisraport === 

Puhastatud tabel: 8923 rida, 2540 klienti
Kuupäevavahemik: 2023-01-01 - 2025-02-28
