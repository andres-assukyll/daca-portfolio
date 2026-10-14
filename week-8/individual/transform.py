import logging

import pandas as pd

from data_fetcher import (
    fetch_sales,
    fetch_customers,
    fetch_products
)


# =========================================================
# LOGIMISE SEADISTUS
# =========================================================

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

logger = logging.getLogger(__name__)


# =========================================================
# 1. ANDMEVALIDATSIOON
# =========================================================

def validate_sales_data(df: pd.DataFrame) -> None:
    """
    Kontrollib müügiandmete põhivälju,
    veerutüüpe ja väärtuste mõistlikkust.
    """

    logger.info("Alustan müügiandmete valideerimist.")

    # Kontrollime, kas DataFrame on tühi
    if df.empty:
        raise ValueError("Müügiandmestik on tühi.")

    # Oodatud veerud
    required_columns = [
        "sale_id",
        "customer_id",
        "sale_date",
        "total_price"
    ]

    missing_columns = [
        column
        for column in required_columns
        if column not in df.columns
    ]

    if missing_columns:
        raise ValueError(
            f"Müügiandmetest puuduvad veerud: {missing_columns}"
        )

    logger.info("Kõik vajalikud müügiandmete veerud on olemas.")

    # -----------------------------------------------------
    # sale_date kontroll
    # -----------------------------------------------------

    converted_dates = pd.to_datetime(
        df["sale_date"],
        errors="coerce"
    )

    invalid_dates = converted_dates.isna().sum()

    if invalid_dates > 0:
        logger.warning(
            "sale_date sisaldab %s vigast või puuduvat väärtust.",
            invalid_dates
        )
    else:
        logger.info(
            "sale_date väärtused on sobivas kuupäevavormingus."
        )

    # -----------------------------------------------------
    # total_price kontroll
    # -----------------------------------------------------

    numeric_prices = pd.to_numeric(
        df["total_price"],
        errors="coerce"
    )

    invalid_prices = numeric_prices.isna().sum()

    if invalid_prices > 0:
        logger.warning(
            "total_price sisaldab %s mitte-numbrilist või puuduvat väärtust.",
            invalid_prices
        )
    else:
        logger.info("total_price on numbriline veerg.")

    # Negatiivsete hindade kontroll
    negative_prices = (numeric_prices < 0).sum()

    if negative_prices > 0:
        logger.warning(
            "total_price sisaldab %s negatiivset väärtust.",
            negative_prices
        )
    else:
        logger.info(
            "total_price väärtuste vahemik on mõistlik."
        )

    # -----------------------------------------------------
    # customer_id kontroll
    # -----------------------------------------------------

    missing_customers = df["customer_id"].isna().sum()

    if missing_customers > 0:
        logger.warning(
            "customer_id puudub %s müügireal.",
            missing_customers
        )
    else:
        logger.info(
            "Kõigil müügiridadel on customer_id olemas."
        )

    logger.info(
        "Müügiandmete valideerimine lõpetatud."
    )


# =========================================================
# 2. ANDMETE PUHASTAMINE
# =========================================================

def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    """
    Puhastab DataFrame'i:
    - eemaldab duplikaadid
    - teisendab kuupäevad datetime formaati
    - täidab NULL-väärtused
    """

    logger.info("Alustan clean_data() transformatsiooni.")
    logger.info("Sisendis on %s rida.", len(df))

    df = df.copy()

    # -----------------------------------------------------
    # Duplikaatide eemaldamine
    # -----------------------------------------------------

    duplicates = df.duplicated().sum()

    if duplicates > 0:
        logger.info(
            "Leiti %s duplikaatrida. Eemaldan need.",
            duplicates
        )

        df = df.drop_duplicates()
    else:
        logger.info("Duplikaatridu ei leitud.")

    # -----------------------------------------------------
    # Kuupäevade teisendamine
    # -----------------------------------------------------

    date_columns = [
        "sale_date",
        "registration_date",
        "created_at",
        "date"
    ]

    for column in date_columns:

        if column in df.columns:

            logger.info(
                "Teisendan veeru '%s' datetime formaati.",
                column
            )

            df[column] = pd.to_datetime(
                df[column],
                errors="coerce"
            )

    # -----------------------------------------------------
    # Numbriliste veergude NULL-id
    # -----------------------------------------------------

    numeric_columns = df.select_dtypes(
        include="number"
    ).columns

    for column in numeric_columns:

        null_count = df[column].isna().sum()

        if null_count > 0:

            logger.info(
                "Veerus '%s' asendan %s NULL-väärtust nulliga.",
                column,
                null_count
            )

            df[column] = df[column].fillna(0)

    # -----------------------------------------------------
    # Tekstiveergude NULL-id
    # -----------------------------------------------------

    text_columns = df.select_dtypes(
        include=["object", "string"]
    ).columns

    for column in text_columns:

        null_count = df[column].isna().sum()

        if null_count > 0:

            logger.info(
                "Veerus '%s' asendan %s NULL-väärtust tekstiga 'Unknown'.",
                column,
                null_count
            )

            df[column] = df[column].fillna("Unknown")

    logger.info(
        "clean_data() lõpetatud. Alles jäi %s rida.",
        len(df)
    )

    return df


# =========================================================
# 3. NÄDALASED KOONDNÄITAJAD
# =========================================================

def calculate_weekly_aggregates(
    df: pd.DataFrame
) -> pd.DataFrame:
    """
    Arvutab nädalate kaupa:
    - revenue
    - orders
    - average order value
    """

    logger.info(
        "Alustan calculate_weekly_aggregates() transformatsiooni."
    )

    if df.empty:
        raise ValueError(
            "Nädalaste koondnäitajate arvutamiseks puuduvad andmed."
        )

    required_columns = [
        "sale_date",
        "total_price",
        "sale_id"
    ]

    missing_columns = [
        column
        for column in required_columns
        if column not in df.columns
    ]

    if missing_columns:
        raise ValueError(
            "Nädalaste näitajate jaoks puuduvad veerud: "
            f"{missing_columns}"
        )

    df = df.copy()

    # Kuupäev datetime formaati
    logger.info("Kontrollin sale_date tüüpi.")

    df["sale_date"] = pd.to_datetime(
        df["sale_date"],
        errors="coerce"
    )

    invalid_dates = df["sale_date"].isna().sum()

    if invalid_dates > 0:

        logger.warning(
            "%s rida eemaldatakse vigase sale_date tõttu.",
            invalid_dates
        )

    # Hind numbriliseks
    df["total_price"] = pd.to_numeric(
        df["total_price"],
        errors="coerce"
    ).fillna(0)

    # Vigase kuupäevaga read eemaldatakse
    df = df.dropna(
        subset=["sale_date"]
    )

    logger.info(
        "Arvutan nädalased müüginäitajad %s rea põhjal.",
        len(df)
    )

    # Nädalane grupeerimine
    weekly = (
        df
        .set_index("sale_date")
        .resample("W")
        .agg(
            revenue=("total_price", "sum"),
            orders=("sale_id", "nunique")
        )
        .reset_index()
    )

    # Keskmine tellimuse väärtus
    weekly["avg_order_value"] = (
        weekly["revenue"]
        / weekly["orders"].replace(0, pd.NA)
    )

    logger.info(
        "calculate_weekly_aggregates() lõpetatud. "
        "Loodi %s nädalast koondrida.",
        len(weekly)
    )

    return weekly


# =========================================================
# 4. KPI-DE ARVUTAMINE
# =========================================================

def calculate_kpis(
    df: pd.DataFrame
) -> dict:
    """
    Arvutab kolm põhilist KPI-d:
    - total_revenue
    - unique_customers
    - avg_order_value
    """

    logger.info(
        "Alustan calculate_kpis() transformatsiooni."
    )

    if df.empty:
        raise ValueError(
            "KPI-de arvutamiseks puuduvad andmed."
        )

    required_columns = [
        "total_price",
        "customer_id",
        "sale_id"
    ]

    missing_columns = [
        column
        for column in required_columns
        if column not in df.columns
    ]

    if missing_columns:
        raise ValueError(
            "KPI-de arvutamiseks puuduvad veerud: "
            f"{missing_columns}"
        )

    df = df.copy()

    # Hind numbriliseks
    df["total_price"] = pd.to_numeric(
        df["total_price"],
        errors="coerce"
    ).fillna(0)

    # KPI 1: kogutulu
    total_revenue = df["total_price"].sum()

    # KPI 2: unikaalsed kliendid
    unique_customers = df["customer_id"].nunique()

    # Tellimuste arv
    total_orders = df["sale_id"].nunique()

    # KPI 3: keskmine tellimuse väärtus
    if total_orders > 0:
        avg_order_value = (
            total_revenue / total_orders
        )
    else:
        avg_order_value = 0

    kpis = {
        "total_revenue": total_revenue,
        "unique_customers": unique_customers,
        "avg_order_value": avg_order_value
    }

    logger.info(
        "KPI-d arvutatud: "
        "revenue=%.2f, customers=%s, AOV=%.2f",
        total_revenue,
        unique_customers,
        avg_order_value
    )

    logger.info(
        "calculate_kpis() lõpetatud."
    )

    return kpis


# =========================================================
# 5. ANDMESTIKE LIITMINE
# =========================================================

def merge_datasets(
    df_sales: pd.DataFrame,
    df_customers: pd.DataFrame
) -> pd.DataFrame:
    """
    Liidab müügi- ja kliendiandmed customer_id järgi.
    """

    logger.info(
        "Alustan merge_datasets() transformatsiooni."
    )

    if df_sales.empty:
        raise ValueError(
            "Müügiandmestik on tühi."
        )

    if df_customers.empty:
        raise ValueError(
            "Kliendiandmestik on tühi."
        )

    if "customer_id" not in df_sales.columns:
        raise ValueError(
            "Müügiandmetes puudub customer_id."
        )

    if "customer_id" not in df_customers.columns:
        raise ValueError(
            "Kliendiandmetes puudub customer_id."
        )

    logger.info(
        "Liidan müügi- ja kliendiandmed customer_id järgi."
    )

    merged = pd.merge(
        df_sales,
        df_customers,
        on="customer_id",
        how="left"
    )

    # Kontrollime, kas kõik kliendid leiti
    customer_columns = [
        column
        for column in df_customers.columns
        if column != "customer_id"
    ]

    if customer_columns:

        unmatched = merged[
            customer_columns[0]
        ].isna().sum()

        if unmatched > 0:

            logger.warning(
                "%s müügireale ei leitud vastavat klienti.",
                unmatched
            )

        else:

            logger.info(
                "Kõigile müügiridadele leiti vastav klient."
            )

    logger.info(
        "merge_datasets() lõpetatud. "
        "Tulemuses %s rida.",
        len(merged)
    )

    return merged


# =========================================================
# 6. ROLL C SISENDI ETTEVALMISTAMINE
# =========================================================

def prepare_roll_c_input(
    df_sales: pd.DataFrame,
    df_customers: pd.DataFrame
):
    """
    Valmistab Roll C jaoks vajalikud töödeldud andmed.

    Tagastab:
    - weekly: nädalased koondnäitajad
    - kpis: KPI-d dictionary kujul
    - merged: müügi- ja kliendiandmete ühendatud DataFrame
    """

    logger.info(
        "Alustan Roll C sisendandmete ettevalmistamist."
    )

    # 1. Puhastame müügiandmed
    clean_sales = clean_data(
        df_sales
    )

    # 2. Arvutame nädalased koondnäitajad
    weekly = calculate_weekly_aggregates(
        clean_sales
    )

    # 3. Arvutame KPI-d
    kpis = calculate_kpis(
        clean_sales
    )

    # 4. Liidame müügi- ja kliendiandmed
    merged = merge_datasets(
        clean_sales,
        df_customers
    )

    logger.info(
        "Roll C sisendandmed on valmis."
    )

    return weekly, kpis, merged


# =========================================================
# 7. MAIN
# =========================================================

if __name__ == "__main__":

    logger.info(
        "========== ROLL B START =========="
    )

    # -----------------------------------------------------
    # Roll A: andmete laadimine
    # -----------------------------------------------------

    logger.info(
        "Laen andmed Supabase'ist."
    )

    sales = fetch_sales(
        "2023-01-01",
        "2023-01-31"
    )

    customers = fetch_customers()

    products = fetch_products()

    logger.info(
        "Andmed laaditud: sales=%s, customers=%s, products=%s",
        len(sales),
        len(customers),
        len(products)
    )

    # -----------------------------------------------------
    # Müügiandmete valideerimine
    # -----------------------------------------------------

    validate_sales_data(
        sales
    )

    # -----------------------------------------------------
    # Roll B töötlemine
    # -----------------------------------------------------

    weekly, kpis, merged = prepare_roll_c_input(
        sales,
        customers
    )

    # -----------------------------------------------------
    # Tulemuste kuvamine
    # -----------------------------------------------------

    print("\n===================================")
    print("ROLL C SISEND: NÄDALASED KOONDANDMED")
    print("===================================")

    print(weekly)

    print("\n===================================")
    print("ROLL C SISEND: KPI-D")
    print("===================================")

    print(
        f"Total revenue: {kpis['total_revenue']:.2f}"
    )

    print(
        f"Unique customers: {kpis['unique_customers']}"
    )

    print(
        f"Average order value: "
        f"{kpis['avg_order_value']:.2f}"
    )

    print("\n===================================")
    print("ROLL C SISEND: ÜHENDATUD ANDMED")
    print("===================================")

    print(
        f"Ridade arv: {len(merged)}"
    )

    print(
        merged.head()
    )

    logger.info(
        "========== ROLL B LÕPP =========="
    )

