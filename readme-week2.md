## Part 1. Models
What is our user repeat rate?
(Repeat Rate = Users who purchased 2 or more times)

The repeat user rate is 7.98%. See below for sql I used.

with orders_by_user as
(
    select 
        u.user_id
        , count(distinct(o.order_id)) as order_group
    from stg_postgres_orders o
    left join stg_postgres_users u
        on o.user_id = u.user_id
    group by u.user_id
)

, users_by_order_count as
(
    select
        user_id
        , (order_group = 1)::int as one_order
        , (order_group >= 2)::int as two_plus_orders
    from orders_by_user
)   

select
    sum(one_order) as one_purchase
    , sum(two_plus_orders) as two_plus_purchase
    , count(distinct(user_id)) number_users
    , div0(two_plus_purchase, number_users) as pct_repeat  
from users_by_order_count

## What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?
## NOTE: This is a hypothetical question vs. something we can analyze in our Greenery data set. Think about what exploratory analysis you would do to approach this question.

Good indicators of a user likely to purchase again might include anything from geography to number of times they viewed the page of a specific product. For example, using the SQL below, I showed that website visitors from Texas are the most likely to repeat purchase (of states where more than five people purchased at least once - 25 purchased at least once, 23 were repeat customers).

We might also look at the date of first website view, time to add to cart or checkout, or things of that nature. I would structure any exploratory analysis by each of these theories, and show which groups, when broken down by date of view, or by time to add to cart or checkout, repeat purchased in the highest numbers.

with orders_by_user as
(
    select 
        u.user_id
        , a.state
        , count(distinct(o.order_id)) as order_group
    from stg_postgres_orders o
    left join stg_postgres_users u
        on o.user_id = u.user_id
    left join stg_postgres_addresses a
        on u.address_id = a.address_id
    group by u.user_id, a.state, a.address_id
)

, users_by_order_count as
(
    select
        user_id
        , state
        , (order_group = 1)::int as one_order
        , (order_group >= 2)::int as two_plus_orders
    from orders_by_user
)   

select
    state
    , sum(one_order) as one_purchase
    , sum(two_plus_orders) as two_plus_purchase
    , count(distinct(user_id)) number_users
    , div0(two_plus_purchase, number_users) as pct_repeat  
from users_by_order_count
group by state
order by pct_repeat desc
