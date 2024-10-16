{{ config (materialized = 'table') }}

select
    o.order_id
    , o.promo_id
    , o.created_at
    , o.address_id
    , p.price
    , p.name
    , po.discount
from {{ ref('stg_postgres_orders') }} o
left join {{ ref('stg_postgres_order_items') }} ot
    on o.order_id = ot.order_id
left join {{ ref('stg_postgres_products') }} p
    on ot.product_id = p.product_id
left join {{ ref('stg_postgres_promos') }} po
    on o.promo_id = po.promo_id
left join {{ ref('stg_postgres_users') }} u
    on o.user_id = u.user_id