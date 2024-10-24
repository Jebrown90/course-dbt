## Part 1: Create new models to answer the first two questions (answer questions in README file)
(Conversion rate is defined as the # of unique sessions with a purchase event / total number of unique sessions. Conversion rate by product is defined as the # of unique sessions with a purchase event of that product / total number of unique sessions that viewed that product)

What is our overall conversion rate?

What is our conversion rate by product?



## Part 2: We’re getting really excited about dbt macros after learning more about them and want to apply them to improve our dbt project. 

Create a macro to simplify part of a model(s). Think about what would improve the usability or modularity of your code by applying a macro. Large case statements, or blocks of SQL that are often repeated make great candidates. Document the macro(s) using a .yml file in the macros directory.

Answer: 

I decided to group this together with my installation of dbt-utils. I thought the best thing I could do would be to remove case when statements around event types, and instead have them automatically populate through a macro. I installed the dbt-utils package as part of Part 5, and then will used a macro from that package to accomplish this.

In the end there was really only one case when statement block I could simplify in what I had set up, so I chose to use the dbt-utils.get_column_values macro to return the event types in int_session_events and added the macro in the macros folder as event_types.sql. This will also make it simpler in the future if additional events are added to the product funnel, which is probably unavoidable given the current simplicity of the funnel.


## Part 3: We’re starting to think about granting permissions to our dbt models in our snowflake database so that other roles can have access to them. Add a post hook to your project to apply grants to the role “reporting”. You can use the grant macro example from this week!




## Part 4:  After learning about dbt packages, we want to try one out and apply some macros or tests. Install a package (i.e. dbt-utils, dbt-expectations) and apply one or more of the macros to your project

See part 3! I downloaded dbt-utils and used the get_column_values function from that package.A



## Part 5: After improving our project with all the things that we have learned about dbt, we want to show off our work! Show (using dbt docs and the model DAGs) how you have simplified or improved a DAG using macros and/or dbt packages.



## Part 6. dbt Snapshots. Let's update our products snapshot again to see how our data is changing:

Run the products snapshot model using dbt snapshot and query it in snowflake to see how the data has changed since last week. Which products had their inventory change from week 2 to week 3? 

Four products had their inventory change from week 2 to week 3:

Monstera: decreased from 64 to 50
Philodendron: decreased from 25 to 15
Pothos: decreased from 20 to 0 (sold out!)
String of Pearls: decreased from 10 to 0 (also sold out!)