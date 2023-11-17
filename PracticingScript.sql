Select id, account_id, occurred_at from orders;

--TOP ver solo un poco de consultas   (En PostGre se usa Limit)--------------------
Select top 10 * from orders;

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
