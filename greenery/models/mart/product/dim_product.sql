{{ config (materialized = 'table') }}

select
    p.product_id
    , p.name
    , p.price
    , p.inventory
from {{ ref('stg_postgres_products') }} p