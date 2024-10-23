{{ config (materialized = 'table' )}}

select
    event_session_id
    , event_created_at
    , event_user_id
    , {{event_types('stg_postgres_events', 'event_type')}}

from {{ref = 'stg_postgres_events'}}
group by 1,2,3