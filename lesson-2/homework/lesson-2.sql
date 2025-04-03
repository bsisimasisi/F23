CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary DECIMAL(10,2)
);


-- Single-row insert
INSERT INTO Employees (EmpID, Name, Salary) VALUES (1, 'John Doe', 5000.00);

-- Multiple-row insert
INSERT INTO Employees (EmpID, Name, Salary) VALUES
(2, 'Jane Smith', 6000.00),
(3, 'Mark Johnson', 5500.00);


UPDATE Employees 
SET Salary = 5200.00 
WHERE EmpID = 1;


DELETE FROM Employees WHERE EmpID = 2;


-- Create a test table
CREATE TABLE TestTable (
    ID INT PRIMARY KEY,
    Value VARCHAR(50)
);

-- Insert sample records
INSERT INTO TestTable (ID, Value) VALUES (1, 'A'), (2, 'B'), (3, 'C');

-- DELETE: Removes specific records
DELETE FROM TestTable WHERE ID = 1;

-- TRUNCATE: Removes all records but keeps the table structure
TRUNCATE TABLE TestTable;

-- DROP: Completely removes the table
DROP TABLE TestTable;


ALTER TABLE Employees  
ALTER COLUMN Name VARCHAR(100);


ALTER TABLE Employees  
ADD Department VARCHAR(50);


ALTER TABLE Employees  
ALTER COLUMN Salary FLOAT;


CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);


Truncate table Employees;


INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT DISTINCT EmpID, Department FROM Employees;

UPDATE Employees  
SET Department = 'Management'  
WHERE Salary > 5000;


TRUNCATE TABLE Employees;


ALTER TABLE Employees  
DROP COLUMN Department;


EXEC sp_rename 'Employees', 'StaffMembers';


DROP TABLE Departments;


CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);


ALTER TABLE Products  
ADD CONSTRAINT chk_price CHECK (Price > 0);


ALTER TABLE Products  
ADD StockQuantity INT DEFAULT 50;

EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';


INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, StockQuantity) VALUES
(1, 'Laptop', 'Electronics', 1200.99, 30),
(2, 'Smartphone', 'Electronics', 800.50, 50),
(3, 'Chair', 'Furniture', 150.75, 20),
(4, 'Desk', 'Furniture', 300.40, 10),
(5, 'Headphones', 'Accessories', 100.00, 40);

SELECT * INTO Products_Backup  
FROM Products;

EXEC sp_rename 'Products', 'Inventory';

ALTER TABLE Inventory  
ALTER COLUMN Price FLOAT;

ALTER TABLE Inventory  
ADD ProductCode INT IDENTITY(1000,5) PRIMARY KEY;






