# e-posti teavituse seadistamine

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
