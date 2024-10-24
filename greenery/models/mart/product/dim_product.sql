{{ config (materialized = 'table') }}

with total_sessions_with_purchase as
(
    select 
        product_id
        , product_name
        , count(distinct(session_id)) as unique_sessions_with_purchase
    from {{ ref('int_sessions_agg')}}
    where order_id is not null
    group by product_id, product_name
)

, total_sessions as
(
    select 
        product_id
        , product_name
        , count(distinct(session_id)) as unique_sessions
    from {{ ref('int_sessions_agg')}} 
    group by product_id, product_name
)

, final as 
(
    select 
        s.product_name
        , s.product_id
        , sum(unique_sessions_with_purchase) as unique_sessions_purchase
        , sum(unique_sessions) as unique_sessions
    from total_sessions s
    left join total_sessions_with_purchase
        on s.product_id = total_sessions_with_purchase.product_id
    group by s.product_name, s.product_id
)

select 
    product_name
    , product_id
    , unique_sessions_purchase
    , unique_sessions
    , unique_sessions_purchase/unique_sessions as conversion_rate
from final