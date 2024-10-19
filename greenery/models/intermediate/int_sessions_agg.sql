{{ config (materialized = 'table' )}}

with event as
(
    select 
        *
    from {{ ref('stg_postgres_events')}}
)

, order_items as
(
    select 
        *
    from {{ ref('stg_postgres_order_items')}} 
)

, session_timing_agg as 
(
    select
        event.user_id
        , event.session_id
        , coalesce(event.order_id, order_items.order_id) as order_id
        , coalesce(event.product_id, order_items.product_id) as product_id
        , min(created_at) as session_started_at
        , max(created_at) as session_ended_at
        , sum(case when event.event_type = 'page_view' then 1 else 0 end) as page_views
        , sum(case when event.event_type = 'add_to_cart' then 1 else 0 end) as add_to_carts
        , sum(case when event.event_type = 'checkout' then 1 else 0 end) as checkouts
        , sum(case when event.event_type = 'package_shipped' then 1 else 0 end) as packages_shipped
    from event
    left join order_items
        on event.order_id = order_items.order_id
    group by 1,2,3,4
)

select
    session_id
    , user_id
    , product_id
    , order_id
    , session_started_at
    , session_ended_at
    , page_views
    , add_to_carts
    , checkouts
    , packages_shipped
from session_timing_agg
qualify row_number() over (partition by session_id order by session_started_at) = 1