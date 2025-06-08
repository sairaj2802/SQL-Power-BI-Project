-- Customer/product lists, filtering by cities/categories.
select * 
from customers
where city='Mumbai';

select  distinct category
from products;

select * 
from products
where category ='sports' ;

-- Customer orders, product sales, order details.
-- List all orders with customer names
select o.order_id,c.name as customer_name, o.order_date 
from orders o
join customers c on o.customer_id=c.customer_id
;

-- Show product names with quantities for each order
select p.product_id,p.product_name,sum(oi.quantity) as Quantity
from products p
join order_items oi on p.product_id =oi.product_id
group by p.product_id
order by Quantity desc;

-- Full order details with customer and product info

select o.order_id, c.name, p.product_name, oi.quantity, oi.unit_price
from orders o 
join customers c on o.customer_id=c.customer_id
join order_items oi on o.order_id=oi.order_id
join products p on oi.product_id=p.product_id;

-- Total quantity sold per product

select p.product_id,p.product_name,sum(oi.quantity) as product_sold
from products p
join order_items oi on p.product_id=oi.product_id
group by p.product_id
; 

-- Total revenue per customer
select c.name,sum(oi.quantity*oi.unit_price) as revenue_per_customer
from customers c
join orders o on c.customer_id=o.customer_id
join order_items oi on o.order_id=oi.order_id
group by c.name
order by revenue_per_customer;

-- Revenue per product category
create view Revenue_per_product as 
select p.category,sum(oi.quantity*oi.unit_price) as revenue_per_category
from products p
join order_items oi on p.product_id=oi.product_id
group by p.category;

-- List customers who haven’t placed any orders

select* 
from customers c
left join orders o on c.customer_id=o.customer_id
where o.order_id is Null;

-- Products that have never been sold

SELECT p.product_name
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;


-- Top 3 best-selling products

create view TopSellingProduct as
select p.product_name,sum(oi.quantity) as total
from products p
join order_items oi on p.product_id=oi.product_id
group by product_name
order by total desc
limit 3;

-- Monthly sales trend
create view MonthlyRevenue as 
select date_format(o.order_date,'%y-%m') as months,sum(o.total_amount) as monthly_revenue
from orders o
group by months
order by months;

-- City-wise revenue report
Create view  cityRevenue as
select c.city,sum(o.total_amount) as cityPerRevenue
from customers c
join orders o on c.customer_id=o.customer_id
group by c.city
order by cityPerRevenue;

-- Customers who purchased from multiple categories

select c.name
from customers c
join orders o on c.customer_id=o.customer_id
join order_items oi on o.order_id=oi.order_id
join products p on oi.product_id =p.product_id
group by c.name
having count( distinct p.category) >1;

-- Rank Top Customers by Total Spend

select c.name,
sum(total_amount) as amountSpent,
rank() over(order by sum(total_amount) desc ) as spending_rank
from customers c
join orders o on c.customer_id=o.customer_id
group by c.name;

-- Top 3 Best-Selling Products by Quantity (Using ROW_NUMBER)

select p.product_name,sum(oi.quantity) as Quantity,
rank() over(order by sum(oi.quantity) desc) as Quantity_rank
from products p
join order_items oi on p.product_id=oi.product_id
group by p.product_name
limit 3; 

-- View: Customer Purchase Summary

create view CustomerPurchaseSummary as
select 
c.customer_id,c.name, count(distinct o.order_id) as noOfOrder,sum(o.total_amount) as TotalAmount
from
customers c
join orders o on c.customer_id=o.customer_id
group by c.customer_id,c.name;

-- Products That Have Never Been Ordered

select product_name
from products 
where product_id not in (
select product_id from
order_items
);
-- Customers Who Ordered More Than 3 Times
select name 
from customers
where customer_id in(

select customer_id from 
orders
group by customer_id
having count(customer_id)>3  
);


select c.customer_id,c.name,p.product_name,p.category,city
from customers c
join orders o on c.customer_id=o.customer_id
join order_items oi on o.order_id= oi.order_id
join products p  on oi.product_id =p.product_id
where c.city='Mumbai'and p.category='sports';

select * from monthlyrevenue;

















