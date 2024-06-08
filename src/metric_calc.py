import psycopg2
from typing import List

DB_PARAMS = {
    "dbname": "churn",
    "user": "postgres",
    "password": "admin",
    "host": "localhost",
    "port": "5432",
}

INSERT_METRIC_NAME_PATH = "metric_scripts/insert_metric_name.sql"
INSERT_COUNT_METRIC_PATH = "metric_scripts/insert_count_metric.sql"


def execute_query_from_file(sql_file_path: str, params: dict) -> None:
    try:
        with open(sql_file_path, "r") as file:
            query_template = file.read()

        connection = psycopg2.connect(**DB_PARAMS)
        cursor = connection.cursor()

        cursor.execute(query_template, params)
        connection.commit()
        cursor.close()
        connection.close()
        print("Query executed successfully.")
    except Exception as e:
        print(f"An error occured whilst executing {sql_file_path}: {e}")


def caculate_metrics(events: List[str]) -> None:
    for idx, event in enumerate(events):
        params = {
            "new_metric_id": idx,
            "new_metric_name": f"{event}_90D",
            "event2measure": event,
        }
        execute_query_from_file(INSERT_METRIC_NAME_PATH, params)
        execute_query_from_file(INSERT_COUNT_METRIC_PATH, params)


if __name__ == "__main__":
    events = [
        "ReadingOwnedBook",
        "EBookDownloaded",
        "ReadingFreePreview",
        "HighlightCreated",
        "FreeContentCheckout",
        "ReadingOpenChapter",
        "WishlistItemAdded",
        "CrossReferenceTermOpened",
    ]

    caculate_metrics(events)
    print(f"Completed metric calculation and insertion")
