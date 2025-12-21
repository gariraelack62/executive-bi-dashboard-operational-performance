	/****** Script for SelectTopNRows command from SSMS  ******/
	--overview of the whole dataset
	use customer_orders;

	select [customer_id]  
		  ,[customer_status]
		  ,[order_date]
		  ,[delivery_date]
		  ,[order_id]
		  ,[product_id]
		  ,[quantity_ordered]
		  ,[total_retail_price]
		  ,[cost_price_per_unit]
	from [customer_orders].[dbo].[customer_orders_data]

    
--calculate total revenue and profit by month.
--aggregation, calculated metrics, business logic
--https://www.mssqltips.com/sqlservertip/8227/sql-server-datetrunc-function/

	select datetrunc(mm , order_date) as month,
	sum(total_retail_price) as revenue,
	sum(total_retail_price - (quantity_ordered * cost_price_per_unit)) as profit
	from customer_orders_data
	GROUP BY datetrunc(mm, order_date)

	select count(*) as monthly_sales 
	from customer_orders_data
	where datetrunc(mm, order_date) = '01-Jan-17'

	select count(*) as monthly_sales
	from customer_orders_data
	where datetrunc(yy, order_date) = '2017'


    
--the top 5 products by total retail revenue.
--grouping, ordering, ranking

	select top 5 product_id,
	sum(total_retail_price) as total_revenue
	from customer_orders_data
	group by product_id
	order by total_revenue desc


    
--the average delivery time per customer status
--date arithmetic, grouping, business insight
--https://www.mssqltips.com/category/dates/

	select customer_status,
	avg(delivery_date - order_date) as date_delay
	from customer_orders_data
	group by customer_status

	SELECT customer_status,
	DATEDIFF(day, delivery_date, order_date) AS DateDifference
	FROM customer_orders_data
	GROUP BY customer_status;


--orders delivered more than 5 days after order date.
--
-- 
	select * 
	from customer_orders_data
	where datediff(day, delivery_date, order_date) > 3;


--Which customers placed more than 10 orders?
--having vs where 
	select top 10 customer_id,
    count(distinct order_id) as orders
	from customer_orders_data
	group by customer_id
	having count(distinct order_id) > 10;


--Return the most recent order per customer -- window function
--
	select *
	from (
	  select *,
			 row_number() over (partition by customer_id order by order_date desc) rn
	  from customer_orders_data
	) t
	where rn = 1;
--






