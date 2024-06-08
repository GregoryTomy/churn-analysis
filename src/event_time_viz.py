"""
Script to pull and visualize the number of events over time
Update event_types in main
"""

from typing import List

import psycopg2
import pandas as pd
import matplotlib.pyplot as plt

plt.style.use("bmh")

db_params = {
    "dbname": "churn",
    "user": "postgres",
    "password": "admin",
    "host": "localhost",
    "port": "5432",
}


def fetch_event_data(event_types: List[str]) -> pd.DataFrame:
    event_types_str = ", ".join(f"'{event}'" for event in event_types)

    sql_query = f"""
     SELECT
        event_type,
        event_time::date AS event_date,
        COUNT(*) AS n_events
    FROM
        livebook.event
    WHERE
        event_type IN ({event_types_str})
    GROUP BY
        event_type, event_date
    ORDER BY
        event_type, event_date;
    """

    connection = psycopg2.connect(**db_params)
    df = pd.read_sql(sql_query, connection)
    connection.close()

    return df


def plot_events(df: pd.DataFrame) -> None:
    event_types = df["event_type"].unique()
    for event_type in event_types:
        df_event = df[df["event_type"] == event_type]
        plt.figure(figsize=(12, 6))
        plt.plot(
            df_event["event_date"],
            df_event["n_events"],
            marker="o",
            linestyle="-",
            label=event_type,
        )
        plt.xlabel("Date")
        plt.ylabel("Number of Events")
        plt.title(f"Events Over Time: {event_type}")
        plt.xticks(rotation=45)
        plt.tight_layout()
        plt.legend()
        plt.savefig(f"images/{event_type}_over_time.png")


if __name__ == "__main__":
    event_types = [
        "ReadingOwnedBook",
        "FirstLivebookAccess",
        "FirstManningAccess",
        "EBookDownloaded",
    ]

    df = fetch_event_data(event_types)

    plot_events(df)
