{{ config (materialized = 'table') }}

select 
    s.session_id
    , p.name as product_name
    , a.state
    , u.created_at as account_created_date
    , session_ended_at
    , session_started_at
    , case when page_view > 0 then s.session_id end as page_view_session_id
    , case when add_to_cart > 0 then s.session_id end as add_to_cart_session_id
    , case when checkout > 0 then s.session_id end as checkout_session_id
from {{ ref('int_sessions_agg')}} s
left join {{ ref('stg_postgres_products')}} p
    on s.product_id = p.product_id
left join {{ ref('stg_postgres_users')}} u
    on s.user_id = u.user_id
left join {{ ref('stg_postgres_addresses')}} a
    on u.address_id = a.address_id