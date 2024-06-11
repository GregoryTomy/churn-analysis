-- Note we get the same values as net retention as in this case
-- all users pay one subscription amount.
with
    date_range as (
        SELECT
            '2020-03-01'::date as start_date,
            '2020-04-01'::date as end_date
        from
            socialnet7.subscription
        limit
            1
    ),
    start_accounts as (
        select distinct
            account_id
        from
            socialnet7.subscription as s
            inner join date_range as d on s.start_date <= d.start_date
            and (
                s.end_date > d.start_date
                or s.end_date is null
            )
    ),
    end_accounts as (
        select distinct
            account_id
        from
            socialnet7.subscription as s
            inner join date_range as d on s.start_date <= d.end_date
            and (
                s.end_date > d.end_date
                or s.end_date is null
            )
    ),
    churned_accounts as (
        select
            s.account_id
        from
            start_accounts as s
            left outer join end_accounts as e on s.account_id = e.account_id
        where
            e.account_id is null
    ),
    start_count as (
        select
            count(*) as n_start
        from
            start_accounts
    ),
    churn_count as (
        select
            count(*) as n_churn
        from
            churned_accounts
    )
select
    n_churn::float / n_start::float as churn_rate,
    1.0 - (n_churn::float / n_start::float) as retention_rate,
    n_start,
    n_churn
from start_count, churn_count