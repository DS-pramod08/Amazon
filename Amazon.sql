select * from [dbo].[customers_large];
select * from [dbo].[order_details_large];
select * from [dbo].[orders_large];
select * from [dbo].[products_large];


-- o	Display all rows and columns from the customer’s table.
select * from [dbo].[customers_large];

-- o	List all products with their prices from the products table.
select [ProductName],[Price] from [dbo].[products_large];

-- o	Find all customers from "New York."
select * from [dbo].[customers_large] where [City] = 'New York';

-- o	Show all products in the "Electronics" category priced above $500
select * from [dbo].[products_large] where [Category] = 'Electronics' and [Price] > 500;

-- o	Retrieve the list of orders sorted by OrderDate in descending order.
select * from [dbo].[orders_large] order by [OrderDate] desc;

-- o	List the products sorted by price (highest to lowest).
select * from [dbo].[products_large] order by [Price] desc;

-- o	Count the total number of customers.
select count([CustomerID])as Number_of_customers from [dbo].[customers_large];

-- o	Find the average price of products in the products table.
select avg([Price]) as Avg_Price_of_Product from [dbo].[products_large];

-- o	Find the total stock available for each product category.
select [Category],sum([Stock]) as total_stocks from [dbo].[products_large]
group by [Category];

-- o	Count the number of orders placed by each customer.
select [CustomerID],count(*) as Number_of_orders from [dbo].[orders_large]
group by [CustomerID];

-- o	Retrieve a list of orders with customer details (e.g., FirstName, LastName).
select
	o.[OrderID],
	c.[FirstName],
	c.[LastName],
	o.[TotalAmount] 
from [dbo].[customers_large] c
join [dbo].[orders_large] o
on c.[CustomerID] = o.[CustomerID];

-- o	Show all OrderDetails with the corresponding product name and price.
select 
	o.[OrderDetailID],
	o.[OrderID],
	p.[ProductName],
	p.[Price]
from [dbo].[order_details_large] o
join [dbo].[products_large] p
on o.[ProductID] = p.[ProductID];

-- o	Find all orders placed by customers from "Los Angeles."
select 
	o.[OrderID],
	c.[FirstName],
	c.[LastName],
	o.[TotalAmount]
from [dbo].[customers_large] c
join [dbo].[orders_large] o
on c.[CustomerID] = o.[CustomerID]
where c.[City] = 'Los Angeles';

-- o	Show all products ordered in "2023" along with the order details.
select 
	od.[OrderDetailID],
	p.[ProductName],
	p.[Price],
	o.[OrderDate]
from [dbo].[order_details_large] od
join [dbo].[products_large] p 
on od.[ProductID] = p.[ProductID]
join [dbo].[orders_large] o
on od.[OrderID] = o.[OrderID]
where o.[OrderDate] like '%2023%';

-- o	Find customers who have placed orders worth more than $1,000.
select * from [dbo].[customers_large]
where [CustomerID]
in (select [CustomerID] from [dbo].[orders_large] where [TotalAmount] > 1000);

-- o	List products that have never been ordered.
select * from [dbo].[products_large]
where [ProductID] 
not in (select distinct([OrderID]) from [dbo].[order_details_large]);

-- o	Calculate the total revenue generated from each product.
select 
	p.[ProductName],
	sum(od.[Quantity] * od.[Price]) as total_revenue
from [dbo].[products_large] p
join [dbo].[order_details_large] od
on p.[ProductID] = od.[ProductID]
group by [ProductName];

-- o	Find the customer who placed the highest number of orders.
select top 1 [CustomerID],count(*) as Ordercount from [dbo].[orders_large]
group by [CustomerID]
order by Ordercount desc;

-- o	Rank products based on their price within each category.
(select [ProductName],[Category],[Price],
rank() over(partition by [Category] order by [Price] desc) as prd_rank 
from [dbo].[products_large]);

-- o	Find the cumulative revenue generated from all orders sorted by date.
(select [OrderID],sum([TotalAmount]) over(order by [OrderDate] desc) as cumulative_revenue
from [dbo].[orders_large]);

-- o	Find customers who have ordered products from more than two categories.
select 
	c.[CustomerID],
	COUNT(distinct p.[Category])
from [dbo].[orders_large] o 
join [dbo].[order_details_large] od on o.[OrderID] = od.[OrderID]
join [dbo].[products_large] p on p.[ProductID] = od.[ProductID]
join [dbo].[customers_large] c on c.[CustomerID] = o.[CustomerID]
group by c.[CustomerID]
Having COUNT(distinct p.[Category]) > 2;

-- o	Retrieve a list of customers who have never placed an order.
select * from [dbo].[customers_large] 
where [CustomerID] not in (select distinct ([CustomerID]) from [dbo].[orders_large]);

-- o	Create a CTE to calculate the total sales for each product and find products with total sales exceeding $10,000.
with product_sales as 
(select [ProductID],sum([Quantity]*[Price]) as total_sales 
from [dbo].[order_details_large]
group by [ProductID])
select * from product_sales where total_sales > 10000;

-- o	Use a CTE to find customers who have placed more than 3 orders in 2023.
 with order_calculate as
 (select [CustomerID],count(*) as order_count
 from [dbo].[orders_large]
 where [OrderDate] like '%2023%'
 group by [CustomerID])
 select * from order_calculate where order_count >3;

-- o	Increase the price of all products in the "Accessories" category by 10%.
update [dbo].[products_large]
set [Price] = [Price] * 1.10
where [Category] = 'Accessories';

-- in Date column to remove 00.00.00.000 used this. (Converted data type 'Datetime to Date')
alter table [dbo].[orders_large]
alter column OrderDate Date;

-- o	Delete all orders placed before "2023-01-02."
delete [dbo].[orders_large]
where [OrderDate] < '2023-01-02';

