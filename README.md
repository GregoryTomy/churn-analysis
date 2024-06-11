# Churn Analysis

## Business Problem
Our task is to analyze customer behavior on Manning’s liveBook website to understand the factors that influence customer retention and churn. The goal is to determine what encourages customers to return to the website regularly and identify the reasons why some customers stop visiting. By gaining insights into these patterns, we aim to develop strategies to enhance customer engagement and reduce churn, ultimately improving the overall customer experience and business performance.

### Project breakdown:
1. Clean and process customer behavior data for churn analysis.
2. Analyze customer metrics to uncover patterns and behavior that indicate customer churn.
3. Developed machine learning models to predict customer churn.

## Data
The raw data consists of event recordcs dumped into a CSV file.

| account_id                          | event_time              | event_type                      | product_id | additional_data                                         |
|-------------------------------------|-------------------------|---------------------------------|------------|---------------------------------------------------------|
| 608aa5969cef2edc29cb0c46deaec9da    | 2019-11-29 12:10:08.154 | DashboardLivebookLinkOpened     | 1156       | /book/learn-dbatools-in-a-month-of-lunches              |
| d07263602248aa70ce1967d6f98f9506    | 2019-11-29 12:10:19.962 | ReadingOwnedBook                | 610        | 60s                                                     |
| b7d5902d66127909d0f9d766a841ebb5    | 2019-11-29 12:11:20.707 | ReadingOwnedBook                | 1172       | 480s                                                    |
| d07263602248aa70ce1967d6f98f9506    | 2019-11-29 12:11:41.283 | ProductTocLivebookLinkOpened    | 1066       | /book/grokking-machine-learning/chapter-1               |
| 89f7601cb558e1c47b00a7fabb6a466c    | 2019-11-29 12:11:58.253 | ReadingOwnedBook                | 1073       | 960s                                                    |


## Data processing

#### Snapshot of most popular events
| event_type            | n_event | n_account | events_per_account | n_months | events_per_account_per_month |
|-----------------------|---------|-----------|---------------------|----------|------------------------------|
| ReadingOwnedBook      | 748,260 | 89,467    | 8.364               | 6.679    | 1.252                        |
| FirstLivebookAccess   | 658,226 | 89,467    | 7.357               | 6.679    | 1.102                        |
| FirstManningAccess    | 657,340 | 89,467    | 7.347               | 6.679    | 1.100                        |
| EBookDownloaded       | 277,356 | 89,467    | 3.100               | 6.679    | 0.464                        |
| ReadingFreePreview    | 138,197 | 89,467    | 1.545               | 6.679    | 0.231                        |

Created metric tables and calculated summary metrics for customers.

#### Example of an event over time.
![](images/EBookDownloaded_over_time.png)

FirstLiveBookAccess and FirstManningAccess only start appearinf in Feb 2020 unlike other events that start in Dec 2019

### Metric Data
#### Count of events over time.
- aggregated event counts with a 90 day look nack period. Date ranges were selected based on EDA that showed cylical pattern where people are reading Manning books on the weekdays. Measurements times to pickup a full week each period. 