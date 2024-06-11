-- this query provides detailed statistics for each metric_name within a specified date range.
-- including count, perctage of accounts with each metric, as well as the average, minimum and 
-- maximum of that metric. And the earliest and latest the metric was recorded.
with
    date_range as (
        select
            '2020-02-22'::timestamp as start_date,
            '2020-06-04'::timestamp as end_date
    ),
    account_count as (
        select
            count(distinct account_id) as n_account
        from
            livebook.event as e
            inner join date_range as d on e.event_time between d.start_date and d.end_date
    )
select
    mn.metric_name,
    count(distinct m.account_id) as count_with_metric, -- accounts with this metric
    n_account as n_account,
    count(distinct m.account_id)::float/n_account::float as pct_with_metric, -- percentage of accounts that have this meteric
    avg(metric_value) as avg_value,
    min(metric_value) as min_value,
    max(metric_value) as max_value,
    min(metric_time) as earliest_metric,
    max(metric_time) as latest_metric
from
    livebook.metric as m
    cross join account_count
    -- inner join date_range as d on m.metric_time between d.start_date and d.end_date
    inner join date_range on metric_time>=start_date
    and metric_time<=end_date
    join livebook.metric_name as mn on m.metric_name_id=mn.metric_name_id
group by
    mn.metric_name,
    n_account
order by
    count_with_metric desc