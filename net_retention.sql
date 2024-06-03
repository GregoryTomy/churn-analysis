-- date range is between Jan 2020 and first day of June
-- only one MRR of 10
with
    -- get the churn measurement date range 
    date_range as (
        select
            '2020-03-01'::date as start_date,
            '2020-04-01'::date as end_date
        from
            socialnet7.subscription
        limit 1
    ),
    -- aggregate MRR, all users active at the beginning of the date range
    -- ensure end date is after start date or the user is still active 
    start_accounts as (
        select
            account_id,
            sum(mrr) as total_mrr
        from
            socialnet7.subscription as s
            inner join date_range as d on s.start_date <= d.start_date
            and (
                s.end_date > d.start_date
                or s.end_date is null
            )
        group by
            account_id
    ),
    -- accounts active at the end of the measurement range
    end_accounts as (
        select
            account_id,
            sum(mrr) as total_mrr
        from
            socialnet7.subscription as s
            inner join date_range as d on s.start_date <= d.end_date
            and (
                s.end_date > d.end_date
                or s.end_date is null
            )
        group by
            account_id
    ),
    -- identify retained accounts i.e. active at the start and end
    retained_accounts as (
        select
            s.account_id,
            sum(e.total_mrr) as total_mrr
        from
            start_accounts as s
            inner join end_accounts as e on s.account_id = e.account_id
        group by
            s.account_id
    ),
    start_mrr as (
        select
            sum(start_accounts.total_mrr) as start_mrr
        from
            start_accounts
    ),
    retained_mrr as (
        select
            sum(retained_accounts.total_mrr) as retained_mrr
        from
            retained_accounts
    )
select
    retained_mrr / start_mrr as net_mrr_retention_rate,
    1 - (retained_mrr / start_mrr) as net_mrr_churn_rate,
    start_mrr,
    retained_mrr
from
    start_mrr,
    retained_mrr