--1)
SELECT
	c.customerName,
	SUM(od.quantityOrdered * od.priceEach)
FROM
	Customers c, Orders o, OrderDetails od
Where
    c.customerNumber = o.customerNumber and o.orderNumber = od.orderNumber
GROUP BY
	c.customerName;
	
	
	
--2)
SELECT 
    p.productName,
    SUM(od.quantityOrdered) AS totalSales
FROM 
    Products p, OrderDetails od
WHERE
    p.productCode = od.productCode
GROUP BY 
    p.productName
ORDER BY 
    totalSales DESC
LIMIT 5;

--3) Delete all orders that are marked as pending and were placed more than one month prior to the current date. (Hint: Use 2 queries instead of 1, use CURDATE and INTERVAL)

-- Delete related order details first

DELETE FROM OrderDetails
WHERE orderNumber IN (
    SELECT orderNumber
    FROM Orders
    WHERE orderstatus = 'Pending' AND orderDate < CURDATE() - INTERVAL 1 MONTH
);

-- Delete the orders
DELETE FROM Orders
WHERE orderstatus = 'Pending' AND orderDate < CURDATE() - INTERVAL 1 MONTH;

--4) Retrieve the names of customers who have never ordered

SELECT 
    c.customerName
FROM 
    Customers c
LEFT JOIN 
    Orders o ON c.customerNumber = o.customerNumber
WHERE 
    o.orderNumber IS NULL;


-- 5. Establish a virtual table that displays comprehensive details of all orders that have been shipped. You only need to show the order number, order date, shipped date, customername, and employee number.
CREATE VIEW ShippedOrdersDetails AS
SELECT 
    o.orderNumber,
    o.orderDate,
    o.shippedDate,
    c.customerName,
    e.employeeNumber
FROM 
    Orders o
JOIN 
    Customers c ON o.customerNumber = c.customerNumber
JOIN 
    Employees e ON c.salesRepEmployeeNumber = e.employeeNumber
WHERE 
    o.orderStatus = 'Shipped';



-- 6. Show each employee’s ID and name, paired with the specific customers assigned to them. Only display employees who have been assigned customers, and customers who have employees assigned to them.
SELECT 
    e.employeeNumber,
    CONCAT(e.firstName, ' ', e.lastName) AS employeeName,
    c.customerNumber,
    c.customerName
FROM 
    Employees e, Customers c
WHERE
    e.employeeNumber = c.salesRepEmployeeNumber;


-- 7. Retrieve the names of the products that have a higher stock quantity than the average stock level within their respective product categories.
SELECT 
    productName
FROM 
    Products p
WHERE 
    quantityInStock > (
        SELECT 
            AVG(quantityInStock)
        FROM 
            Products
        WHERE 
            productLine = p.productLine
    );


-- 8. Establish a virtual table that showcases the payment history of customers. Display the name of the customers, the order number, the date of payment, and the amount paid
CREATE VIEW PaymentHistory AS
SELECT 
    c.customerName,
    p.paymentDate,
    p.amount
FROM 
    Payments p, Customers c
WHERE
    p.customerNumber = c.customerNumber;
    
    