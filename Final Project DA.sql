Create database dmart;
-- 1.Create Tables Based on ERD
-- 2. Import CSVs into SQL
select  * from dmart.brands;
select * from dmart.categories;
select * from dmart.customers;
select * from dmart.order_items;
select * from dmart.orders;
select * from dmart.products;
select * from dmart.staffs;
select * from dmart.stocks;
select * from dmart.stores;

-- 3. Inner Join for Order Details
select o.*,ot.*,p.* from  dmart.orders as o
join dmart.order_items as ot
on o.order_id=ot.order_id
join dmart.products as p
on ot.product_id=p.product_id;


-- 4. Total Sales by Store
select o.store_id,sum(ot.Total_sales) as Total_sales from dmart.order_items as ot
join dmart.orders as o
on o.order_id=ot.order_id
group by o.store_id;


-- 5. Top 5 Selling Products
select p.product_id,p.product_name,count(ot.Quantity) as total_products from dmart.order_items as ot
join dmart.products as p
on p.product_id=ot.product_id
group by p.product_id,p.product_name
order by total_products desc
limit 5;


-- 6. Customer Purchase Summary
select o.customer_id,c.name,count(ot.order_id)as total_orders_placed,count(ot.item_id) as total_items_purchased,sum(ot.Total_sales) as total_revenue from dmart.order_items as ot
join dmart.orders as o
on o.order_id=ot.order_id
join dmart.customers as c
on c.customer_id=o.customer_id
group by o.customer_id;


-- 7. Segment Customers by Total Spend
select  *,case when p.ListPrice>4000 then "High"
when p.ListPrice>=2000 then "Medium"
when  p.ListPrice<2000 then "Low"
end as spending_brackets from dmart.products as p
join dmart.order_items as ot
on p.category_id=ot.category_id
join dmart.orders as o
on o.order_id=ot.order_id
left join dmart.customers as c
on c.customer_id=o.customer_id;


-- 8. Staff Performance Analysis
select o.staff_id,count(ot.order_id) as Total_orders,sum(ot.Total_sales) as Total_revenue from dmart.order_items as ot
join dmart.orders as o
on o.order_id=ot.order_id
group by O.staff_id
order by Total_revenue desc;


-- 9. Stock Alert Query
select p.product_id,p.product_name,sum(s.Quantity) as total_quantity from dmart.stocks as s
join dmart.products as p
on s.product_id=p.product_id
group by p.product_id,p.product_name
having total_quantity>10
order by total_quantity asc;


-- 10.Create Final Segmentation Table 
create table dmart.customer_segments(Recency varchar(100),Frequency varchar(100),Monetay varchar(100));

select * from dmart.customer_segments; 