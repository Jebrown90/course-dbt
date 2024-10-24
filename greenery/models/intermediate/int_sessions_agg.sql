{{ 
    config( 
        materialized = 'table'
    )
}}

{%- set events = ['page_views', 'add_to_carts', 'checkouts', 'packages_shipped']%}

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

, products as
(
    select 
        *
    from {{ ref('stg_postgres_products')}} 
)

, session_timing_agg as 
(
    select
        event.user_id
        , event.session_id
        , coalesce(event.order_id, order_items.order_id) as order_id
        , coalesce(event.product_id, order_items.product_id) as product_id
        , products.name as product_name
        , min(created_at) as session_started_at
        , max(created_at) as session_ended_at
        {%- for event in events %}
        , sum(case when event_type = '{{ event }}' then 1 else 0 end) as {{ event }}
        {%- endfor %}
    from event
    left join order_items
        on event.order_id = order_items.order_id
    left join products
        on event.product_id = products.product_id
        or order_items.product_id = products.product_id
    group by 1,2,3,4,5
)

select
    session_id
    , user_id
    , product_id
    , product_name
    , order_id
    , session_started_at
    , session_ended_at
    , page_views
    , add_to_carts
    , checkouts
    , packages_shipped
from session_timing_agg