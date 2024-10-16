{{ config (materialized = 'table') }}

select 
    u.user_id
    , u.first_name
    , u.last_name
    , u.email
    , u.phone_number
    , u.created_at
    , u.updated_at
    , u.address_id
from {{ ref('stg_postgres_users') }} u