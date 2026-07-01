-- TASK 1: create an ER Digram for the amazon fresh database to understand the relationships between tables

-- TASK 2: Identify the primery keys and foreign keys for each tablesand describe their relationships.alter

-- TASK 3: write a query to: retrieve all customers from a specific city
select name,city from amazon.customers
where city = "lake lisa";

select productname,category from amazon.products
where category ="fruits";

-- TASK 4 : Write DDL statements to recreate the customers table with the following constraints: 
-- CustomerID as the primary key
alter table amazon.customers
add primary key (CustomerId);

-- ensure age cannot be null and must be grater than 18
select Age from amazon.customers
where age >18;

-- Add a unique constraint for Name.
update amazon.customers
set age = 19
where age = 18;
alter table amazon.customers
add constraint chk_age check (age > 18);

-- Task 5: Insert 3 new rows into the Products table using INSERT statements.
insert into amazon.products values
("4","table","wood","sub-wood",111,123,"100"),
("5","fan","electrnoices","sub-electrnocies",222,234,"101"),
("6","car","motor","sub-motor",333,345,"102");
select * from amazon.products;

-- Task 6: Update the stock quantity of a product where ProductID matches a specific ID.
update amazon.products
set stockQuantity = 777
where productName= "table";

-- Task 7: Delete a supplier from the Suppliers table where their city matches a specific value.
delete from amazon.suppliers
where city ="NorthKyle";
select * from amazon.suppliers;

-- Task 8: Use SQL constraints to:
-- Add a CHECK constraint to ensure that ratings in the Reviews table are between 1 and 5.
alter table amazon.reviews
add constraint check (Rating between 1 and 5);

-- Add a DEFAULT constraint for the PrimeMember column in the Customers table (default value: "No").
alter table amazon.customers
alter primeMember set default "No";

-- Task 9: Write queries using:
--  WHERE clause to find orders placed after 2024-01-01.
select * from amazon.orders
where OrderDate > "2024-01-01"; 

-- HAVING clause to list products with average ratings greater than 4.
select productid,avg(rating) from amazon.reviews
group by productid
having AVG(rating)> 4;


-- GROUP BY and ORDER BY clauses to rank products by total sales.
select p.ProductName,p.ProductID,sum(o.Quantity * o.UnitPrice - o.Discount) as total_sales from amazon.order_details as o
join amazon.products as p
on p.ProductID = o.ProductID
group by p.ProductName,p.ProductID
order by total_sales desc;

-- TASK 10 : Amazon Fresh wants to identify top customers based on their total spending. We will:
-- 1. Calculate each customer's total spending.
select c.Namess,o.CustomerId,sum(o.OrderAmount + o.DeliveryFee - DiscountApplied) as total_spending from amazon.orders as o
join amazon.customers as c
on c.CustomerID = o.CustomerID
group by c.Namess,o.CustomerID
Order by total_spending desc;

-- 2. Rank customers based on their spending.
select c.Namess,o.CustomerId,sum(o.OrderAmount + o.Deliveryfee - DiscountApplied) as total_spendings,
dense_rank() over(order by sum(o.OrderAmount + o.Deliveryfee - DiscountApplied)desc) as rankk from amazon.orders as o
join amazon.customers as c
on c.CustomerID = o.CustomerID
group by c.Namess,o.CustomerID;

 
-- 3. Identify customers who have spent more than ₹5,000.
select c.Name,o.CustomerId,sum(o.OrderAmount + o.DeliveryFee - DiscountApplied) as total_spending from amazon.orders as o
join amazon.customers as c
on c.CustomerID =o.CustomerID
group by c.Name,o.CustomerID
having total_spending > 5000
order by total_spending asc;

-- TASK 11 : Complex Aggregations and Joins
-- Use SQL to:
-- Join the Orders and OrderDetails tables to calculate total revenue per order.
select * from amazon.Orders;
select * from amazon.Order_Details;
select o.OrderId,sum(o2.Quantity * o2.UnitPrice - o2.Discount) as revenue from amazon.orders as o
join amazon.order_details as o2
on o.OrderId = o2.OrderID
group by o.OrderID
order by revenue desc;

-- Identify customers who placed the most orders in a specific time period.
select  * from amazon.orders;
select c.Namess,c.CustomerId,o.OrderDate,count(o.OrderId) as total_orders from amazon.Orders as o
join amazon.customers as c
on c.CustomerID =o.CustomerID
where OrderDate ="2025-01-01"
group by c.Namess,c.CustomerID
order by total_orders desc;

-- Find the supplier with the most products in stock.
select * from amazon.suppliers;
select * from amazon.products;

select SupplierId,sum(StockQuantity) as total from amazon.products
group by SupplierID
order by total desc
limit 1;

-- TASK 12 : Normalization
-- Normalize the Products table to 3NF:
-- Separate product categories and subcategories into a new table.select 
create table amazon.categories(ProductID varchar(50),Category text,PricePerUnit int,StockQuantity int,Supplier_Id Varchar(50));
INSERT INTO amazon.categories(ProductID,Category,PricePerUnit,StockQuantity,Supplier_Id )VALUES
("2aa28375-c563-41b5-aa33-8e2c2e0f4db9","Fruits","207","290","0658c953-98c4-4d00-bf29-4fbfe4aca4cd"),
("e9282403-e234-4e35-a711-50acb03bbecc"	,"Snacks","905","259","cb890936-8142-4fa3-ac60-2ecba78f8aa8"),
("d79d1b95-ecdf-4810-aea0-45e9bd10627d","Fruits","111","26","455b7097-b656-49b8-9cf2-a98d71d3ba88"),
("05765892-c750-44cc-96e2-31fa53d42cb2","Vegetables","887","296","a2ed0ef5-a6c8-4b51-ac6f-6209edf45a02"),
("3bfb746e-f1e6-4946-a314-7d9119fd950d","Bakery","961","127","16c44a77-d01f-4154-a7b7-1f5b5dee4255"),
("11dc08ec-ef6f-43d0-abaa-414a9c336956","Vegetables","50","19","92bedb68-2b59-4cb3-9520-fec1256dfa04"),
("e5bdb329-60d3-4673-8782-1ab101f98187","Dairy","604","126","20e7f27c-8f08-46b3-950f-2c0bbf56722d"),
("9747fd32-5076-46c3-90b4-5f404b86b219","Fruits","6","306","eafcc3e7-83b3-4392-b278-1cc6efc9a2a2"),
("9d82e469-12e6-4fd6-9a41-837ac63c1d2b","Dairy","131","322","1d344858-3396-49cf-be1a-6fe391841b4b"),
("e4c3f640-fa46-4510-8f45-32df79fcaec4","Meat","169","451","1acc6cf8-0309-4b0c-88d2-8d58807168eb"),
("b8a16df8-38c0-462d-888d-9c5e42704267","Vegetables","766","265","36f49379-ba01-499f-be3c-ddfd8a6eda41"),
("37cc1e52-274c-4fd2-bc0e-d0506c57973b","Meat","302","326","561d6fbf-83fd-40b1-8310-4e546ae02e94");
 
create table amazon.sub_categories(ProductID varchar(50),sub_Category text,PricePerUnit int,StockQuantity int,Supplier_Id Varchar(50));
INSERT INTO amazon.sub_categories(ProductID,sub_Category,PricePerUnit,StockQuantity,Supplier_Id )VALUES
("2aa28375-c563-41b5-aa33-8e2c2e0f4db9","sub-Fruits-1","207","290","0658c953-98c4-4d00-bf29-4fbfe4aca4cd"),
("e9282403-e234-4e35-a711-50acb03bbecc"	,"sub-Snacks-1","905","259","cb890936-8142-4fa3-ac60-2ecba78f8aa8"),
("d79d1b95-ecdf-4810-aea0-45e9bd10627d","sub-Fruits-2","111","26","455b7097-b656-49b8-9cf2-a98d71d3ba88"),
("05765892-c750-44cc-96e2-31fa53d42cb2","sub-Vegetables-1","887","296","a2ed0ef5-a6c8-4b51-ac6f-6209edf45a02"),
("3bfb746e-f1e6-4946-a314-7d9119fd950d","sub-Bakery-1","961","127","16c44a77-d01f-4154-a7b7-1f5b5dee4255"),
("11dc08ec-ef6f-43d0-abaa-414a9c336956","sub-Vegetables-2","50","19","92bedb68-2b59-4cb3-9520-fec1256dfa04"),
("e5bdb329-60d3-4673-8782-1ab101f98187","sub-Dairy-1","604","126","20e7f27c-8f08-46b3-950f-2c0bbf56722d") ,
("9747fd32-5076-46c3-90b4-5f404b86b219","sub-Fruits-3","6","306","eafcc3e7-83b3-4392-b278-1cc6efc9a2a2"),
("9d82e469-12e6-4fd6-9a41-837ac63c1d2b","sub-Dairy-2","131","322","1d344858-3396-49cf-be1a-6fe391841b4b"),
("e4c3f640-fa46-4510-8f45-32df79fcaec4","sub-Meat-1","169","451","1acc6cf8-0309-4b0c-88d2-8d58807168eb"),
("b8a16df8-38c0-462d-888d-9c5e42704267","sub-Vegetables-3","766","265","36f49379-ba01-499f-be3c-ddfd8a6eda41"),
("37cc1e52-274c-4fd2-bc0e-d0506c57973b","sub-Meat-2","302","326","561d6fbf-83fd-40b1-8310-4e546ae02e");

-- TASK 13: Write a subquery to:
-- Identify the top 3 products based on sales revenue.
select * from amazon.order_details;
select p.ProductId,p.ProductName,sum(o.Quantity * o.UnitPrice - o.Discount) as total_revenue from amazon.order_details as o
join amazon.products as p
on p.ProductId = o.ProductId
group by p.ProductID,p.ProductName
order by total_revenue desc
limit 3;

-- Find customers who haven’t placed any orders yet.
select * from amazon.customers;
select *  from amazon.orders;

select c.Namess,o.CustomerId from amazon.orders as o
join amazon.customers as c
on c.CustomerID = o.CustomerID
where o.CustomerID is null;

-- TASK 14: Provide actionable insights:
-- Which cities have the highest concentration of Prime members?
select City,count(PrimeMember) from amazon.customers
where PrimeMember ="Yes"
group by City
order by count(Primemember) desc
limit 1;
-- What are the top 3 most frequently ordered categories?
select Category,count(Category) as total_quantity_ordered from amazon.products
group by Category
order by total_quantity_ordered desc
limit 1 ;







