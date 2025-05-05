---question one

-- First approach: Using string splitting
INSERT INTO OrderDetails_1NF (OrderID, CustomerName, Product)
SELECT 
    OrderID,
    CustomerName,
    TRIM(UNNEST(STRING_TO_ARRAY(Products, ','))) AS Product
FROM ProductDetail;

-- Second approach: Explicit listing (if you know all possible products)
INSERT INTO OrderDetails_1NF (OrderID, CustomerName, Product)
VALUES 
    (101, 'John Doe', 'Laptop'),
    (101, 'John Doe', 'Mouse'),
    (102, 'Jane Smith', 'Tablet'),
    (102, 'Jane Smith', 'Keyboard'),
    (102, 'Jane Smith', 'Mouse'),
    (103, 'Emily Clark', 'Phone');

--question two
-- Step 1: Create normalized tables
CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    CustomerName VARCHAR(100) UNIQUE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Products (
    ProductID SERIAL PRIMARY KEY,
    ProductName VARCHAR(50) UNIQUE
);

CREATE TABLE OrderItems (
    OrderItemID SERIAL PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Step 2: Populate the tables
INSERT INTO Customers (CustomerName)
SELECT DISTINCT CustomerName FROM OrderDetails;

INSERT INTO Orders (OrderID, CustomerID)
SELECT DISTINCT o.OrderID, c.CustomerID
FROM OrderDetails o
JOIN Customers c ON o.CustomerName = c.CustomerName;

INSERT INTO Products (ProductName)
SELECT DISTINCT Product FROM OrderDetails;

INSERT INTO OrderItems (OrderID, ProductID, Quantity)
SELECT o.OrderID, p.ProductID, od.Quantity
FROM OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Products p ON od.Product = p.ProductName;
