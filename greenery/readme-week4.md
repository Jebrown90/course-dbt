## Part 1. dbt Snapshots. Let's update our products snapshot one last time to see how our data is changing: Run the products snapshot model using dbt snapshot and query it in snowflake to see how the data has changed since last week.  

## Which products had their inventory change from week 3 to week 4? 

Six products had their inventory change from week 3 to week 4 - Pothos, Philodendron, Bamboo, ZZ Plant, Monstera, and String of Pearls.

## Now that we have 3 weeks of snapshot data, can you use the inventory changes to determine which products had the most fluctuations in inventory? Did we have any items go out of stock in the last 3 weeks? 

The above six products had the most fluctuation in inventory. The remaining plants saw no change from week to week (maybe this indicates the flower store should stop or minimize stocking of those!). Pothos and String of Pearls went out of stock and then were re-stocked in week 4 (back to 20 and 10 units, respectively). Philodendron was also re-stocked between week 3 and 4 (from 15 to 30 units) but never actually went out of stock.





## Part 2. Modeling challenge

Let’s say that the Director of Product at greenery comes to us (the head Analytics Engineer) and asks some questions:

- How are our users moving through the product funnel?
- Which steps in the funnel have largest drop off points?

Product funnel is defined with 3 levels for our dataset:

- Sessions with any event of type page_view
- Sessions with any event of type add_to_cart
- Sessions with any event of type checkout

They need to understand how the product funnel is performing to set the roadmap for the next quarter. The Product and Engineering teams are asking what their projects will be, and they want to make data-informed decisions. Thankfully, we can help using our data, and modeling it with dbt!

In addition to answering these questions right now, we want to be able to answer them at any time. The Product and Engineering teams will want to track how they are improving these metrics on an ongoing basis. As such, we need to think about how we can model the data in a way that allows us to set up reporting for the long-term tracking of our goals.

We’ll also want to make sure that any model feeding into this report is defined in an exposure (which we’ll cover in this week’s materials).

Please create any additional dbt models needed to help answer these questions from our product team, and put your answers in a README in your repo.

Use an exposure on your product analytics model to represent that this is being used in downstream BI tools. Please reference the course content if you have questions.

ANSWER:

I feel that I already have a model that would be sufficient to meet the request from Director of Product above. The fact_user_sessions model in the product folder in my mart is actually very well set up to be manipulated in a BI tool like Sigma. Not only does that model count up, by session_id, the number of "page views", "add to carts" and "checkouts". At the same time, I made sure to add both user detail (like account created date or state of user) as well as product detail (like product name) that end users may want to see sessions broken out by. This counts of actions can be used to create conversion rates, which can then be shown in bar charts broken down by the dimensions I named above or by type of conversion to see where the largest percentage of users "fall off", or it can be used to create the funnel visual that Jake showed during the walk-through.

At the same time, because the model also includes timestamps like account_created_date, session_started_at and session_ended_at, I could also create an over time view of conversion, allowing users (perhaps) to show the conversion rate they're most interested in over time, cohorted by timestamp of interest to them. That being said, the answers to the specific questions the Director of Product asked are below, and the SQL I used to get that from fact_user_sessions is below the questions / answers.

- How are our users moving through the product funnel?
- Which steps in the funnel have largest drop off points?



## Part 3: Reflection questions -- please answer 3A or 3B, or both!

## 3A. dbt next steps for you. Reflecting on your learning in this class...

## if your organization is thinking about using dbt, how would you pitch the value of dbt/analytics engineering to a decision maker at your organization?

We already use DBT, and I've been a very strong proponent of continuing to do so, regardless of whatever other tools we onboard, as it greatly increases the flexibility of the team in being able to approach data, and allows non-Data Engineers to deliver data output more quickly and easily.

## if your organization is using dbt, what are 1-2 things you might do differently / recommend to your organization based on learning from this course?

I think the biggest thing I would recommend is strategic use of macros to save on costs, as well as the standardizing of views/table usage (i.e., assigning table status to a whole schema of models, and not assigning view or table to individual models). I would also recommend exposures, as we currently just sort of have that in my mind and the mind of our Data Engineering Manager. That needs to be recorded somewhere!

For the latter, we kind of just do whatever, whereas I think it really makes the most sense for int and fact/dimension models to be tables, as it makes it quicker for users to interact with them. I'll be making that happen in my org!

## if you are thinking about moving to analytics engineering, what skills have you picked that give you the most confidence in pursuing this next step?

I am the Analytics Engineer at my org - I think what helps about this course is getting familiar with accessing and using dbt docs to help with working through any issues that arise.

## 3B. Setting up for production / scheduled dbt run of your project And finally, before you fly free into the dbt night, we will take a step back and reflect: after learning about the various options for dbt deployment and seeing your final dbt project, how would you go about setting up a production/scheduled dbt run of your project in an ideal state? You don’t have to actually set anything up - just jot down what you would do and why and post in a README file.

I would set up staging, int, and fact/dimension models. I would want to use a tool to ingest and orchestrate that ingest (Airflow, Dagster, or something like that). Depending on the need, I would likely have an every 3, 6, 12, or 24 hour ingest. I would want to make sure that the "first" ingest of the day takes place around 4am so that those checking data first thing in the morning get fresh data.

Hints: what steps would you have? Which orchestration tool(s) would you be interested in using? What schedule would you run your project on? Which metadata would you be interested in using? How/why would you use the specific metadata? , etc.