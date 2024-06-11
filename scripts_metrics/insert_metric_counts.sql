-- Query inserts data into `metric` table by aggregating event counts over 
-- the time range, grouped by account and metric date, with a 90 day lookback period.
-- Date ranges are selected based on EDA that showed a cylical pattern where people 
-- are reading Manning books on the weekdays. So we time measurements to pickup a full
-- week each time. 
-- note this script is to be run dynamically in metric_calc.py
with
    -- generate a series of 7 day intervals
    date_intervals as (
        select
            generate_series(
                '2020-02-22'::timestamp,
                '2020-06-04'::timestamp,
                '7 day'::interval
            ) as metric_date
    )
insert into
    livebook.metric (
        account_id,
        metric_time,
        metric_name_id,
        metric_value
    )
select
    e.account_id,
    date_intervals.metric_date,
%(new_metric_id)s,
    count(*)                   as metric_value
from
    livebook.event as e
    inner join date_intervals on e.event_time<date_intervals.metric_date
    and e.event_time>=date_intervals.metric_date-(interval '90 day')
where
    e.event_type=%(event2measure)s
group by
    e.account_id,
    date_intervals.metric_date on conflict
do nothing;