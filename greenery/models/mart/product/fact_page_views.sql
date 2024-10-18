{{ config (materialized = 'table') }}

with events as
(
    select 
        *
    from {{ ref('stg_postgres_events')}}
)

, order_items as
(
    select 
        *
    from {{ ref('stg_postgres_events')}}
)

, session_timing_agg as 
(
    select
        session_id
        , min(created_at) as session_started_at
        , max(created_at) as session_ended_at
    from from {{ ref('stg_postgres_events')}}
    group by 1
)

select  
    event.sessoin_id
    , event.user_id
    , coalesce(event.product_id, order_item.product_id) as product_id
    , session_started_at
    , session_ended_at
    , sum(case when event.event_type = 'page_view' then 1 else 0 end) as page_views
    , sum(case when event.event_type = 'add_to_cart' then 1 else 0 end) as ad_to_carts,
    , sum(case when event.event_type = 'checkout' then 1 else 0 end) as checkouts,
    , sum(case when event.event_type = 'ppackage_shipped' then 1 else 0 end) as packages_shipped
    , datediff('minute'), session_started_at, session_ended_at) as session_length_minutes

from events
left join order_items 
    on order_items.order_id = event.order_id
left join session_timing_agg s
    on s.session_id = event.session_id
group by 1,2,3,4,5