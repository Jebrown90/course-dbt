{{ config (materialized = 'table') }}

select  
    s.session_id
    , s.user_id
    , s.order_id
    , s.product_id
    , s.session_started_at
    , s.session_ended_at
    , datediff('minute', s.session_started_at, s.session_ended_at) as session_length_minutes
    , page_view
    , add_to_cart
    , checkout
    , package_shipped
    , u.created_at as account_created_date
    , a.address
    , a.zipcode
    , a.state
    , a.country
    , p.name as product_name
    , p.price as product_price

from {{ ref('int_sessions_agg')}} s
left join {{ ref('stg_postgres_products')}} p
    on s.product_id = p.product_id
left join {{ ref('stg_postgres_users')}} u
    on s.user_id = u.user_id
left join {{ ref('stg_postgres_addresses')}} a
    on u.address_id = a.address_id