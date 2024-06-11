select
    m.metric_time         as metric_time,
    mn.metric_name        as metric_name,
    avg(m.metric_value)   as avg_metric_value,
    count(m.metric_value) as count_metric_value,
    min(m.metric_value)   as min_metric_value,
    max(m.metric_value)   as max_metric_value
from
    livebook.metric as m
    join livebook.metric_name as mn on m.metric_name_id=mn.metric_name_id
group by
    mn.metric_name,
    m.metric_time
order by
    mn.metric_name,
    m.metric_time