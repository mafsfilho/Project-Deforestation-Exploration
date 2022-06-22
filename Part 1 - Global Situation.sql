-- 1. GLOBAL SITUATION
-- Instructions:
-- Answering these questions will help you add information into the template.
-- Use these questions as guides to write SQL queries.
-- Use the output from the query to answer these questions.

-- A) What was the total forest area (in sq km) of the world in 1990? Please keep in mind that you can use the country record denoted as “World" in the region table.

SELECT *
  FROM forestation
 WHERE country_name = 'World'
   AND year = 1990;

-- B) What was the total forest area (in sq km) of the world in 2016? Please keep in mind that you can use the country record in the table is denoted as “World.”

SELECT *
  FROM forestation
 WHERE country_name = 'World'
   AND year = 2016;

-- C) What was the change (in sq km) in the forest area of the world from 1990 to 2016?

SELECT MAX(forest_area_sqkm) - MIN(forest_area_sqkm) AS area_diff
  FROM forestation
 WHERE country_name = 'World';

-- D) What was the percent change in forest area of the world between 1990 and 2016?

WITH data_1990 AS (SELECT country_name,
                          forest_area_sqkm
                     FROM forestation
                    WHERE country_name = 'World'
                      AND year = 1990),

     data_2016 AS (SELECT country_name,
                          forest_area_sqkm
                     FROM forestation
                    WHERE country_name = 'World'
                      AND year = 2016)

SELECT (d1.forest_area_sqkm - d2.forest_area_sqkm) * 100 / d1.forest_area_sqkm AS percent_diff
  FROM data_1990 AS d1
  JOIN data_2016 AS d2
    ON d1.country_name = d2.country_name


-- E) If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to?

SELECT country_name,
	     total_area_sqkm
  FROM forestation
 WHERE total_area_sqkm BETWEEN (1200000 AND 1500000)
   AND year = 2016
 ORDER BY 2;
