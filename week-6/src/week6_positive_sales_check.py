
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
# 2. SALES-TABELI LUGEMINE
# --------------------------------------------------

def load_sales():
    """Loeb sales-tabeli kõik leheküljed DataFrame'i."""
    rows = []
    start = 0

    while True:
        response = (
            client.table("sales")
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


sales = load_sales()

if sales.empty:
    print("Sales-tabel on tühi. Kontrolli lõpetamiseks pole andmeid.")
    raise SystemExit(0)


# --------------------------------------------------
# 3. ARVUTUSLIKU MÜÜGISUMMA ARVUTAMINE
# --------------------------------------------------

sales["expected_total"] = (
    sales["quantity"] * sales["unit_price"]
).round(2)

sales["total_difference"] = (
    sales["total_price"] - sales["expected_total"]
).round(2)


# --------------------------------------------------
# 4. POSITIIVSE SUMMAGA VASTUOLUDE LEIDMINE
# --------------------------------------------------

positive_mismatches = sales[
    (sales["total_price"] > 0)
    & (sales["total_difference"].abs() > 0.01)
].copy()

# Arvuta erinevus protsendina arvutuslikust summast.
positive_mismatches["difference_pct"] = (
    positive_mismatches["total_difference"]
    / positive_mismatches["expected_total"].abs()
    * 100
).round(2)


# --------------------------------------------------
# 5. KOKKUVÕTE
# --------------------------------------------------

print("\n" + "=" * 60)
print("POSITIIVSE MÜÜGISUMMA VASTUOLUDE KONTROLL")
print("=" * 60)

print(f"Kõik müügiread: {len(sales)}")
print(f"Positiivse summaga vastuolulisi ridu: {len(positive_mismatches)}")

if len(positive_mismatches) > 0:
    print("\n--- SUURIMAD ABSOLUUTSED ERINEVUSED ---")

    columns_to_show = [
        "sale_id",
        "sale_date",
        "quantity",
        "unit_price",
        "expected_total",
        "total_price",
        "total_difference",
        "difference_pct",
        "channel",
        "store_location",
    ]

    print(
        positive_mismatches
        .assign(abs_difference=lambda df: df["total_difference"].abs())
        .sort_values("abs_difference", ascending=False)
        .drop(columns=["abs_difference"])
        [columns_to_show]
        .head(30)
        .to_string(index=False)
    )

    print("\n--- VASTUOLUD KANALI JÄRGI ---")

    channel_summary = (
        positive_mismatches.groupby("channel", dropna=False)
        .agg(
            ridu=("sale_id", "count"),
            keskmine_erinevus=("total_difference", "mean"),
            keskmine_abs_erinevus=(
                "total_difference",
                lambda x: x.abs().mean()
            ),
            erinevuste_summa=("total_difference", "sum"),
        )
        .round(2)
    )

    print(channel_summary.to_string())

    print("\n--- ERINEVUSTE SUUNAD ---")

    more_than_expected = (
        positive_mismatches["total_difference"] > 0
    ).sum()

    less_than_expected = (
        positive_mismatches["total_difference"] < 0
    ).sum()

    print(
        "Salvestatud summa on suurem kui arvutuslik:",
        more_than_expected
    )
    print(
        "Salvestatud summa on väiksem kui arvutuslik:",
        less_than_expected
    )

else:
    print("Positiivse summaga vastuolusid ei leitud.")


# --------------------------------------------------
# 6. CSV-FAILI SALVESTAMINE
# --------------------------------------------------

output_file = "week6_positive_total_price_errors.csv"

positive_mismatches.to_csv(
    output_file,
    index=False,
    encoding="utf-8-sig"
)

print("\n" + "=" * 60)
print("KONTROLL LÕPETATUD")
print("=" * 60)
print(f"Tulemused salvestatud faili: {output_file}")
