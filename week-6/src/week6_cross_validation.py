
import os

import pandas as pd
from dotenv import load_dotenv
from supabase import create_client


# --------------------------------------------------
# 1. SUPABASE'I ÜHENDUS
# --------------------------------------------------

load_dotenv()


def get_client():
    """Loob Supabase'i kliendi .env faili väärtuste põhjal."""
    url = os.getenv("SUPABASE_URL")
    key = os.getenv("SUPABASE_KEY")

    if not url or not key:
        raise ValueError(
            "Puudub SUPABASE_URL või SUPABASE_KEY. "
            "Kontrolli .env faili."
        )

    return create_client(url, key)


client = get_client()
PAGE_SIZE = 1000


# --------------------------------------------------
# 2. TABELITE LUGEMINE
# --------------------------------------------------

def load_table(table_name):
    """Loeb Supabase'i tabeli kõik leheküljed DataFrame'i."""
    rows = []
    start = 0

    while True:
        response = (
            client.table(table_name)
            .select("*")
            .range(start, start + PAGE_SIZE - 1)
            .execute()
        )

        batch = response.data or []
        rows.extend(batch)

        if len(batch) < PAGE_SIZE:
            break

        start += PAGE_SIZE

    return pd.DataFrame(rows)


sales = load_table("sales")
customers = load_table("customers")
products = load_table("products")


# --------------------------------------------------
# 3. RIDADE ARV JA ID-DE UNIKAALSUS
# --------------------------------------------------

print("\n" + "=" * 50)
print("RIDADE ARV")
print("=" * 50)

for name, df in [
    ("sales", sales),
    ("customers", customers),
    ("products", products),
]:
    print(f"{name}: {len(df)} rida")


print("\n" + "=" * 50)
print("DUPLIKAATSED ID-D")
print("=" * 50)

for table, df, col in [
    ("sales", sales, "id"),
    ("sales", sales, "sale_id"),
    ("customers", customers, "customer_id"),
    ("products", products, "product_id"),
]:
    print(f"{table}.{col}: {df[col].duplicated().sum()} duplikaati")


# --------------------------------------------------
# 4. PUUDUVAD OLULISED VÄÄRTUSED
# --------------------------------------------------

print("\n" + "=" * 50)
print("PUUDUVAD OLULISED VÄÄRTUSED")
print("=" * 50)

required_columns = {
    "sales": [
        "sale_id", "sale_date", "customer_id",
        "product_id", "quantity", "unit_price", "total_price"
    ],
    "customers": ["customer_id"],
    "products": ["product_id", "cost_price", "retail_price"],
}

tables = {
    "sales": sales,
    "customers": customers,
    "products": products,
}

for table, cols in required_columns.items():
    df = tables[table]

    for col in cols:
        print(f"{table}.{col}: {df[col].isna().sum()} puuduvat")


# --------------------------------------------------
# 5. MÜÜGISUMMA KONTROLL
# --------------------------------------------------

sales["expected_total"] = (
    sales["quantity"] * sales["unit_price"]
).round(2)

sales["total_difference"] = (
    sales["total_price"] - sales["expected_total"]
).round(2)

bad_totals = sales[
    sales["total_difference"].abs() > 0.01
].copy()

print("\n" + "=" * 50)
print("MÜÜGISUMMA VASTUOLUD")
print("=" * 50)

print(f"Vastuolulisi ridu: {len(bad_totals)}")

print(
    bad_totals[
        [
            "sale_id", "quantity", "unit_price",
            "total_price", "expected_total", "total_difference"
        ]
    ].head(20).to_string(index=False)
)


# --------------------------------------------------
# 6. KLIENDI- JA TOOTESEOSTE KONTROLL
# --------------------------------------------------

customer_ids = set(customers["customer_id"].dropna())
product_ids = set(products["product_id"].dropna())

missing_customers = sales[
    ~sales["customer_id"].isin(customer_ids)
].copy()

missing_products = sales[
    ~sales["product_id"].isin(product_ids)
].copy()

print("\n" + "=" * 50)
print("PUUDUVAD SEOSED")
print("=" * 50)

print(f"Müügid puuduva kliendiga: {len(missing_customers)}")
print(f"Müügid puuduva tootega: {len(missing_products)}")


# --------------------------------------------------
# 7. HINDADE JA KOGUSTE KONTROLL
# --------------------------------------------------

print("\n" + "=" * 50)
print("VÕIMALIKUD HINNA- JA KOGUSEVEAD")
print("=" * 50)

print("Null või negatiivne kogus:", (sales["quantity"] <= 0).sum())
print("Null või negatiivne ühikuhind:", (sales["unit_price"] <= 0).sum())
print("Null või negatiivne müügisumma:", (sales["total_price"] <= 0).sum())
print("Negatiivne omahind:", (products["cost_price"] < 0).sum())
print("Negatiivne jaehind:", (products["retail_price"] < 0).sum())

print(
    "Jaehind alla omahinna:",
    (products["retail_price"] < products["cost_price"]).sum()
)


# --------------------------------------------------
# 8. KUUPÄEVADE KONTROLL
# --------------------------------------------------

sales["sale_date_parsed"] = pd.to_datetime(
    sales["sale_date"],
    errors="coerce"
)

print("\n" + "=" * 50)
print("KUUPÄEVAD")
print("=" * 50)

print(
    "Vigased või puuduvad müügikuupäevad:",
    sales["sale_date_parsed"].isna().sum()
)

print("Esimene müük:", sales["sale_date_parsed"].min())
print("Viimane müük:", sales["sale_date_parsed"].max())


# --------------------------------------------------
# 9. MÜÜGIKANALID JA KAUPLUSED
# --------------------------------------------------

print("\n" + "=" * 50)
print("MÜÜGIKANALID")
print("=" * 50)

print(sales["channel"].value_counts(dropna=False).to_string())

print("\n" + "=" * 50)
print("KAUPLUSED")
print("=" * 50)

print(sales["store_location"].value_counts(dropna=False).to_string())


# --------------------------------------------------
# 10. PROBLEEMSETE RIDADE SALVESTAMINE
# --------------------------------------------------

bad_totals.to_csv(
    "week6_total_price_errors.csv",
    index=False
)

missing_customers.to_csv(
    "week6_missing_customers.csv",
    index=False
)

missing_products.to_csv(
    "week6_missing_products.csv",
    index=False
)

print("\n" + "=" * 50)
print("KONTROLL LÕPETATUD")
print("=" * 50)

print("Loodud failid:")
print("- week6_total_price_errors.csv")
print("- week6_missing_customers.csv")
print("- week6_missing_products.csv")



# Uurin, miks kliendiseosed puuduvad

customer_ids = set(customers["customer_id"].dropna())

missing_customers = sales[
    ~sales["customer_id"].isin(customer_ids)
].copy()

print("\n--- PUUDUVAD KLIENDID KANALI JÄRGI ---")
print(
    missing_customers["channel"]
    .value_counts(dropna=False)
    .to_string()
)

print("\n--- PUUDUVAD KLIENDID KAUPLUSE JÄRGI ---")
print(
    missing_customers["store_location"]
    .value_counts(dropna=False)
    .to_string()
)

print("\n--- PUUDUVAD KLIENDID AASTA JÄRGI ---")
missing_customers["sale_year"] = pd.to_datetime(
    missing_customers["sale_date"],
    errors="coerce"
).dt.year

print(
    missing_customers["sale_year"]
    .value_counts(dropna=False)
    .sort_index()
    .to_string()
)

print("\n--- NÄIDIS PUUDUVA KLIENDIGA MÜÜKIDEST ---")
print(
    missing_customers[
        ["sale_id", "sale_date", "customer_id",
         "product_id", "channel", "store_location", "total_price"]
    ].head(20).to_string(index=False)
)

# Uurin müügisummade erinevusi

# Eeldab, et sales sisaldab juba expected_total ja total_difference veerge.

print("\n--- ERINEVUSEGA MÜÜGIREAD: KOONDTABEL ---")

sales["difference_type"] = "summa klapib"
sales.loc[
    sales["total_difference"] > 0.01,
    "difference_type"
] = "total_price suurem kui arvutuslik summa"

sales.loc[
    sales["total_difference"] < -0.01,
    "difference_type"
] = "total_price väiksem kui arvutuslik summa"

print(
    sales["difference_type"]
    .value_counts()
    .to_string()
)

print("\n--- NEGATIIVSE MÜÜGISUMMA KONTROLL ---")
negative_sales = sales[sales["total_price"] < 0]

print("Negatiivseid ridu:", len(negative_sales))
print(
    negative_sales[
        ["sale_id", "sale_date", "quantity",
         "unit_price", "total_price", "channel"]
    ].head(20).to_string(index=False)
)

print("\n--- SUURIMAD ABSOLUUTSED ERINEVUSED ---")
print(
    sales.loc[
        sales["total_difference"].abs().nlargest(20).index,
        ["sale_id", "quantity", "unit_price",
         "total_price", "expected_total", "total_difference"]
    ].to_string(index=False)
)

# Eristan tagastused

# Eeldab, et sales, customers ja products on juba laaditud.

import pandas as pd

# Arvuta võrdlusväärtused uuesti, et kontroll oleks iseseisev.
sales["expected_total"] = (
    sales["quantity"] * sales["unit_price"]
).round(2)

sales["total_difference"] = (
    sales["total_price"] - sales["expected_total"]
).round(2)

sales["summa_staatus"] = "Klapi"

sales.loc[
    sales["total_difference"].abs() > 0.01,
    "summa_staatus"
] = "Erinevus"

sales["summa_märk"] = sales["total_price"].apply(
    lambda x: (
        "Negatiivne" if x < 0
        else "Null" if x == 0
        else "Positiivne"
    )
)

print("\n--- SUMMA VASTUOLUD MÄRGI JÄRGI ---")
print(
    pd.crosstab(
        sales["summa_märk"],
        sales["summa_staatus"]
    ).to_string()
)

print("\n--- VASTUOLUD KANALI JÄRGI ---")
print(
    sales[sales["summa_staatus"] == "Erinevus"]
    .groupby("channel")
    .agg(
        vastuolulisi_ridu=("sale_id", "count"),
        negatiivseid_summasid=(
            "total_price", lambda s: (s < 0).sum()
        ),
        erinevuse_kogusumma=("total_difference", "sum")
    )
    .to_string()
)

print("\n--- PUUDUVATE KLIENDI-ID-DE AASTAKONTROLL ---")
missing = sales[sales["customer_id"].isna()].copy()
missing["year"] = pd.to_datetime(
    missing["sale_date"], errors="coerce"
).dt.year

print(
    missing.groupby("year")
    .agg(
        puuduva_kliendiga_müüke=("sale_id", "count"),
        müügitulu=("total_price", "sum")
    )
    .round(2)
    .to_string()
)

print("\n--- KOKKUVÕTE ---")
print("Kõik müügiread:", len(sales))
print("Summaerinevusega read:", (sales["summa_staatus"] == "Erinevus").sum())
print("Negatiivse summaga read:", (sales["total_price"] < 0).sum())
print("Puuduva kliendi-ID-ga read:", sales["customer_id"].isna().sum())
