with
    date_range as (
        select
            '2020-03-01'::timestamp as start_date,
            '2020-04-01'::timestamp as end_date,
            interval '1 months' as inactivity_offset
        from
            socialnet7.event
        limit
            1
    ),
    start_accounts as (
        select distinct
            account_id
        from
            socialnet7.event as e
            inner join date_range as d on e.event_time > (d.start_date - d.inactivity_offset)
            and e.event_time <= d.start_date
    ),
    start_count as (
        select
            count(*) as n_start
        from
            start_accounts
    ),
    end_accounts as (
        select distinct
            account_id
        from
            socialnet7.event as e
            inner join date_range as d on e.event_time > (d.end_date - d.inactivity_offset)
            and e.event_time <= d.end_date
    ),
    churned_accounts as (
        select distinct
            s.account_id
        from
            start_accounts as s
            left outer join end_accounts as e on s.account_id = e.account_id
        where
            e.account_id is null
    ),
    churn_count as (
        select
            count(*) as n_churn
        from
            churned_accounts
    )
select
    n_churn::float / n_start::float as churn_rate,
    1 - (n_churn::float / n_start::float) as retention_rate,
    n_churn,
    n_start
from churn_count, start_count
