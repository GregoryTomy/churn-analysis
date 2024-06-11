-- Create table to hold basic customer metrics
create table if not exists
    livebook.metric (
        account_id character(32) collate pg_catalog."default",
        metric_time timestamp(6) without time zone not null,
        metric_name_id integer not null,
        metric_value real
    )
with
    (oids=false) tablespace pg_default;

alter table livebook.metric owner to postgres;

create index if not exists idx_metric_account_id on livebook.metric using btree (account_id) tablespace pg_default;

create index if not exists idx_metric_account_time on livebook.metric using btree (account_id, metric_name_id, metric_time) tablespace pg_default;

create index if not exists idx_metric_time on livebook.metric using btree (metric_time, metric_name_id) tablespace pg_default;

create index if not exists idx_metric_type on livebook.metric using btree (metric_name_id) tablespace pg_default;