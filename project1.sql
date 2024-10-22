-- SQL Retail sales analyst-
DROP TABLE IF EXISTS retail_sales;
create table retail_sales (
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(20),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

--

select * from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

--

DELETE from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

-- total sale
select count(*) as total_sale from retail_sales

-- total customer
select count(Distinct customer_id) as customer from retail_sales

-- total category
select count(Distinct category) as category from retail_sales

-- Data analyst 
--1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
--2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
--3. Write a SQL query to calculate the total sales (total_sale) for each category.:
--4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
--5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
--6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
--7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
--8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
--9. Write a SQL query to find the number of unique customers who purchased items from each category.:
--10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from retail_sales
where sale_date = '2022-11-05'

--2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from retail_sales
where category='Clothing' and quantiy>=4 and TO_CHAR(sale_date,'YYYY-MM') = '2022-11'

--3. Write a SQL query to calculate the total sales (total_sale) for each category.:
select category, sum(total_sale) as total from retail_sales
group by category

--4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select category, Round(Avg(age)) as age from retail_sales
where category='Beauty'
group by category

--5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * from retail_sales
where total_sale> 1000

--6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select category, gender, count(transactions_id) as number_transaction from retail_sales
group by category, gender
order by 1

--7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select year, month, avg_total from 
(	select 
	EXTRACT (Year from sale_date) as year,
	EXTRACT (month from sale_date) as month,
	avg(total_sale) as avg_total,
	RANK() over(partition by EXTRACT (Year from sale_date) order by avg(total_sale) DESC) as rank
from retail_sales
group by 1,2
) as t1
where rank = 1
--order by 1,3 DESC

--8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
select 
	customer_id,
	sum(total_sale) as total
from retail_sales
group by 1
order by 2 desc
limit 5

--9. Write a SQL query to find the number of unique customers who purchased items from each category.:
select 
	category,
	count (distinct customer_id) as unik_costumer
from retail_sales
group by 1

--10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
With hourly
as 
(
Select *, 
	case 
		when Extract(Hour from sale_time)<12 then 'Morning'
		when Extract(Hour from sale_time) Between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
)

Select 
shift,
count(transactions_id) as order
from hourly
group by shift