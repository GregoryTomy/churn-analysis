create table if not exists livebook.metric_name (
    metric_name_id integer not null,
    metric_name text collate pg_catalog."default"
)
with
    (oids=false) tablespace pg_default;

alter table livebook.metric_name owner to postgres;

create unique index if not exists idx_metric_name_id on livebook.metric_name using btree (metric_name_id) tablespace pg_default;

create unique index if not exists idx_metric_name_name on livebook.metric_name using btree (metric_name) tablespace pg_default;