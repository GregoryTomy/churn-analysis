-- inserting metric name and id into metric_name table
insert into
    livebook.metric_name (metric_name_id, metric_name)
values
    (%(new_metric_id)s,%(new_metric_name)s)
    
on conflict do nothing