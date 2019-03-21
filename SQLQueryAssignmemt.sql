--Returning the count of customers in the database
SELECT * 
FROM [Customers]

-- Orders
SELECT * 
FROM [Order Details]

--Product
SELECT *
FROM [Suppliers]



--Returning the count of orders placed in the month of July 1996
SELECT 
	Customers.ContactName
FROM [Customers]
WHERE
	Customers.CustomerID IN (
		SELECT Orders.CustomerID
		FROM [Orders]
		WHERE year(Orders.OrderDate)=1996
		);

--Returning the count that shows who placed orders number 10249
SELECT
	Customers.CustomerID
FROM [Customers]
WHERE
Customers.CustomerID = (
		SELECT Orders.CustomerID
		FROM Orders
		WHERE [Orders].OrderID = 10249
		);

--Returning the count that shows what products were on order 10249

SELECT 
	[Order Details].ProductID
FROM 
	[Order Details]
WHERE 
	[Order Details].OrderID = 10249
		

--Returning the count that shows ProductID, ProductName, SupplierID, CategoryName, UnitPrice, UnitsInStock
SELECT 
	ProductID, ProductName, SupplierID, CategoryName, UnitPrice, UnitsInStock
FROM Products, Categories

--A stored procedure that will allow you to create a new customer
GO
CREATE PROCEDURE AddCustomer 
AS 
SELECT * FROM Customers;

GO
EXEC AddCustomer
--A stored procedure that allows you to return information based on a order data range
GO
IF EXISTS (SELECT * FROM sys.objects WHERE name='Date_Order' AND OBJECTPROPERTY(object_id, 'IsProcedure') = 1)
DROP PROCEDURE Date_Order

GO

CREATE PROCEDURE Date_Order
AS

SELECT Orders.OrderID, Orders.OrderDate, [Order Details].Quantity, [Order Details].Discount, Products.UnitPrice, Customers.CustomerID, Customers.CompanyName, Customers.ContactName, Products.ProductID, Products.ProductName, concat(Employees.FirstName,' ', Employees.LastName) as EmployeeName
FROM Orders
LEFT JOIN Products ON Orders.EmployeeID = Products.ProductID
LEFT JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID
LEFT JOIN Customers ON Customers.CustomerID = Orders.CustomerID
LEFT JOIN Employees ON Employees.EmployeeID = Orders.EmployeeID
ORDER BY Orders.OrderDate DESC;

GO
EXEC Date_Order