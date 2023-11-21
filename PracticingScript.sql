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