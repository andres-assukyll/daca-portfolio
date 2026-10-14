# Roll C: Visualization + Saving

import os
from datetime import datetime

import pandas as pd
import plotly.express as px
import plotly.graph_objects as go

from data_fetcher import fetch_sales, fetch_customers
from transform import prepare_roll_c_input


def create_weekly_chart(df_weekly):
    fig = px.line(
        df_weekly,
        x="sale_date",
        y="revenue",
        markers=True,
        title="Nädalane tulu",
        labels={
            "sale_date": "Nädal",
            "revenue": "Tulu (€)"
        }
    )
    return fig


def create_kpi_summary(kpis):
    kpi_names = [
        "Kogutulu",
        "Unikaalsed kliendid",
        "Keskmine tellimuse väärtus"
    ]

    kpi_values = [
        f"{kpis['total_revenue']:.2f} €",
        kpis["unique_customers"],
        f"{kpis['avg_order_value']:.2f} €"
    ]

    table = go.Table(
        header=dict(values=["KPI", "Väärtus"]),
        cells=dict(values=[kpi_names, kpi_values])
    )

    fig = go.Figure(data=[table])
    fig.update_layout(title="Peamised KPI-d")

    return fig


def _get_period_name(start_date=None, end_date=None):
    """
    Tagastab failinimes kasutatava perioodi tähise.

    Kogu periood:
        all

    Näiteks jaanuar 2023:
        2023Jan
    """

    if start_date is None and end_date is None:
        return "all"

    period_start = pd.Timestamp(start_date)

    return period_start.strftime("%Y%b")


def export_results(
    df,
    weekly_fig,
    kpi_fig,
    output_dir,
    start_date=None,
    end_date=None
):
    """
    Salvestab CSV- ja HTML-tulemused.

    Failinime formaat:

        <nimi>_<käivituskuupäev>_<periood>

    Näiteks:

        results_20261007_2023Jan.csv
        weekly_revenue_20261007_2023Jan.html
        kpi_summary_20261007_2023Jan.html

    Kogu perioodi puhul:

        results_20261007_all.csv
    """

    os.makedirs(output_dir, exist_ok=True)

    # Pipeline'i käivitamise kuupäev.
    run_date = datetime.now().strftime("%Y%m%d")

    # Töödeldud periood.
    period_name = _get_period_name(
        start_date=start_date,
        end_date=end_date
    )

    # CSV
    csv_path = os.path.join(
        output_dir,
        f"results_{run_date}_{period_name}.csv"
    )

    df.to_csv(
        csv_path,
        index=False
    )

    # Nädalase tulu HTML
    weekly_html_path = os.path.join(
        output_dir,
        f"weekly_revenue_{run_date}_{period_name}.html"
    )

    # KPI HTML
    kpi_html_path = os.path.join(
        output_dir,
        f"kpi_summary_{run_date}_{period_name}.html"
    )

    weekly_fig.write_html(weekly_html_path)
    kpi_fig.write_html(kpi_html_path)

    return csv_path


if __name__ == "__main__":
    sales = fetch_sales(
        "2023-01-01",
        "2023-01-31"
    )

    customers = fetch_customers()

    weekly, kpis, merged = prepare_roll_c_input(
        sales,
        customers
    )

    weekly_fig = create_weekly_chart(weekly)
    kpi_fig = create_kpi_summary(kpis)

    export_results(
        weekly,
        weekly_fig,
        kpi_fig,
        "output",
        start_date="2023-01-01",
        end_date="2023-01-31"
    )