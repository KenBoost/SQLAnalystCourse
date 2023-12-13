Select id, account_id, occurred_at from orders;

--TOP ver solo un poco de consultas   (En PostGre se usa Limit)--------------------
Select top 10 * from orders;
Select top 20 *from orders order by occurred_at asc;

--Order By mostrar la consulta ordenada por algo--------------------------------
Select top 10 * from orders order by occurred_at desc
Select id, account_id, total_amt_usd from orders order by account_id, total_amt_usd DESC;

Select id, account_id, total_amt_usd from orders order by total_amt_usd DESC, account_id;

--Where filtrar por condicion-----------------------------------------
Select top 5 * from orders where gloss_amt_usd>=1000
Select top 10 * from orders where total_amt_usd < 500

--Operadores Aritmeticos ( + * - / ) ------------------------------------------
Select account_id, occurred_at, standard_qty, gloss_qty, poster_qty, gloss_qty + poster_qty as Summary from orders

Select top 10 id, (standard_amt_usd/total_amt_usd)*100 as std_percent, total_amt_usd
from orders

--Operadores Logicos (LIKE    IN   NOT   AND    BETWEEN)------------------------
Select * from accounts where website Like '%united%'
Select * from accounts where fullname Like 'C%'

-------------------------------------------IN-----------------------------------------------
Select * from orders where account_id IN (1001, 1021) 
Select fullname, primary_poc, sales_rep_id from accounts where fullname IN ('Walmart','Target','Nordstrom')
Select * from web_events where channel IN ('organic','adwords')

-------------------------------NOT--------------------------------------------------------

Select * from accounts where website NOT Like '%walmart%'
Select * from orders where account_id NOT IN (1001,1021) order by account_id desc
Select * from accounts where fullname NOT LIKE 'C%'
Select * from accounts where fullname NOT LIKE '%one%'

-------------------------------AND & BETWEEN ------------------------------------------------
SELECT * FROM orders where occurred_at >= '2016-10-01' AND occurred_at <= '2016-12-01' order by occurred_at desc
Select * from orders where total BETWEEN 100 AND 110 order by total asc

Select * from orders where standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0
Select * from accounts where fullname NOT LIKE 'C%' AND fullname LIKE '%s'
Select occurred_at, gloss_qty from orders where gloss_qty BETWEEN 24 AND 29 order by gloss_qty asc
Select * 
 FROM web_events 
 where channel IN ('organic', 'adwords') AND occurred_at Like '%2016%' 
 order by occurred_at desc

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;

Select * from accounts
-------------------------------------------OR------------------------------------------

Select * from orders where (standard_qty = 0 OR gloss_qty = 0) AND occurred_at >= '2016-01-10'
Select id from orders where gloss_qty > 4000 OR poster_qty > 4000
Select * from orders where standard_qty = 0 AND (gloss_qty> 1000 OR poster_qty> 1000)
Select fullname, primary_poc from accounts 
 where (fullname Like 'C%' OR  fullname Like 'W%') 
 and (primary_poc Like '%ana%' Or primary_poc Like '%Ana%' ) 
 and primary_poc Not Like '%eana%'


 ------------------------------- JOINS -------------------------------
 SELECT orders.* FROM orders JOIN accounts ON orders.account_id = accounts.id;
 SELECT * FROM web_events 
 JOIN accounts ON web_events.account_id = accounts.id 
 JOIN orders ON accounts.id = orders.account_id
  
 --------------------------------- ALIAS -----------(Reducir el nombre)-----------------
 Select top 10 o.* from orders o Join accounts a On o.account_id = a.id;
 

 -----------------JOIN QUESTIONS---------------------
 /*Provide a table for all web_events associated with account name of Walmart. There should be three columns. 
 Be sure to include the primary_poc, time of the event, and the channel for each event. 
 Additionally, you might choose to add a fourth column to assure only Walmart events were chosen*/
 
 Select a.primary_poc, w.occurred_at, w.channel, a.fullname from web_events w 
 Join accounts a On w.account_id = a.id 
 where a.fullname Like 'Walmart'

 /*Provide a table that provides the region for each sales_rep along with their associated accounts.
 Your final table should include three columns: the region name, the sales rep name, and the account name. 
 Sort the accounts alphabetically (A-Z) according to account name.*/

Select r.name, s.name, a.fullname from sales_reps s 
Join region r on s.region_id = r.id
Join accounts a On a.sales_rep_id = s.id 
Order By a.fullname asc

/*Provide the name for each region for every order,
as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
Your final table should have 3 columns: region name, account name, and unit price. 
A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
*/

Select r.name, a.fullname, (o.total_amt_usd/(o.total+0.01)) As unit_price from orders o Join accounts a On o.account_id = a.id
Join sales_reps s On a.sales_rep_id = s.id
Join region r On s.region_id = r.id 


---------------------------------  OUTTER JOINS --------------------------------------
------------------------------LEFT JOIN-------------------------------------------------
Select o.*, a.* from orders o LEFT Join accounts a on o.account_id = a.id
AND a.sales_rep_id = 321500

-------------------------------RIGHT JOIN ---(NOT COMMON USED)------------------------------------------
Select a.id, a.fullname, o.total from orders o RIGHT Join accounts a on o.account_id = a.id


--------------------- OUTER JOINS QUESTIONS -------------------------------------------
/*Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for the Midwest region. Your final table should include three columns: 
the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name.*/

Select r.name AS Region, s.name AS SalesName, a.fullname AS AcountName from sales_reps s 
Join Region r  On s.region_id = r.id Join accounts a On a.sales_rep_id =  s.id 
where r.name Like 'Midwest' order by a.fullname;

/*Provide a table that provides the region for each sales_rep along with their associated accounts. 
This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. 
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.*/

Select r.name Region, s.name Rep, a.fullname Account from region r 
Join sales_reps s On s.region_id=r.id Join accounts a On a.sales_rep_id=s.id 
Where s.name Like 'S%' AND r.name = 'Midwest' Order By a.fullname

/*Provide a table that provides the region for each sales_rep along with their associated accounts. 
This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. 
Your final table should include three columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name.*/

Select r.name Region, s.name Rep, a.fullname Account from region r 
Join sales_reps s On s.region_id=r.id Join accounts a On a.sales_rep_id=s.id 
Where s.name Like '% K%' AND r.name = 'Midwest' Order By a.fullname

/*Provide the name for each region for every order, 
as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
However, you should only provide the results if the standard order quantity exceeds 100.
Your final table should have 3 columns: region name, account name, and unit price.*/

Select r.name Region, a.fullname Account, (o.total_amt_usd/(o.total+ 0.01)) UnitPrice from region r 
Join sales_reps s On s.region_id = r.id Join accounts a ON a.sales_rep_id = s.id 
JOIN orders o ON o.account_id = a.id where o.standard_qty >100

/*Provide the name for each region for every order, 
as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
However, you should only provide the results if the standard order quantity exceeds 100 
and the poster order quantity exceeds 50. Your final table should have 3 columns: 
region name, account name, and unit price. Sort for the smallest unit price first.*/

Select r.name Region, a.fullname Account, (o.total_amt_usd/(o.total+ 0.01)) UnitPrice from region r 
Join sales_reps s On s.region_id = r.id Join accounts a ON a.sales_rep_id = s.id 
JOIN orders o ON o.account_id = a.id where o.standard_qty >100 AND o.poster_qty >50 order by UnitPrice asc

/*What are the different channels used by account id 1001? Your final table should have only 2 columns: 
account name and the different channels. You can try SELECT DISTINCT to narrow down the results to only
the unique values.*/

Select DISTINCT a.fullname, w.channel from web_events w Join accounts a 
On w.account_id = a.id where a.id = 1001

/*Find all the orders that occurred in 2015. 
Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.*/

SELECT o.occurred_at, a.fullname, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id WHERE o.occurred_at Like '%2015%' order by o.occurred_at desc


---------------------------------    AGREGATIONS  ------------------------------------------
--------Nulls
Select * from accounts WHERE primary_poc IS NULL
Select * from accounts WHERE primary_poc IS NOT NULL


-----------------  COUNT
Select Count(*) AS Num from orders where occurred_at >= '2016-12-01' and occurred_at < '2017-01-01'
Select Count(*) num_rows from accounts
Select COUNT (accounts.id) num_rows from accounts


------------------- SUM  (IGNORES NULL COLUMS)
Select SUM(standard_qty) standard, SUM(gloss_qty) gloss, SUM(poster_qty) poster from orders

-------------- AGREGATION QUESTIONS 

/*Find the total amount of poster_qty paper ordered in the orders table.*/
Select SUM(poster_qty) poster_ordered from orders

/*Find the total amount of standard_qty paper ordered in the orders table.*/
Select SUM(standard_qty) standard_ordered from orders

/*Find the total dollar amount of sales using the total_amt_usd in the orders table.*/
Select SUM(total_amt_usd) AS total_sales from orders

/*Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table.
This should give a dollar amount for each order in the table.*/
Select id, (standard_amt_usd + gloss_amt_usd) as total_spent from orders 

/*Find the standard_amt_usd per unit of standard_qty paper. 
Your solution should use both an aggregation and a mathematical operator.*/
Select SUM(standard_amt_usd)/SUM(standard_qty) AS price_per_unit from orders



--------------------------- QUESTIONS MIN MAX AVG
/*When was the earliest order ever placed? You only need to return the date.*/
Select MIN(occurred_at) earliest_order FROM orders

/*Try performing the same query as in question 1 without using an aggregation function.*/
Select Top 1 * from orders order by occurred_at 

/*When did the most recent (latest) web_event occur?*/
Select MAX(occurred_at) latest_event from web_events

/*Try to perform the result of the previous query without using an aggregation function.*/
Select Top 1 * from web_events order by occurred_at desc

/*Find the mean (AVERAGE) amount spent per order on each paper type, 
as well as the mean amount of each paper type purchased per order. 
Your final answer should have 6 values - one for each paper type for the average number of sales, 
as well as the average amount.*/
Select AVG(standard_qty) stand_amount, AVG(gloss_qty) gloss_amount, AVG(poster_qty) poster_amount,
AVG(standard_amt_usd) standard_p, AVG(gloss_amt_usd) gloss_p, AVG(poster_amt_usd) poster_p from orders

/*Via the video, you might be interested in how to calculate the MEDIAN. 
Though this is more advanced than what we have covered so far try finding - what is the 
MEDIAN total_usd spent on all orders?*/
SELECT AVG(total_amt_usd) AS promedio_montos
FROM ( SELECT TOP 2 total_amt_usd FROM ( SELECT TOP 3457 total_amt_usd FROM orders ORDER BY total_amt_usd) 
AS Table1 ORDER BY total_amt_usd DESC) AS Table2;

------------------------------ GROUP BY 
Select account_id, SUM(standard_qty) standard, SUM(gloss_qty) gloss, SUM(poster_qty) poster 
from orders  GROUP BY account_id order by account_id


--------------------- QUESTIONS GROUP BY 
/*Which account (by name) placed the earliest order? 
Your solution should have the account name and the date of the order.*/
Select TOP 1 a.fullname, o.occurred_at from orders o Join accounts a On o.account_id = a.id 
order by occurred_at 

/*Find the total sales in usd for each account. You should include two columns - 
the total sales for each company's orders in usd and the company name.*/
Select a.fullname, SUM(o.total_amt_usd) total from orders o JOIN accounts a On o.account_id = a.id
GROUP BY a.fullname

/*Via what channel did the most recent (latest) web_event occur, 
which account was associated with this web_event? 
Your query should return only three values - the date, channel, and account name.*/
Select Top 1 w.occurred_at, w.channel, a.fullname from web_events w 
Join accounts a On w.account_id  = a.id order by w.occurred_at desc

/*Find the total number of times each type of channel from the web_events was used. 
Your final table should have two columns - 
the channel and the number of times the channel was used.*/
SELECT w.channel, COUNT(*) FROM web_events w GROUP BY w.channel

/*Who was the primary contact associated with the earliest web_event?*/
Select Top 1 a.fullname from web_events w Join accounts a on w.account_id = a.id
order by w.occurred_at 

/*What was the smallest order placed by each account in terms of total usd. 
Provide only two columns - the account name and the total usd. 
Order from smallest dollar amounts to largest.*/
Select a.fullname, MIN(o.total_amt_usd) total from accounts a Join orders o on o.account_id = a.id
group by a.fullname order by total asc
 
/*Find the number of sales reps in each region. 
Your final table should have two columns - the region and the number of sales_reps. 
Order from fewest reps to most reps.*/
Select r.name, count(*) total_sales from sales_reps s Join region r on s.region_id = r.id
group by r.name order by total_sales


--------------------------------------   GROUP BY PART II
/*For each account, determine the average amount of each type of paper they purchased across 
their orders. Your result should have four columns - one for the account name and one for 
the average quantity purchased for each of the paper types for each account.*/
Select a.fullname, AVG(o.poster_qty) poster, AVG(o.standard_qty) stand, AVG(o.gloss_qty) gloss
from accounts a JOIN orders o on o.account_id = a.id 
group by a.fullname order by a.fullname

/*For each account, determine the average amount spent per order on each paper type. 
Your result should have four columns - one for the account name and one for the average 
amount spent on each paper type.*/
Select a.fullname, AVG(o.poster_amt_usd) poster, AVG(o.standard_amt_usd) stand, AVG(o.gloss_amt_usd) gloss
from accounts a JOIN orders o on o.account_id = a.id 
group by a.fullname order by a.fullname


/*Determine the number of times a particular channel was used in the web_events
table for each sales rep. Your final table should have three columns - 
the name of the sales rep, the channel, and the number of occurrences. 
Order your table with the highest number of occurrences first.*/

Select s.name, w.channel, Count(*) num_events from accounts a Join web_events w On w.account_id = a.id
Join sales_reps s On a.sales_rep_id = s.id Group by s.name, w.channel order by num_events desc;

/*Determine the number of times a particular channel was used in the web_events 
table for each region. Your final table should have three columns - 
the region name, the channel, and the number of occurrences. Order your 
table with the highest number of occurrences first.*/

Select r.name, w.channel, COUNT(*) AS ocurrences from sales_reps s 
Join accounts a on s.id = a.sales_rep_id Join web_events w On w.account_id = a.id 
Join region r On s.region_id = r.id group by r.name, w.channel order by ocurrences desc;


----------------------------  DISTINCT --------------------------------------

Select DISTINCT w.id, w.account_id, w.channel  from web_events w order by w.id

/*Use DISTINCT to test if there are any accounts associated with more than one region.*/
SELECT a.id as "account id", r.id as "region id", 
a.fullname as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;


SELECT DISTINCT id, fullname FROM accounts;

/*Have any sales reps worked on more than one account?*/
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;

Select DISTINCT  id, name from sales_reps


----------------------------- HAVING -------(where in aggregations)-------------------

Select o.account_id, SUM(o.total_amt_usd) as "TOTAL AMOUNT" from orders o
group by o.account_id having SUM(o.total_amt_usd) >= 250000

/*How many of the sales reps have more than 5 accounts that they manage?*/
Select s.id, s.name, COUNT(*) as num_manage from accounts a JOIn sales_reps s on a.sales_rep_id = s.id
group by s.id, s.name having COUNT(*) > 5

/*How many accounts have more than 20 orders?*/
Select a.id, Count(*) as num_accounts from orders o Join accounts a On o.account_id = a.id
group by a.id having Count(*) > 20 order by num_accounts

/*Which account has the  most orders?*/
Select Top 1 a.id, Count(*) as num_accounts from orders o Join accounts a On o.account_id = a.id
group by a.id order by num_accounts desc

/*Which accounts spent more than 30,000 usd total across all orders?*/
Select  a.fullname, SUM(o.total_amt_usd) total  from orders o Join accounts a On o.account_id = a.id
group by a.fullname, total having SUM(o.total_amt_usd) >30000 order by total

/*Which accounts spent less than 1,000 usd total across all orders?*/
Select  a.fullname, SUM(o.total_amt_usd) total  from orders o Join accounts a On o.account_id = a.id
group by a.fullname, total having SUM(o.total_amt_usd) <1000 order by total

/*Which account has spent the most with us?*/
Select top 1 a.fullname, SUM(o.total_amt_usd) total  from orders o Join accounts a On o.account_id = a.id
group by a.fullname, total order by total desc

/*Which account has spent the least with us?*/
Select top 1 a.fullname, SUM(o.total_amt_usd) total  from orders o Join accounts a On o.account_id = a.id
group by a.fullname, total order by total asc

/*Which accounts used facebook as a channel to contact customers more than 6 times?*/
Select a.fullname, w.channel, Count(*) times from web_events w Join accounts a On w.account_id = a.id
Group by a.fullname, w.channel having w.channel Like 'Facebook' and Count(*) > 6 order by times

/*Which account used facebook most as a channel?*/
Select top 1 a.fullname, w.channel, Count(*) times from web_events w Join accounts a On w.account_id = a.id
Group by a.fullname, w.channel having w.channel Like 'Facebook'order by times desc

/*Which channel was most frequently used by most accounts?*/
Select top 10 a.fullname, w.channel, Count(*) times from web_events w Join accounts a On w.account_id = a.id
Group by a.fullname, w.channel order by times desc

--------------------------------   DATE FUNCTIONS ------(DATE TRUNC)----------------------
Select DATEPART(DAY, occurred_at) as day_week, account_id, occurred_at, total from orders
Select DATETRUNC(DAY, occurred_at) as day, SUM(standard_qty) as stnd_qty_sum from orders
group by DATETRUNC(DAY, occurred_at)  order by DATETRUNC(DAY, occurred_at) 

Select DATEPART(WEEKDAY, occurred_at) as day_of_week, sum(total)  total_qty from orders 
group by DATEPART(WEEKDAY, occurred_at)  order by total_qty desc

----------------------------------- DATE QUESTIONS ------------------------------------
/*Find the sales in terms of total dollars for all orders in each year, 
ordered from greatest to least. Do you notice any trends in the yearly sales totals?*/
Select DATEPART(YEAR, o.occurred_at ) as year, SUM(o.total_amt_usd) as total_sales from orders o
group by DATEPART(YEAR, o.occurred_at ) order by SUM(o.total_amt_usd) desc


/*Which month did Parch & Posey have the greatest sales in terms of total dollars? 
Are all months evenly represented by the dataset?*/
Select TOP 1 DATEPART(MONTH, occurred_at) as Month, SUM (total_amt_usd) as total from orders  
group by DATEPART(MONTH, occurred_at) order by total desc


/*Which year did Parch & Posey have the greatest sales in terms of total number of orders? 
Are all years evenly represented by the dataset?*/
Select top 1 DATEPART(YEAR, o.occurred_at ) as year, cOUNT(*) amount_orders from orders o
group by DATEPART(YEAR, o.occurred_at ) order by amount_orders desc

/*Which month did Parch & Posey have the greatest sales in terms of total number of orders? 
Are all months evenly represented by the dataset?*/
Select TOP 1 DATETRUNC(MONTH, occurred_at) as Month, cOUNT(*) amount_orders from orders  
group by DATETRUNC(MONTH, occurred_at) order by amount_orders desc

/*In which month of which year did Walmart spend the most on gloss paper in terms of dollars?*/
Select top 1 DATETRUNC(MONTH, o.occurred_at) as month_year, SUM(o.gloss_amt_usd) as gloss_spent from orders o
jOIN accounts a On a.id = o.account_id where a.fullname = 'Walmart'
group by DATETRUNC(MONTH, occurred_at) order by gloss_spent desc


/*----------------------------------- CASE -------------(CASE WHEN THEN (ELSE) END AS)-------------------------------------*/
Select id, account_id, occurred_at, channel, 
Case When channel = 'Facebook' or channel = 'direct' then 'yes' else 'no' 
end as is_facebook from web_events order by occurred_at

Select account_id, occurred_at, total,
Case when total > 500 then 'Over 500'
     when total > 300 and total <=500 then '301-500'
	 when total >100 and total <= 300 then '101-300'
	 else '101 or under' end as total_group
from orders

/*--------------------------- CASE AGREGATIONS --------------------------------*/
Select Case when total >500 then 'Over 500' else '500 or under' end as total_group, 
COUNT(*) as order_count
from orders group by  CASE WHEN total > 500 THEN 'Over 500' ELSE '500 or under' END;

/*Write a query to display for each order, the account ID, total amount of the order, 
and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, 
or smaller than $3000.*/

Select account_id, total_amt_usd, 
Case when total_amt_usd > 3000 then 'Large' else 'Small' end as level_order from orders

/*Write a query to display the number of orders in each of three categories, 
based on the total number of items in each order. 
The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.*/
Select Case when total > 2000 then 'At least 2000'
            when total >=1000 and total <2000 then 'Between 1000 and 2000' 
			else 'Less than 2000' end as order_category, count(*) as order_count
from orders group by Case when total > 2000 then 'At least 2000'
            when total >=1000 and total <2000 then 'Between 1000 and 2000' 
			else 'Less than 2000' end

/*We would like to understand 3 different levels of customers based on the amount 
associated with their purchases. The top level includes anyone with a 
Lifetime Value (total sales of all orders) greater than 200,000 usd. 
The second level is between 200,000 and 100,000 usd. 
The lowest level is anyone under 100,000 usd. 
Provide a table that includes the level associated with each account. 
You should provide the account name, the total sales of all orders for the customer, and the level. 
Order with the top spending customers listed first.*/

Select a.fullname, Sum(o.total_amt_usd) as total_sales, 
       Case when SUM(o.total_amt_usd) >200000 then 'Top'
            when SUM(o.total_amt_usd) >100000 then 'Middle'
            else 'low' end as level
from orders o 
Join accounts a 
ON o.account_id = a.id 
group by a.fullname
order by total_sales desc

/*We would now like to perform a similar calculation to the first, 
but we want to obtain the total amount spent by customers only in 2016 and 2017. 
Keep the same levels as in the previous question. Order with the top spending customers listed first.*/

Select a.fullname, Sum(o.total_amt_usd) as total_sales, 
       Case when SUM(o.total_amt_usd) >200000 then 'Top'
            when SUM(o.total_amt_usd) >100000 then 'Middle'
            else 'low' end as level
from orders o 
Join accounts a 
ON o.account_id = a.id 
where o.occurred_at > '2015-12-31' 
group by a.fullname
order by total_sales desc


/*We would like to identify top performing sales reps, 
which are sales reps associated with more than 200 orders. 
Create a table with the sales rep name, the total number of orders, 
and a column with top or not depending on if they have more than 200 orders. 
Place the top sales people first in your final table.*/

Select s.name, Count(*) as num_orders, 
Case When Count(*)>200 then 'Top' else 'Not Top' end as performance from sales_reps s 
Join accounts a On a.sales_rep_id = s.id 
Join orders o On o.account_id = a.id group by s.name order by num_orders desc

/*The previous didn't account for the middle, nor the dollar amount associated with the sales. 
Management decides they want to see these characteristics represented as well. 
We would like to identify top performing sales reps, 
which are sales reps associated with more than 200 orders or more than 750000 in total sales. 
The middle group has any rep with more than 150 orders or 500000 in sales.
Create a table with the sales rep name, the total number of orders,
total sales across all orders, and a column with top, middle, or low depending on this criteria. 
Place the top sales people based on dollar amount of sales first in your final table. 
You might see a few upset sales people by this criteria!*/

Select s.name, Count(*) as num_orders, SUM(o.total_amt_usd) total_sales,
Case When Count(*)>200 or SUM(o.total_amt_usd) > 750000 then 'Top' 
     When Count(*)>150 or SUM(o.total_amt_usd) > 500000 then 'Middle'
	 else 'Low' end as performance 
from sales_reps s 
Join accounts a On a.sales_rep_id = s.id 
Join orders o On o.account_id = a.id 
group by s.name order by total_sales desc


/*----------------------  SUBQUERIES  (solo puedo tener un order by)  -------------------------*/
Select channel, AVG(event_count) as avg_event_count  from
(Select DATETRUNC( DAY , occurred_at) as day_date, channel, count(*) as event_count from web_events
GROUP BY DATETRUNC( DAY , occurred_at), channel) sub
group by channel order by avg_event_count desc 

