 #Coffee Sales Performance Analysis
 
 #"How do different coffee types perform in sales, and how do pricing, discounts,
 #and customer behavior influence revenue?"
 
 
 #Sales Performance Analysis
 
#Which coffee type generates the most revenue?
# Total sales as per Coffee Type

select product, sum(Final_Sales) as Total_sales 
from coffeesales group by product order by Total_sales desc;
#Best & Worst Performing Cities (Sales)
 select city, sum(final_sales) as total_revenue,
 rank() over (order by sum(final_sales) desc ) as sales_rank
 from coffeesales group by city
 order by total_revenue desc;


#What are the monthly and seasonal sales trends?
UPDATE coffeesales 
SET Date = TRIM(Date);

select  monthname(str_to_date(date, '%m/%d/%y')) as Month_, 
sum(Final_sales) as Total_sales
from coffeesales 
group by monthname(str_to_date(date, '%m/%d/%y'))
order by Total_sales desc;
#June have the highest sale, and lowest october

#What is the average revenue per transaction?
 select sum(final_sales)/count(distinct customer_id) as avg_Rev 
 from coffeesales;
# taking cx as trans Id
 

#Top 10 Customers by Total Sales
#Who are the top 10 customers by total purchases?

select customer_id, sum(final_sales) as Total_spending 
from coffeesales group by customer_id order by Total_spending desc
limit 10;

#How often do customers purchase coffee? (Repeat customers vs. one-time buyers)

select customer_id, count(*) as purchase_count from coffeesales
group by customer_id;

select count(distinct customer_id) as Total_customer, count(*) as Total_transations,
(sum(final_sales)/count(*)) as avg_rev,
count(distinct case when purchase_count =1 then customer_id end) as one_time_buyers,
count(distinct case when purchase_count > 1 then customer_id end) as repeat_buyers,
(count(distinct case when purchase_count > 1 then customer_id end)*100/
count(distinct customer_id)) as repeat_rate 
from (select customer_id, sum(final_sales) as final_sales, count(*) as purchase_count from coffeesales
group by customer_id) as cx_purchase;



#What is the average quantity per order for each coffee type?
#Average Order Quantity Per Coffee Type
select * from coffeesales;

select product, avg(quantity) qty_per_order from coffeesales 
group by product order by qty_per_order desc ;

#3️ Discount & Pricing Effectiveness
#What percentage of sales had discounts applied?

select count(*) as total_sale,
count(case when Used_Discount = 'true' then 1 end) as used_discount,
(count(case when used_discount = 'True' then 1 end)* 100/ count(*)) as discount_percentage
from coffeesales;

#How much revenue was lost due to discounts?
select sum(`sales amount`) as revenue_before_dis, sum(final_sales) as revenue_after_dis,
sum(`sales amount`)-sum(final_sales) as lost_revenue,
(sum(`Sales Amount`)-sum(final_sales))*100/sum(`Sales Amount`) as discount_percentage
from coffeesales;

#Did customers purchase more quantity when discounts were applied?


select sum(quantity) as total_quantity_sold,
sum(case when used_discount = 'True' then quantity end ) as qty_with_discount,
sum(case when used_discount = 'False' then quantity end ) as qty_without_discount,
(sum(case when used_discount = 'True' then quantity end )*100/sum(quantity)) as percentage_after_discount
from coffeesales;


#Product Performance Analysis

#Which coffee type is the most sold and least sold?
select product, sum(quantity) as QtySold 
from coffeesales group by Product
order by QtySold desc;

#What is the average order value for each coffee type?
select product, avg(final_sales) as AvgOrd_value
from coffeesales group by product;
#Which coffee type has the highest and lowest discount usage?
select dayname(str_to_date(Date,'%m/%d/%y')) AS Purchase_Day, 
count(*) as Order_Count
from Coffeesales
group by Purchase_Day
order by Order_Count desc;