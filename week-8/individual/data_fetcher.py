import os
import time
from pathlib import Path

import pandas as pd
import yaml
from dotenv import load_dotenv
from supabase import create_client


# Projekti põhikaust.
BASE_DIR = Path(__file__).resolve().parent

# Loeme .env faili selle Python-failiga samast kaustast.
env_path = BASE_DIR / ".env"
load_dotenv(env_path)

# config.yaml asub projekti põhikaustas.
config_path = BASE_DIR / "config.yaml"


def load_config():
    """Loeb projekti seadistused config.yaml failist."""
    if not config_path.exists():
        raise FileNotFoundError(
            f"Config-faili ei leitud: {config_path}"
        )

    with open(config_path, "r", encoding="utf-8") as file:
        config = yaml.safe_load(file)

    if not config:
        raise ValueError(
            "config.yaml on tühi või vigane."
        )

    return config


def get_retry_settings():
    """Loeb Supabase retry-seadistused config.yaml failist."""
    config = load_config()

    supabase_config = config["supabase"]

    max_retries = supabase_config["max_retries"]
    retry_delay_seconds = supabase_config["retry_delay_seconds"]

    return max_retries, retry_delay_seconds


def get_client():
    """Loob Supabase'i kliendi .env faili väärtuste põhjal."""
    url = os.getenv("SUPABASE_URL")
    key = os.getenv("SUPABASE_KEY")

    if not url or not key:
        raise ValueError(
            "Puudub SUPABASE_URL või SUPABASE_KEY."
        )

    return create_client(url, key)


def fetch_table(
    table_name,
    order_column,
    start_date=None,
    end_date=None
):
    """Pärib tabeli andmed lehekülgede kaupa ja tagastab DataFrame'i."""
    try:
        supabase = get_client()

        # Retry-seadistused tulevad config.yaml failist.
        max_retries, retry_delay_seconds = (
            get_retry_settings()
        )

        all_rows = []
        page_size = 1000
        offset = 0

        while True:
            last_error = None

            # Proovime iga lehekülje päringut vastavalt
            # config.yaml seadistustele mitu korda.
            for attempt in range(1, max_retries + 1):
                try:
                    # Kindel järjestus aitab lehekülgi
                    # järjepidevalt pärida.
                    query = (
                        supabase
                        .table(table_name)
                        .select("*")
                        .order(order_column)
                    )

                    # Müügi kuupäevafiltrid lisame ainult siis,
                    # kui funktsiooni kasutaja need ette annab.
                    if start_date is not None:
                        query = query.gte(
                            "sale_date",
                            start_date
                        )

                    if end_date is not None:
                        # Kaasame ka lõppkuupäeva terve päeva.
                        next_day = (
                            pd.Timestamp(end_date).normalize()
                            + pd.Timedelta(days=1)
                        ).isoformat()

                        query = query.lt(
                            "sale_date",
                            next_day
                        )

                    # range() lõpp on kaasav:
                    # 0–999 tähendab 1000 rida.
                    response = query.range(
                        offset,
                        offset + page_size - 1
                    ).execute()

                    # Päring õnnestus.
                    last_error = None
                    break

                except Exception as error:
                    last_error = error

                    if attempt < max_retries:
                        print(
                            f"HOIATUS: Supabase päring "
                            f"tabelile '{table_name}' "
                            f"ebaõnnestus "
                            f"({attempt}/{max_retries}). "
                            f"Uus katse "
                            f"{retry_delay_seconds} sekundi pärast..."
                        )

                        time.sleep(retry_delay_seconds)

                    else:
                        print(
                            f"VIGA: Supabase päring "
                            f"tabelile '{table_name}' "
                            f"ebaõnnestus pärast "
                            f"{max_retries} katset."
                        )

            # Kui kõik katsed ebaõnnestusid,
            # anname viimase vea edasi.
            if last_error is not None:
                raise last_error

            rows = response.data

            # Tühi lehekülg tähendab,
            # et rohkem ridu pole.
            if not rows:
                break

            all_rows.extend(rows)
            offset += len(rows)

        return pd.DataFrame(all_rows)

    except Exception as error:
        # Anname vea edasi, et pipeline ei jätkaks
        # puudulike andmetega.
        raise RuntimeError(
            f"Tabeli '{table_name}' pärimine ebaõnnestus "
            f"({type(error).__name__})."
        ) from error


def fetch_sales(start_date=None, end_date=None):
    """Tagastab müügiandmed, soovi korral kuupäevavahemikus."""
    return fetch_table(
        "sales",
        "id",
        start_date=start_date,
        end_date=end_date,
    )


def fetch_customers():
    """Tagastab kliendiandmed."""
    return fetch_table(
        "customers",
        "customer_id"
    )


def fetch_products():
    """Tagastab tooteandmed."""
    return fetch_table(
        "products",
        "product_id"
    )


# Kontroll käivitub faili otse käivitamisel.
# Teisest failist importides see plokk ei käivitu.
if __name__ == "__main__":
    checks = [
        (
            "Müügid jaanuaris 2023",
            lambda: fetch_sales(
                "2023-01-01",
                "2023-01-31"
            )
        ),
        (
            "Kliendid",
            fetch_customers
        ),
        (
            "Tooted",
            fetch_products
        ),
    ]

    for name, fetch_function in checks:
        try:
            df = fetch_function()

            print(
                f"\n{name}: "
                f"{len(df)} rida, "
                f"{len(df.columns)} veergu"
            )

            print(df.head())

            if df.empty:
                print(
                    "HOIATUS: tabelist ei saadud andmeid."
                )

        except RuntimeError as error:
            print(f"\nVIGA: {error}")
