"""
This script fetches and plots the metric statistics over time for QA.
"""

import psycopg2
import pandas as pd
import matplotlib.pyplot as plt

DB_PARAMS = {
    "dbname": "churn",
    "user": "postgres",
    "password": "admin",
    "host": "localhost",
    "port": "5432",
}

METRIC_STATS_OVER_TIME_PATH = "scripts_metrics/metric_stats_over_time.sql"


def fetch_query_data_df(sql_file_path: str) -> pd.DataFrame:
    try:
        with open(sql_file_path, "r") as file:
            query_template = file.read()

        with psycopg2.connect(**DB_PARAMS) as connection:
            df = pd.read_sql(query_template, connection)

        return df
    except Exception as e:
        print(f"An error occured whilst executing {sql_file_path}: {e}")


def plot_metrics_over_time(dataframe: pd.DataFrame) -> None:
    plt.style.use("bmh")
    metric_names = dataframe.metric_name.unique()

    for metric_name in metric_names:
        fig, axs = plt.subplots(4, 1, figsize=(10, 20), sharex=True)
        metric_data = dataframe[dataframe.metric_name == metric_name]
        metric_data = metric_data.set_index("metric_time")

        axs[0].plot(metric_data.index, metric_data.avg_metric_value, label=metric_name)
        axs[0].set_title("Average Over Time")
        axs[0].set_ylabel("Avg")

        axs[1].plot(
            metric_data.index, metric_data.count_metric_value, label=metric_name
        )
        axs[1].set_title("Count Over Time")
        axs[1].set_ylabel("Count")

        axs[2].plot(metric_data.index, metric_data.min_metric_value, label=metric_name)
        axs[2].set_title("Min Over Time")
        axs[2].set_ylabel("Min")

        axs[3].plot(metric_data.index, metric_data.max_metric_value, label=metric_name)
        axs[3].set_title("Max Over Time")
        axs[3].set_ylabel("Max")

        for ax in axs:
            ax.legend()
        plt.tight_layout()
        plt.savefig(f"images/metric_over_time_qa/{metric_name}_qa_plot.png")


if __name__ == "__main__":
    df = fetch_query_data_df(METRIC_STATS_OVER_TIME_PATH)
    plot_metrics_over_time(df)
