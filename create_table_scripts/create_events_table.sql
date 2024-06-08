-- create the event table to which we will load the data
create table if not exists
    livebook.event (
        account_id character(32),
        event_time timestamp(6) without time zone NOT NULL,
        event_type text collate pg_catalog."default",
        product_id integer,
        additional_data text collate pg_catalog."default"
    )
with
    (OIDS = FALSE) tablespace pg_default;

alter table livebook.event owner to postgres;

create index if not exists idx_event_account_id on livebook.event using btree (account_id) tablespace pg_default;

create index if not exists idx_event_account_time on livebook.event using btree (account_id, event_time) tablespace pg_default;

create index if not exists idx_event_time on livebook.event using btree (event_time) tablespace pg_default;

create index if not exists idx_event_type on livebook.event using btree (event_type) tablespace pg_default;

create index if not exists idx_product_id on livebook.event using btree (product_id) tablespace pg_default;