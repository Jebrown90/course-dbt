## Part 1. Models
QUESTION 1: What is our user repeat rate?
(Repeat Rate = Users who purchased 2 or more times)

The repeat user rate is 7.98%. See below for sql I used to get this output.

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



QUESTION 2. What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?
NOTE: This is a hypothetical question vs. something we can analyze in our Greenery data set. Think about what exploratory analysis you would do to approach this question.

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


QUESTION 3. Explain the product mart models you added. Why did you organize the models in the way you did?

I added one model to the product mart called fact_user_sessions, but I included a separate "intermediate" schema to aggregate events by session. the primary reason for this is that a bunch of different types of fact and dimension models could use / build on this, and it allows us to view a series of actions through the product funnel (from landing on a page and starting a session all the way to placing an order and having it delivered) which should be particularly useful later in this course, when we will show how our users moving through the product funnel and which points in the funnel have largest drop off points.

The fact_user_sessions model, however, is useful this week to answer the type of questions required for the product mart (taken from the week 2 assignment), namely:

How do different products perform? 
Can be answered by querying performance metrics (views, adds to carts, etc) and grouping by product name.

What are daily page views by product? 
Same as above, but select only page views, grouping by product name and date of view.

Daily orders by product? Same as above, but grouping by order_created_date.

What’s getting a lot of traffic, but maybe not converting into purchases? Select count of traffic and count of order_ids by product name (and potentially cohorted by date of view (session_created_date) or of order).


QUESTION 4. Use the dbt docs to visualize your model DAGs to ensure the model layers make sense

See the file titled dbt-dag.png! 




## Part 2. Tests

QUESTION 1: We added some more models and transformed some data! Now we need to make sure they’re accurately reflecting the data. Add dbt tests into your dbt project on your existing models from Week 1, and new models from the section above.

1.a. What assumptions are you making about each model? (i.e. why are you adding each test?)
1.b. Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
1.c. Apply these changes to your github repo

I answer 1.a. and 1.b. below together, and already applied the changed in the repo.

int_sessions_agg: 
    - Session_id: I made an assumption that session_id would be not null and unique (which it should be if we've aggregated everything by session_id), but it was not unique. It's unclear why duplicates exist - it could be a tech output issue - but to remove that issue, I qualified the whole data set so we would only see the earliest output for a given session_id
    - Product_id: this should always be populated, since people have events happen in a session for a given product, but sometimes this didn't populate - many nulls existed for those sessions where an order took place, whcih made me think that order_items was the correct place to look for this id. To reduce the nulls for sessions where an order took place, I used coalesce to bring in product_id from order_items.
    - User_id: assumed not_null, ran correctly on the first try.

fact_user_sessions: I put non null and unique tests for session_id and product_id/user_id both have not_null tests, for the same reasoning as in the int model. They all passed once I implemented the qualify and coalesce in the int table.

I added uniqueness tests to every unique id in the postgres staging models to check those as well, and added not null to any ids where it would be expected the id would always populate, so we will know right away if incorrect data is coming through from the source.



QUESTION 2: Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

I would set up alerting in slack that would automatically tell me when a check failed right after the data warehouse updated. I would also set up a slack channel of stakeholders who I would then notify of the failure if it occured, and of the fix when implemented.



## Part 3. dbt Snapshots

QUESTION 1: Which products had their inventory change from week 1 to week 2? 

I ran the snapshot (dbt snapshot) and then ran the SQL script below in Snowflake. 

select 
    s.*, 
    p.name 
from inventory_snapshot s
left join stg_postgres_products p
    on s.product_id = p.product_id
order by product_id

Any product that appears twice (and has a change in DBT_VALID_FROM date) had a change in inventory. Those were:

1. Pothos - decreased from 40 to 20
2. Philodendron - decreased from 51 to 25
3. Monstera - decreased from 77 to 64
4. String of Pearls - decreased from 58 to 10