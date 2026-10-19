
import os
import sys
import pandas as pd

from dotenv import load_dotenv
from supabase import create_client


# =====================================================
# 1. SEADISTUS
# =====================================================

load_dotenv()

TABLES = ["sales", "customers", "products"]
PAGE_SIZE = 1000
REPORT_FILE = "week6_validation_report.csv"


# =====================================================
# 2. SUPABASE'I KLIENT
# =====================================================

def get_client():
    """Loob Supabase'i kliendi .env faili väärtuste põhjal."""
    url = os.getenv("SUPABASE_URL")
    key = os.getenv("SUPABASE_KEY")

    if not url or not key:
        raise ValueError(
            "Puudub SUPABASE_URL või SUPABASE_KEY .env failis."
        )

    return create_client(url, key)


# =====================================================
# 3. ANDMETE LUGEMINE
# =====================================================

def fetch_table(client, table_name):
    """Loeb tabeli kõik read lehekülgede kaupa."""
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


# =====================================================
# 4. KVALITEEDIKONTROLL
# =====================================================

def validate_table(table_name, df):
    """Kontrollib tabeli põhilist andmekvaliteeti."""
    results = []

    def add(check, column, value, status, details):
        results.append({
            "table": table_name,
            "check": check,
            "column": column,
            "result": value,
            "status": status,
            "details": details,
        })

    # Ridade arv
    add(
        "row_count",
        "",
        len(df),
        "PARANDA" if df.empty else "OK",
        "Tabel on tühi."
        if df.empty
        else "Ridade arv loetud tabelist.",
    )

    # Täielikud duplikaadid
    duplicates = int(df.duplicated().sum())

    add(
        "full_duplicate_rows",
        "",
        duplicates,
        "KONTROLLI" if duplicates else "OK",
        "Kontrolli, kas korduvad read on põhjendatud."
        if duplicates
        else "Täielikke duplikaate ei leitud.",
    )

    # NULL-väärtused
    for column in df.columns:
        null_count = int(df[column].isna().sum())

        add(
            "null_count",
            column,
            null_count,
            "KONTROLLI" if null_count else "OK",
            "Hinda, kas puuduvad väärtused on lubatud."
            if null_count
            else "Puuduvaid väärtusi ei leitud.",
        )

    return results


# =====================================================
# 5. KÄIVITAMINE
# =====================================================

def main():
    client = get_client()
    all_results = []
    data = {}

    print("Ühendus Supabase'iga loodud.")

    for table in TABLES:
        print(f"\nLoen tabelit: {table}")

        df = fetch_table(client, table)
        data[table] = df

        print(f"Ridu: {len(df):,}")
        print(f"Veerud: {df.columns.tolist()}")

        all_results.extend(validate_table(table, df))

    report = pd.DataFrame(all_results)
    report.to_csv(REPORT_FILE, index=False, encoding="utf-8-sig")

    print("\n--- KVALITEEDIKONTROLLI KOKKUVÕTE ---")
    print(
        report.groupby(["table", "status"])
        .size()
        .unstack(fill_value=0)
        .to_string()
    )

    print(f"\nRaport salvestatud: {REPORT_FILE}")

    print("\n--- TABELITE VEERUD EDASISEKS RISTKONTROLLIKS ---")
    for table, df in data.items():
        print(f"{table}: {df.columns.tolist()}")

    print("\nEsialgne andmekvaliteedi kontroll lõpetatud.")


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        print(f"\nVIGA: {type(exc).__name__}: {exc}")
        sys.exit(1)

# ===========
# Kontrollin tabelite veergude nimesid


def inspect_table_columns(client, table_name):
    """Näitab tabeli veerunimesid ja pandas-andmetüüpe."""

    response = (
        client.table(table_name)
        .select("*")
        .limit(5)
        .execute()
    )

    df = pd.DataFrame(response.data or [])

    print(f"\n{'=' * 50}")
    print(f"TABEL: {table_name}")
    print("=" * 50)

    if df.empty:
        print("Tabel on tühi või esimesed 5 rida puuduvad.")
        print("Veerunimed ei pruugi olla tuvastatavad.")
        return

    print("\nVeerunimed:")
    for column in df.columns:
        print(f"- {column}")

    print("\nPandas-andmetüübid:")
    print(df.dtypes.to_string())

    print("\nNäidisandmed (kuni 5 rida):")
    print(df.head().to_string(index=False))


def main():
    client = get_client()

    for table in ["sales", "customers", "products"]:
        inspect_table_columns(client, table)


if __name__ == "__main__":
    main()