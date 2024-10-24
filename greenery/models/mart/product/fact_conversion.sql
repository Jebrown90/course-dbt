{{ config (materialized = 'table') }}

with total_sessions as
(
    select 
        count(distinct(s.session_id)) as unique_sessions_with_purchase
    where s.order_id is not null
)

select 
    product_name
    , sum(page_views) as total_views
    , total_purchases
    , conversion_rate
from {{ ref('int_sessions_agg')}} s
left join xx
    on s.product_id = orders.product_id
group by 1