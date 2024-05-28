/*ENSURING DATA CONSISTENCY*/
SELECT *
FROM colorado_motor_vehicle_sales
WHERE year NOT BETWEEN 2008 AND 2015
   OR quarter NOT BETWEEN 1 AND 4
   OR sales < 0;
   
   /*TOTAL SALES BY YEAR*/
   SELECT year, SUM(sales) AS total_sales
FROM colorado_motor_vehicle_sales
GROUP BY year
ORDER BY year;
 
    /*TOTAL SALES BY QUATER*/
SELECT quarter, SUM(sales) AS total_sales
FROM colorado_motor_vehicle_sales
GROUP BY quarter
ORDER BY quarter;

/*TOTAL SALES BY COUNTY*/
SELECT county, SUM(sales) AS total_sales
FROM colorado_motor_vehicle_sales
GROUP BY county
ORDER BY total_sales DESC;

/*YEAR OVER YEAR GROWTH*/
SELECT county, year, 
       SUM(sales) AS total_sales,
       LAG(SUM(sales)) OVER (PARTITION BY county ORDER BY year) AS previous_year_sales,
       (SUM(sales) - LAG(SUM(sales)) OVER (PARTITION BY county ORDER BY year)) / LAG(SUM(sales)) OVER (PARTITION BY county ORDER BY year) * 100 AS growth_percentage
FROM colorado_motor_vehicle_sales
GROUP BY county, year
ORDER BY county, year;

/*AVERAGE SALES PER QUATER*/
SELECT QUARTER, AVG(SALES) AS AVERAGE_SALES
FROM colorado_motor_vehicle_sales
GROUP BY QUARTER
ORDER BY QUARTER;

/*SALE TRENDS OVER TIME*/
SELECT year, quarter, SUM(sales) AS total_sales
FROM colorado_motor_vehicle_sales
GROUP BY year, quarter
ORDER BY year, quarter;


/*RANKING THE COUNTIES BASED ON TOTAL SALES*/
SELECT 
    COUNTY, 
    TOTAL_SALES,
    RANK() OVER (ORDER BY TOTAL_SALES DESC) AS county_rank
FROM (
    SELECT 
        COUNTY, 
        SUM(SALES) AS TOTAL_SALES
    FROM 
        colorado_motor_vehicle_sales
    GROUP BY 
        COUNTY
) AS county_sales;

SELECT COUNTY, TOTAL_SALES, RANK() OVER (partition by TOTAL_SALES DESC)
FROM CTE
GROUP BY COUNTY
ORDER BY COUNTY;


/*COUNTY RANKS BASED ON QUARTERS*/
WITH CTE AS (
SELECT 
        COUNTY, QUARTER,
        SUM(SALES) AS TOTAL_SALES
    FROM 
        colorado_motor_vehicle_sales
        GROUP BY 
        COUNTY, QUARTER 
        )
SELECT 
    COUNTY, QUARTER,
    TOTAL_SALES,
    RANK() OVER (partition by quarter ORDER BY TOTAL_SALES DESC) AS county_rank
    FROM CTE ;

/*Yearly Trends*/
SELECT 
    COUNTY, YEAR, SUM(SALES) AS TOTAL_SALES
FROM 
    colorado_motor_vehicle_sales
GROUP BY 
    COUNTY, YEAR;
    
    
  /*SALES DURING ECONOMIC EVENT*/
  SELECT 
    COUNTY,
     YEAR,
    SUM(SALES) AS TOTAL_SALES
FROM 
    colorado_motor_vehicle_sales
WHERE 
    year BETWEEN '2008' AND '2009' -- During the Great Recession
GROUP BY 
    COUNTY,  YEAR;
    
    SELECT A.COUNTY, A.YEAR,A.POPULATION, B.SUM(SALES)
    FROM`co_population (1)` a
    join colorado_motor_vehicle_sales B ON A.COUNTY=B.COUNTY
    GROUP BY A.YEAR, B.SALES
    ORDER BY A.YEAR ASC;
    
    /*SALES PER CAPITA*/

SELECT 
    A.COUNTY, 
    A.YEAR, 
    A.POPULATION, 
    SUM(B.SALES) AS TOTAL_SALES,
    ROUND(SUM(B.SALES)/POPULATION,0) AS SALES_PER_CAPITA
FROM `co_population (1)` A JOIN 
    colorado_motor_vehicle_sales B 
ON 
    A.COUNTY = B.COUNTY
GROUP BY 
    A.COUNTY, 
    A.YEAR, 
    A.POPULATION
ORDER BY 
    A.YEAR ASC;


/*RUNNING TOTAL OF SALES THROUGHOUT THE YEARS*/
SELECT DISTINCT COUNTY, YEAR, SUM(SALES) OVER (PARTITION BY COUNTY ORDER BY YEAR) AS RUNNING_TOTAL
FROM colorado_motor_vehicle_sales;


/*IDENTIFYING PEAK SALE TIME*/
SELECT YEAR, QUARTER, SUM(SALES) AS TOTAL_SALES
FROM colorado_motor_vehicle_sales
GROUP BY QUARTER, year
ORDER BY SUM(SALES) DESC;


/*HIGH PERFORMING COUNTITES*/
SELECT COUNTY, SUM(SALES) AS TOTAL_SALES
FROM colorado_motor_vehicle_sales
GROUP BY COUNTY
ORDER BY TOTAL_SALES DESC;


/*LOW PERFORMING COUNTIES*/
SELECT COUNTY, AVG(SALES) AS AVG_SALES
FROM colorado_motor_vehicle_sales
GROUP BY COUNTY
ORDER BY AVG_SALES ;




