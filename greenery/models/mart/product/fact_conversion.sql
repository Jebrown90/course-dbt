{{ config (materialized = 'table') }}

with total_sessions as
(
    select 
        count(distinct(s.session_id)) as total_unique_sessions
    from {{ ref('int_sessions_agg')}} s
)

with
    select
        count(distinct(s.session_id)) as unique_sessions_with_purchase
        , count(distinct(s.order_id)) as unique_purchases
    from {{ ref('int_sessions_agg')}} s
    left join 
    where s.order_id is not null

select 
*
from total_sessions