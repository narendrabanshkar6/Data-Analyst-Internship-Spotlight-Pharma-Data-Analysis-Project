
--Data analyst InternshIp

--SQL Project, Task 2: Pharma Data Analysis

--Project Abstract

--Welcome to my immersive SQL-driven Pharma Data Analysis project done as
--part of my Data Analyst Internship with PSYLIQ, where the fusion of data science
--and healthcare opens doors to a realm of possibilities! This program is a gateway
--to unlocking the potential of SQL in dissecting and comprehending healthcare
--data. As an MSc grad in Physics passionate about software development and Data
--Analytics, this internship promises an invaluable opportunity to wield my skills
--and broaden my horizons. Throughout this enriching journey, we embark on an
--exploration of a multifaceted dataset encompassing pivotal elements such as
--Pharma_data (Distributor, Customer_Name, City, Country, Latitude, Longitude,
--Channel, Sub-channel, Product Name, Product_Class, Quantity, Price, Sales,
--Month, Year, Name_of_Sales_Rep, Manager, Sales_Team). This comprehensive
--real-world dataset mirrors the intricacies of healthcare data, serving as a robust
--platform to sharpen your SQL prowess.

---Pharma Data Assessment Details-
--1. Retrieve all columns for all records in the dataset.

SELECT * FROM pharmasale;

--2.How many unique countries are represented in the dataset?

SELECT COUNT(DISTINCT Country) AS UniqueCountriesCount 
      FROM pharmasale;

--3. Select the names of all the customers on the 'Retail' channel.

SELECT 
      Customer_name, 
      Channel, 
      Sub_channel 
      FROM pharmasale
WHERE Sub_channel = 'Retail';
	 
--4. Find the total quantity sold for the ' Antibiotics' product class.

SELECT SUM(Quantity) AS TotalQuantitySold
       FROM pharmasale
WHERE Product_class = 'Antibiotics';

--5.List all the distinct months present in the dataset.

SELECT Distinct(Month) 
      FROM pharmasale;

--6. Calculate the total sales for each year.

SELECT Year, SUM(SALES) as total_sales
       FROM pharmasale
GROUP BY Year;

--7. Find the customer with the highest sales value.

SELECT 
      Customer_name,
	  SUM(Sales) as  highest_sales
      FROM pharmasale
GROUP BY Customer_name
ORDER BY highest_sales DESC;

--8. Get the names of all employees who are Sales Reps and are managed by 'James Goodwill'.

SELECT Sales_Rep_name, Manager
      FROM pharmasale
WHERE manager ='James Goodwill';

--9. Retrieve the top 5 cities with the highest sales.

SELECT
      City, 
      SUM(Sales) as Total_sale
      FROM pharmasale
GROUP BY City
ORDER BY Total_sale DESC
LIMIT 5 ;

--10. Calculate the average price of products in each sub-channel.

SELECT 
      Sub_channel,
      AVG(Price) as Average_price
      FROM pharmasale
GROUP BY Sub_channel;

--11. Join the 'Employees' table with the 'Sales' table to
--get the name of the Sales Rep and the corresponding sales records.

SELECT
      sales_rep_name, 
	  SUM(sales) as hightest_sales_record
      FROM pharmasale
GROUP BY sales_rep_name
ORDER BY hightest_sales_record DESC;

--12. Retrieve all sales made by employees from ' Rendsburg ' in the year 2018.

SELECT 
      sales_rep_name, 
	  SUM(sales) as totalsale 
      FROM pharmasale
WHERE City ='Rendsburg' and YEAR ='2018'
GROUP BY sales_rep_name 
ORDER BY totalsale DESC;

--13. Calculate the total sales for each product class, 
--for each month, and order the results by year, month, and product class.

SELECT 
    year AS SaleYear,
    month AS SaleMonth,
    Product_class,
    SUM(sales) AS TotalSales
FROM pharmasale
GROUP BY SaleYear, SaleMonth, Product_class
ORDER BY SaleYear, SaleMonth, Product_class;


--14. Find the top 3 sales reps with the highest sales in 2019.

SELECT sales_rep_name, year, SUM(sales)as hightestsales
      FROM pharmasale
WHERE year = '2019'
GROUP BY sales_rep_name , year
ORDER BY hightestsales DESC
LIMIT 3 ;

--15. Calculate the monthly total sales for each sub-channel, 
--and then calculate the average monthly sales for each sub-channel over the years.

SELECT 
    year AS SaleYear,
    month AS SaleMonth,
    Sub_channel,
    SUM(sales) AS MonthlyTotalSales,
    AVG(SUM(sales)) OVER (PARTITION BY Sub_channel) AS AverageMonthlySales
FROM pharmasale
GROUP BY SaleYear, SaleMonth, Sub_channel
ORDER BY Sub_channel, SaleYear, SaleMonth;

--16. Create a summary report that includes the total sales, average price,
--and total quantity sold for each product class.

SELECT 
    Product_class,
    SUM(sales) AS TotalSales,
    AVG(price) AS AveragePrice,
    SUM(Quantity) AS TotalQuantitySold
FROM pharmasale
GROUP BY Product_class
ORDER BY Product_class;

--17. Find the top 5 customers with the highest sales for each year.

WITH RankedSales AS (
    SELECT 
        Customer_name,
        year AS salesyear,   
        SUM(sales) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY (year) ORDER BY SUM(sales) DESC) AS ranking
    FROM pharmasale
    GROUP BY Customer_name, salesyear
)
SELECT 
    Customer_name,
    salesyear,
    total_sales
FROM RankedSales
WHERE ranking <= 5;

--18. Calculate the year-over-year growth in sales for each country.

WITH SalesCTE AS (
    SELECT 
        Country,
        year AS SalesYear,
        SUM(sales) AS TotalSales
    FROM pharmasale
    GROUP BY Country, salesYear
)
SELECT 
    Country,
    SalesYear,
    TotalSales,
    LAG(TotalSales) OVER (PARTITION BY Country ORDER BY SalesYear) AS PreviousYearSales,
    ((TotalSales - LAG(TotalSales) OVER (PARTITION BY Country ORDER BY SalesYear)) / LAG(TotalSales) OVER (PARTITION BY Country ORDER BY SalesYear)) * 100 AS YearOverYearGrowth
FROM SalesCTE
ORDER BY Country, SalesYear;

--19.List the months with the lowest sales for each year.

WITH RankedSales AS (
    SELECT
        month,
        year,
        SUM(sales) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY SUM(sales) ASC) AS sales_rank
    FROM pharmasale
    GROUP BY month, year
)
SELECT month, year, total_sales
FROM RankedSales
WHERE sales_rank = 1;

--20. Calculate the total sales for each sub-channel in each country, 
--and then find the country with the highest total sales for each sub-channel.

WITH SubChannelSales AS (
    SELECT
        Country,
        Sub_channel,
        SUM(sales) AS TotalSales
    FROM pharmasale
    GROUP BY Country, Sub_channel
),
RankedCountrySales AS (
    SELECT
        Country,
        Sub_channel,
        TotalSales,
        RANK() OVER (PARTITION BY Sub_channel ORDER BY TotalSales DESC) AS CountryRank
    FROM SubChannelSales
)
SELECT
    Sub_Channel,
    Country,
    TotalSales
FROM RankedCountrySales
WHERE CountryRank = 1;
  
  
  --THANK YOU--


