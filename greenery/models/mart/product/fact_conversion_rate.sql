{{ config (materialized = 'table') }}

select 
    count(distinct case when page_view > 0 then s.session_id end) as page_view
    , count(distinct case when add_to_cart > 0 then s.session_id end) as add_to_cart
    , count(distinct case when checkout > 0 then s.session_id end) as checkout 
from {{ ref('int_sessions_agg')}} s