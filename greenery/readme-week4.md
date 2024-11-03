## Part 1. dbt Snapshots. Let's update our products snapshot one last time to see how our data is changing: Run the products snapshot model using dbt snapshot and query it in snowflake to see how the data has changed since last week.  

## Which products had their inventory change from week 3 to week 4? 

Six products had their inventory change from week 3 to week 4 - Pothos, Philodendron, Bamboo, ZZ Plant, Monstera, and String of Pearls.

## Now that we have 3 weeks of snapshot data, can you use the inventory changes to determine which products had the most fluctuations in inventory? Did we have any items go out of stock in the last 3 weeks? 

The above six products had the most fluctuation in inventory. The remaining plants saw no change from week to week (maybe this indicates the flower store should stop or minimize stocking of those!). Pothos and String of Pearls went out of stock and then were re-stocked in week 4 (back to 20 and 10 units, respectively). Philodendron was also re-stocked between week 3 and 4 (from 15 to 30 units) but never actually went out of stock.





## Part 2. Modeling challenge. Let’s say that the Director of Product at greenery comes to us (the head Analytics Engineer) and asks some questions: How are our users moving through the product funnel? Which steps in the funnel have largest drop off points?

We’ll also want to make sure that any model feeding into this report is defined in an exposure (which we’ll cover in this week’s materials)

Use an exposure on your product analytics model to represent that this is being used in downstream BI tools. Please reference the course content if you have questions.

ANSWER:

To answer the questions from the Director of Product above, I created a model called fact_conversion_rate. This model shows session_id, product_name, state and session_started_at, and adds in session_id in additional columns for each level of the product funnel - "page views", "add to carts" and "checkouts" - where that action took place for a given session. Count distincts of session_ids in these product funnel action columns can then be used to create conversion rates within the BI tool, which can then be shown in bar charts broken down by the dimensions I named above or by type of conversion to see where the largest percentage of users "fall off", or it can be used to create the funnel visual that Jake showed during the walk-through.

At the same time, because the model also includes timestamps like account_created_date, session_started_at and session_ended_at, I could also create an over time view of conversion, allowing users to show the conversion rate they're most interested in over time, cohorted by timestamp of interest to them. That being said, the answers to the specific questions the Director of Product asked are below, and the SQL I used to get that from fact_user_sessions is below the questions / answers.

- How are our users moving through the product funnel?
Users are moving pretty consistently through the funnel - about 81% of sessions see an add to cart event, and about 77% of sessions see a checkout event. So those are pretty similar. 

- Which steps in the funnel have largest drop off points?
The checkout step technically has the largest dropoff point, but it's not much more of a drop off than the add to cart step. The next questions from the Director of Product would probably be - how does this differ by state? By product? The model allows for pulling that detail through to a BI tool, which would allow analysts to provide output for those additional questions, not limiting them to just showing aggregate conversion rates.

with counts as
(
select
count(distinct(page_view_session_id)) as pageview
,count(distinct(add_to_cart_session_id)) as addtocart
,count(distinct(checkout_session_id)) as checkout
from fact_conversion_rate
)

select 
addtocart/pageview as conversion_to_add_to_cart
, checkout/addtocart as conversion_checkout
from counts