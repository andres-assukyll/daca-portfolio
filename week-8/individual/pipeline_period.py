# perioodi valiku seadistus

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
