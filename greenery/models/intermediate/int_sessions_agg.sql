{{ 
    config( 
        materialized = 'table'
    )
}}

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

select
    event.session_id
    , event.user_id
    , coalesce(event.product_id, order_items.product_id) as product_id
    , coalesce(event.order_id, order_items.order_id) as order_id
    , min(created_at) as session_started_at
    , max(created_at) as session_ended_at
    , sum(case when event_type = 'page_view' then 1 end) as page_view
    , sum(case when event_type = 'add_to_cart' then 1 end) as add_to_cart
    , sum(case when event_type = 'checkout' then 1 end) as checkout
    , sum(case when event_type = 'package_shipped' then 1 end) as package_shipped
from event
left join order_items
    on event.order_id = order_items.order_id
group by 1,2,3,4