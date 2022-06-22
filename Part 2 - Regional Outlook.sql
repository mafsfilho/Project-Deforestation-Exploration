-- 2. REGIONAL OUTLOOK
-- Instructions:
-- Answering these questions will help you add information into the template.
-- Use these questions as guides to write SQL queries.
-- Use the output from the query to answer these questions.
-- Create a table that shows the Regions and their percent forest area (sum of forest area divided by sum of land area) in 1990 and 2016. (Note that 1 sq mi = 2.59 sq km).
-- Based on the table you created, ...

-- A) What was the percent forest of the entire world in 2016? Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places?

SELECT country_name,
       year,
       forest_percent
  FROM forestation
 WHERE country_name = 'World'
   AND year = 2016;

SELECT country_region,
       year,
       SUM(forest_percent)/COUNT(country_name) AS forest_percent
  FROM forestation
 WHERE year = 2016
   AND forest_percent IS NOT NULL
 GROUP BY 1, 2
 ORDER BY 3 DESC
 LIMIT 1;

SELECT country_region,
       year,
       SUM(forest_percent)/COUNT(country_name) AS forest_percent
  FROM forestation
 WHERE year = 2016
   AND forest_percent IS NOT NULL
 GROUP BY 1, 2
 ORDER BY 3
 LIMIT 1;

-- B) What was the percent forest of the entire world in 1990? Which region had the HIGHEST percent forest in 1990, and which had the LOWEST, to 2 decimal places?

SELECT country_name,
       year,
       forest_percent
  FROM forestation
 WHERE country_name = 'World'
   AND year = 1990;

SELECT country_region,
      year,
      SUM(forest_percent)/COUNT(country_name) AS forest_percent
 FROM forestation
WHERE year = 1990
  AND forest_percent IS NOT NULL
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1;

SELECT country_region,
       year,
       SUM(forest_percent)/COUNT(country_name) AS forest_percent
  FROM forestation
 WHERE year = 1990
   AND forest_percent IS NOT NULL
 GROUP BY 1, 2
 ORDER BY 3
 LIMIT 1;

-- C) Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016?

WITH Table1 AS
  (SELECT country_region,
          year,
          SUM(forest_percent)/COUNT(country_name) AS forest_percent
     FROM forestation
    WHERE year = 1990
    GROUP BY 1, 2),

    Table2 AS
  (SELECT country_region,
          year,
          SUM(forest_percent)/COUNT(country_name) AS forest_percent
     FROM forestation
    WHERE year = 2016
    GROUP BY 1, 2)

SELECT t1.country_region,
   	   t1.forest_percent AS fp1,
       t2.forest_percent AS fp2
  FROM Table1 AS t1
  JOIN Table2 AS t2
    ON t1.country_region = t2.country_region  WHERE t1.forest_percent > t2.forest_percent
