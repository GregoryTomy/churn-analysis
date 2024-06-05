-- aggregation to get an overview of events in the database
-- Details:
-- events span from 2019-11-29 to 2020-06-04
-- `ebookdownloaded` and `livebooklogin` are the most most common events
-- firstlivebookaccess, sherlockholmescluefound, commentcreated, firstmanningaccess
-- are least common with only 1 event each.
with
    account_counts as (
        select
            count(distinct account_id) as n_account
        from
            livebook.event
    ),
    date_range as (
        select
            min(event_time::timestamp) as start_date,
            max(event_time::timestamp) as end_date
        from
            livebook.event
    )
select
    e.event_type,
    count(*)                         as n_event,
    n_account                        as n_account,
    count(*)::float/n_account::float as events_per_account,
    extract(
        days
        from
            (end_date-start_date)
    )::float/28 as n_months,
    (count(*)::float/n_account::float)/(
        extract(
            days
            from
                (end_date-start_date)
        )::float/28.0
    ) as events_per_account_per_month
from
    livebook.event as e
    cross join account_counts,
    date_range
group by
    e.event_type,
    n_account,
    end_date,
    start_date
order by
    events_per_account_per_month desc;