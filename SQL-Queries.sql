-- 1. Total Revenue and Number of Orders
WITH OrderRevenue AS (
    SELECT 
        OrderID,
        SUM(Quantity * UnitPrice) AS Order_Total
    FROM RetailData
    GROUP BY OrderID
)
SELECT 
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Order_Total), 2) AS Total_Revenue
FROM OrderRevenue;

-- 2. Average Order Value (AOV)
WITH OrderRevenue AS (
    SELECT 
        OrderID,
        SUM(Quantity * UnitPrice) AS Order_Total
    FROM RetailData
    GROUP BY OrderID
)
SELECT 
    ROUND(AVG(Order_Total), 2) AS Average_Order_Value
FROM OrderRevenue;

-- 3. Monthly Revenue with YoY Comparison
WITH MonthlyRevenue AS (
    SELECT 
        DATE_FORMAT(OrderDate, '%Y-%m') AS YearMonth,
        YEAR(OrderDate) AS Year,
        MONTH(OrderDate) AS Month,
        SUM(Quantity * UnitPrice) AS Revenue
    FROM RetailData
    GROUP BY YearMonth, Year, Month
)
SELECT 
    Year,
    Month,
    Revenue AS Monthly_Revenue
FROM MonthlyRevenue
ORDER BY Year, Month;

-- 4. Top 5 Products by Revenue
WITH ProductRevenue AS (
    SELECT 
        ProductName,
        SUM(Quantity * UnitPrice) AS Revenue
    FROM RetailData
    GROUP BY ProductName
)
SELECT 
    ProductName,
    Revenue
FROM ProductRevenue
ORDER BY Revenue DESC
LIMIT 5;

-- 5. Top 5 Customers by Spend
WITH CustomerSpend AS (
    SELECT 
        CustomerName,
        SUM(Quantity * UnitPrice) AS Total_Spend
    FROM RetailData
    GROUP BY CustomerName
)
SELECT 
    CustomerName,
    Total_Spend
FROM CustomerSpend
ORDER BY Total_Spend DESC
LIMIT 5;

-- 6. Most Frequent Customers (By Orders)
WITH CustomerOrders AS (
    SELECT 
        CustomerName,
        COUNT(DISTINCT OrderID) AS Orders
    FROM RetailData
    GROUP BY CustomerName
)
SELECT 
    CustomerName,
    Orders
FROM CustomerOrders
ORDER BY Orders DESC
LIMIT 5;

-- 7. Yearly Revenue Growth
WITH YearlyRevenue AS (
    SELECT 
        YEAR(OrderDate) AS Year,
        SUM(Quantity * UnitPrice) AS Revenue
    FROM RetailData
    GROUP BY YEAR(OrderDate)
)
SELECT 
    Year,
    Revenue,
    LAG(Revenue) OVER (ORDER BY Year) AS Previous_Year_Revenue,
    ROUND((Revenue - LAG(Revenue) OVER (ORDER BY Year)) / LAG(Revenue) OVER (ORDER BY Year) * 100, 2) AS YoY_Growth_Percentage
FROM YearlyRevenue;
