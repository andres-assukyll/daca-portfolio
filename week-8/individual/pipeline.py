# UrbanStyle Pipeline
# Roll A + B + C + D

import argparse
from datetime import datetime
from pathlib import Path

from data_fetcher import fetch_sales, fetch_customers
from transform import (
    validate_sales_data,
    prepare_roll_c_input,
)
from visualize_export import (
    create_weekly_chart,
    create_kpi_summary,
    export_results,
)
from notification import send_status_notification


BASE_DIR = Path(__file__).resolve().parent
OUTPUT_DIR = BASE_DIR / "output"


def parse_period(period_text):
    """
    Parsib perioodi kujul:

        YYYY-MM-DD:YYYY-MM-DD

    Näiteks:

        2023-01-01:2023-01-31
    """

    try:
        start_text, end_text = period_text.split(":", 1)

        start_date = datetime.strptime(
            start_text,
            "%Y-%m-%d"
        ).date()

        end_date = datetime.strptime(
            end_text,
            "%Y-%m-%d"
        ).date()

    except ValueError as error:
        raise ValueError(
            "Vigane perioodi formaat. "
            "Kasuta kujul YYYY-MM-DD:YYYY-MM-DD."
        ) from error

    if start_date > end_date:
        raise ValueError(
            f"Perioodi algus ({start_date}) ei saa olla "
            f"hilisem kui lõpp ({end_date})."
        )

    return start_date, end_date


def get_output_directory(start_date=None, end_date=None):
    """
    Tagastab perioodi väljundkausta.

    Kogu periood:
        output/all

    Konkreetne periood:
        output/YYYY-MM-DD_YYYY-MM-DD
    """

    if start_date is None and end_date is None:
        return OUTPUT_DIR / "all"

    return OUTPUT_DIR / f"{start_date}_{end_date}"


def get_display_output_path(output_dir):
    """
    Teeb logi jaoks absoluutse väljundkausta suhteliseks.

    Näiteks:
        /output/2023-01-01_2023-01-31
    """

    try:
        relative_path = output_dir.relative_to(BASE_DIR)

        return "/" + relative_path.as_posix()

    except ValueError:
        return output_dir.as_posix()


def extract_data(start_date=None, end_date=None):
    """
    Extract etapp.

    Kui kuupäevi ei anta, võetakse kogu müügiandmestik.
    """

    sales = fetch_sales(
        start_date=start_date,
        end_date=end_date
    )

    customers = fetch_customers()

    return sales, customers


def transform_data(sales, customers):
    """
    Transform etapp.

    Kasutab olemasolevaid transform.py funktsioone.
    """

    validate_sales_data(sales)

    weekly, kpis, merged = prepare_roll_c_input(
        sales,
        customers
    )

    return {
        "weekly": weekly,
        "kpis": kpis,
        "merged": merged,
    }


def export_data(
    transformed_data,
    output_dir,
    start_date=None,
    end_date=None
):
    """
    Export etapp.

    Loob graafikud ja salvestab CSV/HTML failid.
    """

    weekly = transformed_data["weekly"]
    kpis = transformed_data["kpis"]

    weekly_fig = create_weekly_chart(weekly)
    kpi_fig = create_kpi_summary(kpis)

    csv_path = export_results(
        weekly,
        weekly_fig,
        kpi_fig,
        str(output_dir),
        start_date=start_date,
        end_date=end_date,
    )

    return csv_path


def run_period(start_date=None, end_date=None):
    """
    Käivitab pipeline'i ühe perioodi kohta.
    """

    period_label = (
        "kogu periood"
        if start_date is None and end_date is None
        else f"{start_date} – {end_date}"
    )

    print()
    print("=" * 60)
    print(f"Pipeline: {period_label}")
    print("=" * 60)

    # -------------------------
    # EXTRACT
    # -------------------------

    print("\n[1/3] Extract")

    sales, customers = extract_data(
        start_date=start_date,
        end_date=end_date
    )

    print(f"Müüke: {len(sales)}")
    print(f"Kliente: {len(customers)}")

    # -------------------------
    # TRANSFORM
    # -------------------------

    print("\n[2/3] Transform")

    transformed = transform_data(
        sales,
        customers
    )

    kpis = transformed["kpis"]

    print(
        f"Kogutulu: €{kpis['total_revenue']:,.2f}"
    )

    print(
        f"Unikaalseid kliente: "
        f"{kpis['unique_customers']:,}"
    )

    print(
        f"Keskmine tellimuse väärtus: "
        f"€{kpis['avg_order_value']:,.2f}"
    )

    # -------------------------
    # EXPORT
    # -------------------------

    print("\n[3/3] Export")

    output_dir = get_output_directory(
        start_date=start_date,
        end_date=end_date
    )

    csv_path = export_data(
        transformed,
        output_dir,
        start_date=start_date,
        end_date=end_date,
    )

    output_display = get_display_output_path(
        output_dir
    )

    print(f"Output: {output_display}")
    print(f"CSV: {Path(csv_path).name}")

    return {
        "success": True,
        "start_date": start_date,
        "end_date": end_date,
        "kpis": kpis,
        "output_dir": output_dir,
        "output_display": output_display,
        "csv_path": csv_path,
    }


def parse_arguments():
    """
    Loeb käsurea argumendid.

    Näiteks:

        python3 pipeline.py

    või:

        python3 pipeline.py \
            --period 2023-01-01:2023-01-31 \
            --period 2023-03-01:2023-03-31
    """

    parser = argparse.ArgumentParser(
        description="UrbanStyle ETL pipeline"
    )

    parser.add_argument(
        "--period",
        action="append",
        help=(
            "Töödeldav periood kujul "
            "YYYY-MM-DD:YYYY-MM-DD. "
            "Argumenti võib kasutada mitu korda."
        ),
    )

    return parser.parse_args()


def get_periods(args):
    """
    Tagastab töödeldavad perioodid.

    Kui --period puudub, töödeldakse kogu saadaolevat perioodi.
    """

    if not args.period:
        return [(None, None)]

    periods = []

    for period_text in args.period:
        periods.append(
            parse_period(period_text)
        )

    return periods


def build_notification_message(results):
    """
    Koostab ühe e-kirja sisu kogu pipeline'i käivituse kohta.
    """

    lines = [
        "UrbanStyle pipeline tulemused",
        ""
    ]

    for result in results:
        lines.append("━━━━━━━━━━━━━━━━━━━━")

        start_date = result["start_date"]
        end_date = result["end_date"]

        if start_date is None and end_date is None:
            lines.append("📅 Kogu saadaolev periood")
        else:
            lines.append(
                f"📅 {start_date} – {end_date}"
            )

        if result["success"]:
            kpis = result["kpis"]

            lines.extend([
                "",
                f"💰 Kogutulu: "
                f"€{kpis['total_revenue']:,.2f}",
                f"👥 Unikaalsed kliendid: "
                f"{kpis['unique_customers']:,}",
                f"🛒 Keskmine tellimuse väärtus: "
                f"€{kpis['avg_order_value']:,.2f}",
                "",
                f"📁 Tulemused: "
                f"{result['output_display']}",
            ])

        else:
            lines.extend([
                "",
                f"❌ Viga: {result['error']}",
            ])

    lines.append("━━━━━━━━━━━━━━━━━━━━")

    return "\n".join(lines)


def main():
    args = parse_arguments()

    try:
        periods = get_periods(args)

    except ValueError as error:
        print(f"VIGA: {error}")

        send_status_notification(
            status="FAILURE",
            stage="Pipeline",
            message_text=str(error),
        )

        return 1

    results = []

    for start_date, end_date in periods:
        try:
            result = run_period(
                start_date=start_date,
                end_date=end_date
            )

            results.append(result)

        except Exception as error:
            period_label = (
                "kogu periood"
                if start_date is None and end_date is None
                else f"{start_date} – {end_date}"
            )

            print()
            print(f"VIGA perioodil {period_label}: {error}")

            results.append({
                "success": False,
                "start_date": start_date,
                "end_date": end_date,
                "error": (
                    f"{type(error).__name__}: {error}"
                ),
            })

    successful = [
        result
        for result in results
        if result["success"]
    ]

    failed = [
        result
        for result in results
        if not result["success"]
    ]

    # -------------------------
    # PIPELINE STATUS
    # -------------------------

    if failed and successful:
        status = "WARNING"

    elif failed:
        status = "FAILURE"

    else:
        status = "SUCCESS"

    notification_message = build_notification_message(
        results
    )

    # Täpselt üks e-kiri kogu pipeline'i käivituse kohta.
    try:
        send_status_notification(
            status=status,
            stage="Pipeline",
            message_text=notification_message,
        )

        print("\nE-posti teavitus saadetud.")

    except Exception as error:
        print(
            f"\nHOIATUS: e-posti teavituse saatmine "
            f"ebaõnnestus: {error}"
        )

        # E-posti vea tõttu ei muudeta juba edukalt
        # lõppenud ETL pipeline'i staatust.
        if status == "SUCCESS":
            status = "WARNING"

    print()
    print("=" * 60)
    print(f"Pipeline lõppes staatusega: {status}")
    print("=" * 60)

    if status == "FAILURE":
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())