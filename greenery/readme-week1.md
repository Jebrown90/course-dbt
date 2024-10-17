# Analytics engineering with dbt - WEEK 1 Answers
# 1. How many users do we have?
130 users

select count(distinct(u.user_id))
from stg_postgres_users

# 2. On average, how many orders do we receive per hour?
On average, we receive 7.52 orders per hour.

with orders_per_hour as
(
select 
    EXTRACT(DAY FROM created_at) as order_day,  
    EXTRACT(HOUR FROM created_at) as order_hour,  
    count(order_id) as total_orders
from stg_postgres_orders
group by order_day,order_hour
)

select 
avg(total_orders)
from orders_per_hour

# 3. On average, how long does an order take from being placed to being delivered?
93.4 hours.

select
AVG(TIMESTAMPDIFF(hour, created_at, delivered_at)) as time_to_delivery
from stg_postgres_orders
where delivered_at is not null


# 4. How many users have only made one purchase? Two purchases? Three+ purchases?
Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.

1 - 25 users
2 - 56 users
3+ - 280 users

with orders_per_user as
(
select
count(distinct(o.order_id)) over (partition by u.user_id) as orders_per_user,
u.user_id
from stg_postgres_users u
left join stg_postgres_orders o
on u.user_id = o.user_id
)
select 
case when orders_per_user = 1 then '1'
    when orders_per_user = 2 then '2'
    when orders_per_user = 3 then '3+'
    when orders_per_user = 4 then '3+'
    when orders_per_user = 5 then '3+'
    when orders_per_user = 6 then '3+'
    when orders_per_user = 7 then '3+'
    when orders_per_user = 8 then '3+'
end as group_order_per_user,
count(user_id)
from orders_per_user
group by group_order_per_user
order by group_order_per_user

# 5. On average, how many unique sessions do we have per hour?
61.26 sessions per hour

with session_hour as
(
select 
    EXTRACT(DAY FROM created_at) as session_day,  
    EXTRACT(HOUR FROM created_at) as session_hour,  
    count(session_id) as total_sessions
from stg_postgres_events
group by session_day,session_hour
)
select avg(total_sessions) from session_hour
