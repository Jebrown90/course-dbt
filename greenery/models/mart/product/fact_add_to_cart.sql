{{ config (materialized = 'table') }}

select
    e.event_id
    , e.session_id
    , e.page_url
    , e.created_at
    , e.order_id
    , e.product_id
    , u.user_id
    , p.name
    , p.price
from {{ ref('stg_postgres_events') }} e
left join {{ ref('stg_postgres_users') }} u
    on e.user_id = u.user_id
left join {{ ref('stg_postgres_products') }} p
    on e.product_id = p.product_id
left join {{ ref('stg_postgres_promos') }} po
    on e.product_id = p.product_id
where e.event_type = 'add_to_cart'