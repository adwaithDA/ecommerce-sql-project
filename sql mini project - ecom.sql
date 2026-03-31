CREATE DATABASE ecomdb;
USE ecomdb;

CREATE TABLE customers (
    customerid INT PRIMARY KEY,
    customername VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    signupdate DATE
);
CREATE TABLE products (
    productid INT PRIMARY KEY,
    productname VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);
CREATE TABLE orders (
    orderid INT PRIMARY KEY,
    customerid INT,
    productid INT,
    orderdate DATE,
    quantity INT,
    totalamount DECIMAL(10,2),
    FOREIGN KEY (customerid) REFERENCES customers(customerid),
    FOREIGN KEY (productid) REFERENCES products(productid)
);
CREATE TABLE payments (
    paymentid INT PRIMARY KEY,
    orderid INT,
    paymentdate DATE,
    paymentmethod VARCHAR(50),
    paymentstatus VARCHAR(30),
    FOREIGN KEY (orderid) REFERENCES orders(orderid)
);

INSERT INTO customers VALUES
(1, 'Rahul Sharma', 'rahul@gmail.com', 'Delhi', '2023-01-15'),
(2, 'Ananya Gupta', 'ananya@gmail.com', 'Mumbai', '2023-02-10'),
(3, 'Arjun Nair', 'arjun@gmail.com', 'Kochi', '2023-03-05'),
(4, 'Sneha Iyer', 'sneha@gmail.com', 'Chennai', '2023-04-01'),
(5, 'Vikram Singh', 'vikram@gmail.com', 'Bangalore', '2023-04-20');

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 60000),
(102, 'Smartphone', 'Electronics', 30000),
(103, 'Headphones', 'Accessories', 3000),
(104, 'Office Chair', 'Furniture', 8000),
(105, 'Smart Watch', 'Wearables', 12000);

INSERT INTO orders VALUES
(1001, 1, 101, '2023-05-01', 1, 60000),
(1002, 2, 102, '2023-05-03', 1, 30000),
(1003, 3, 103, '2023-05-05', 2, 6000),
(1004, 4, 104, '2023-05-06', 1, 8000),
(1005, 1, 105, '2023-05-08', 1, 12000),
(1006, 5, 102, '2023-05-10', 1, 30000);

INSERT INTO payments VALUES
(5001, 1001, '2023-05-01', 'Credit Card', 'Completed'),
(5002, 1002, '2023-05-03', 'UPI', 'Completed'),
(5003, 1003, '2023-05-05', 'Debit Card', 'Completed'),
(5004, 1004, '2023-05-06', 'Net Banking', 'Failed'),
(5005, 1005, '2023-05-08', 'UPI', 'Completed'),
(5006, 1006, '2023-05-10', 'Credit Card', 'Completed');

WITH customerrevenue AS (SELECT c.customerid,c.customername,SUM(o.totalamount) AS totalrevenue FROM customers c
JOIN orders o ON c.customerid = o.customerid GROUP BY c.customerid, c.customername)
SELECT *FROM (SELECT *,RANK() OVER (ORDER BY totalrevenue DESC) AS revenuerank FROM customerrevenue) ranked
WHERE revenuerank <= 3;

-- top 3 customers
select c.customername, sum(o.totalamount) as totalrevenue from customers c
join orders o on c.customerid=o.customerid
group by customername order by totalrevenue desc limit 3;

-- monthly sales trend
select month(orderdate) as month, sum(totalamount) as monthlysales from orders
group by month(orderdate) order by monthlysales;

-- count orders per cutomer
select customerid, count(orderid) as totalorders from orders
group by customerid;

-- one time vs repeat customers
SELECT CASE WHEN COUNT(orderid) = 1 THEN 'One-Time'ELSE 'Repeat'END AS customertype,COUNT(DISTINCT customerid) AS totalcustomers FROM orders
GROUP BY customerid; 
 
-- product wise profit
select p.productname, sum(o.totalamount) as totalsales, sum(o.totalamount)*0.20 as estimateprofit from products p
join orders o on p.productid=o.productid
group by p.productid order by estimateprofit desc;

-- All Products in Electronics Category
select *from products where category='Electronics';

-- Show Orders Above ₹20,000
select *from orders where totalamount>20000;

-- count total customers
SELECT COUNT(*) AS totalcustomers
FROM customers;

-- total revenue
select sum(totalamount) as totalrevenue from orders;

-- avg price of products
SELECT AVG(price) AS avgprice
FROM products;

-- highest order amount
SELECT MAX(totalamount) AS highestorder
FROM orders;

-- lowest order amount
SELECT MIN(price) AS cheapestproduct
FROM products;

-- Customer Name with Their Orders
select c.customername, o.orderid, o.totalamount from customers c
join orders o on c.customerid=o.customerid;

-- products and quantity
select p.productname, o.quantity from products p
join orders o on p.productid=o.productid;

-- Orders with Payment Status
SELECT o.orderid, p.paymentstatus FROM orders o 
JOIN payments p ON o.orderid = p.orderid;

-- total sales per customer
SELECT customerid, SUM(totalamount) AS totalspent FROM orders
GROUP BY customerid;

-- Total Sales per Product
SELECT productid, SUM(totalamount) AS totalsales FROM orders
GROUP BY productid;

-- Count Orders per City
SELECT c.city, COUNT(o.orderid) AS totalorders FROM customers c
JOIN orders o ON c.customerid = o.customerid GROUP BY c.city;