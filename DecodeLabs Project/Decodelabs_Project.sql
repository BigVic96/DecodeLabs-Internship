create database sales_DA;
use sales_DA;
select * from sales;
describe sales;
alter table sales modify date datetime;
select couponcode from sales;
set sql_safe_updates = 0;
update sales
set couponcode = 'Unknown' where couponcode = '';
select round(sum(totalprice),2) Revenue
 from sales;
 select distinct product from sales;
 select round(avg(totalprice),2) Avg_Sales from sales;
 select count(distinct OrderID) from sales;
select couponcode, round(sum(totalprice),2) as Total_revenue from sales
where couponcode IN ('FREESHIP', 'SAVE10', 'Unknown', 'WINTER15')
group by couponcode
order by Total_revenue;
select count(distinct CustomerID) from sales;
 select distinct couponcode from sales;
 select * from sales where totalprice <3334;
 select * from sales where totalprice >3333;
 -- Revenue without outlier
 select round(sum(totalprice),2)  from sales where totalprice <= 3333;
 -- Outlier
 select round(sum(totalprice),2)  from sales where totalprice >= 3334;
 -- Revenue per Year
 select year(date), sum(totalprice) from sales
 group by year(date);
 
 select year(date), sum(totalprice) from sales
 where totalprice <= 3333
 group by year(date);
 select year(date), sum(totalprice) from sales
 where totalprice >= 3334
 group by year(date);
 -- Rankning product by year (Product with the highest revenue per year)
 With CategorySales AS (SELECT year(date) AS sales_year,product,
sum(totalprice) AS total_revenue,
count(OrderID) AS total_orders
from sales  group by year(date), product)
SELECT sales_year,product,ROUND(total_revenue, 2) AS total_revenue,total_orders,
RANK() OVER (PARTITION BY sales_year order by total_revenue desc) as category_rank
FROM CategorySales order by sales_year asc, category_rank asc;

--  products by year  (Without Valid Outliers)
With CategorySales AS (SELECT year(date) AS sales_year,product,
sum(totalprice) AS total_revenue,
count(OrderID) AS total_orders
from sales where totalprice <=3333
 group by year(date), product)
SELECT sales_year,product,ROUND(total_revenue, 2) AS total_revenue,total_orders,
RANK() OVER (PARTITION BY sales_year order by total_revenue desc) as category_rank
FROM CategorySales order by sales_year asc, category_rank asc;

-- Average Order value
select round(sum(totalprice)/count(OrderID),2) as AOV from sales;
-- Average order value overtime
SELECT year(date) AS Sales_Year, quarter(date) AS Sales_Quarter,
round(sum(totalprice), 2) AS total_revenue, count(OrderID) as total_orders,
round(sum(totalprice) / count(OrderID), 2) as Average_Order_Value
from sales
group by year(date), quarter(date)
order by Sales_Year asc, Sales_Quarter asc;

--  Average order value overtime  (Without Valid Outliers)
SELECT year(date) AS Sales_Year, quarter(date) AS Sales_Quarter,
round(sum(totalprice), 2) AS total_revenue, count(OrderID) as total_orders,
round(sum(totalprice) / count(OrderID), 2) as Average_Order_Value
from sales where totalprice <= 3333
group by year(date), quarter(date)
order by Sales_Year asc, Sales_Quarter asc;
-- Average Order value
select round(sum(totalprice)/count(OrderID),2) as AOV 
from sales where totalprice >= 3334;

select round(sum(totalprice)/count(OrderID),2) as AOV 
from sales where totalprice <= 3333;


--  Average order value overtime  ( Valid Outliers)
SELECT year(date) AS Sales_Year, quarter(date) AS Sales_Quarter,
round(sum(totalprice), 2) AS total_revenue, count(OrderID) as total_orders,
round(sum(totalprice) / count(OrderID), 2) as Average_Order_Value
from sales where totalprice >= 3334
group by year(date), quarter(date)
order by Sales_Year asc, Sales_Quarter asc;

select * from sales;
select paymentmethod, ReferralSource, 
round(sum(totalprice),2) Total_Revenue
from sales group by paymentmethod, Referralsource
 order by Total_Revenue asc;
 -- Total revenue by referral source
 select  ReferralSource, 
round(sum(totalprice),2) Total_Revenue
from sales group by  Referralsource
 order by Total_Revenue asc;
 

-- coupon usage

SELECT 
    YEAR(date) AS sales_year,
    CASE 
WHEN couponcode = 'Unknown' THEN 'Full Price (No Coupon)'
ELSE 'Discounted (Coupon Used)'
END AS purchase_type,
count(OrderID) as order_count,
round(SUM(totalprice), 2) as Total_revenue,
round((SUM(totalprice) / TOTAL.year_total) * 100, 2) as percent_of_yearly_revenue
from sales
JOIN (select YEAR(date) AS y, SUM(totalprice) AS year_total from sales
group by YEAR(date)) TOTAL ON YEAR(date) = TOTAL.y
group by YEAR(date), purchase_type, TOTAL.year_total
order by sales_year asc, Total_revenue desc;


SELECT 
YEAR(date) as sales_year,
couponcode,
COUNT(OrderID) AS order_count, round(SUM(totalprice), 2) AS Total_revenue,
round((SUM(totalprice) / TOTAL.year_total) * 100, 2) AS percent_of_yearly_revenue
from sales
JOIN (SELECT YEAR(date) AS y, SUM(totalprice) as year_total 
FROM sales GROUP BY YEAR(date)) 
TOTAL ON YEAR(date) = TOTAL.y GROUP BY YEAR(date), couponcode, 
TOTAL.year_total
ORDER BY sales_year asc, Total_revenue desc;

