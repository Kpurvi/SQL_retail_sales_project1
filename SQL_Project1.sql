--SQL Retail Sales Analysis -Project 1


--Create Table
Create Table retail_sales (
	transactions_id int primary key,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(15),
	age int,
	category varchar(15),
	quantity int,
	price_per_unit float,
	cogs float,
	total_sale float
	
);

ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;


select * from retail_sales;

select * from retail_sales limit 10;

select count(*) from retail_Sales ;

--Data Cleaning 

select * from retail_sales where transactions_id is null;

select * from retail_sales where sale_time is null;

 select * from retail_sales
	 where
	transactions_id is null
	 or
	sale_date is null
	 or 
	sale_time is null
	 or
	gender is null
	 or
	category is null
	 or 
	quantity is null
	 or 
	cogs is null
	 or
	 total_sale is null; 

Delete from retail_sales where
transactions_id is null
	 or
	sale_date is null
	 or 
	sale_time is null
	 or
	gender is null
	 or
	category is null
	 or 
	quantity is null
	 or 
	cogs is null
	 or
	 total_sale is null; 

-- Data Exploration

--How many sales we have ?

Select count(*) as total_sales from retail_sales;

--How many unique customers we have ?

Select count(distinct customer_id) as total_customers from retail_sales;

Select distinct category  from retail_sales;

--Data Analysis & Business Key Problems & Answers

--Q1 Write SQL query to retrieve all columns for sales made on '202211-05'

select * from retail_sales where sale_date = '2022-11-05';

--Q2 - retrieve all transactions where the category is  'Clothing' and the quantity sold has to be more than 4 in the month of Nov-2022

select * from retail_sales where category='Clothing' and quantity >=4 and
	to_char(sale_date,'yyyy-mm')='2022-11';

--Q3 To calculate the total sales for each category

select category, sum(total_sale) as net_sale, 
	count(*) as total_orders from retail_sales group by 1;

--Q4 To find the average age of customers who purchased items from the Beauty  

select round(avg(age),2) from retail_sales where category='Beauty';

--Q5 To find all transactions where the total_sale is greater than 1000
select  * from retail_sales where total_sale>1000;

--Q6 To find the total number of transactions (transaction_id) mad by each gender in each category

select category, gender, count(*) as total_trans from retail_sales group by category,gender order by 1;

--Q7 To calculate the average sale for each month, find out best selling month in each year

select * from (
	select extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	sum(total_sale) as avg_sale ,
	rank() over(partition by extract (year from sale_date) order by avg(total_sale) desc)
	from retail_sales
	group by 1,2 ) as t1
where rank=1
--	order by 1,2 desc;

--Q8 To find top 5 customers based on the highest total sales

select customer_id, sum(total_sale) as total_sales
	from retail_sales group by 1 order by 2 desc limit 5;

--Q9 To find no. of unique customers who purchased items from each catgory.

select category, count(distinct customer_id) as unique_cust from retail_sales 
	group by category;

--Q10 To create each shift and no. of orders 
with hourly_sale as (
select * ,
	case
	when extract(hour from sale_time)<12 then 'Morning'
	when extract(hour from sale_time) between 12 and 17  then 'Afternoon'
	else 'Evening'
	end as shift
	from retail_sales )
	select shift, count(*) as total_orders from hourly_sale
	group by shift;


