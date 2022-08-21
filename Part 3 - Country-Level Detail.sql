-- 3. COUNTRY-LEVEL DETAIL
-- Instructions:
-- Answering these questions will help you add information to the template.
-- Use these questions as guides to write SQL queries.
-- Use the output from the query to answer these questions.

-- A) Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each?

WITH data_1990 AS (SELECT country_name AS cn1,
			                    year,
			                  	forest_area_sqkm
			               FROM forestation
			              WHERE year = 1990),

			data_2016 AS (SELECT country_name AS cn2,
			                     year,
			                  	 forest_area_sqkm
			                FROM forestation
			               WHERE year = 2016)

SELECT d1.cn1,
			 d1.forest_area_sqkm - d2.forest_area_sqkm AS diff
	FROM data_1990 AS d1
	JOIN data_2016 AS d2
		ON d1.cn1 = d2.cn2
 WHERE d1.forest_area_sqkm > d2.forest_area_sqkm
   AND d1.cn1 != 'World'
 ORDER BY 2 DESC
 LIMIT 5;

-- B) Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change to 2 decimal places for each?

WITH data_1990 AS (SELECT country_name AS cn1,
                          country_region,
			                    year,
			                  	forest_area_sqkm,
                          forest_percent
			               FROM forestation
			              WHERE year = 1990),

		 data_2016 AS (SELECT country_name AS cn2,
			                    year,
			                    forest_area_sqkm,
                          forest_percent
			               FROM forestation
			              WHERE year = 2016)

SELECT d1.cn1,
       country_region,
			 (d1.forest_area_sqkm - d2.forest_area_sqkm) / d1.forest_area_sqkm AS diff
	FROM data_1990 AS d1
	JOIN data_2016 AS d2
		ON d1.cn1 = d2.cn2
 WHERE d1.forest_percent IS NOT NULL
   AND d1.forest_area_sqkm > d2.forest_area_sqkm
 ORDER BY 3 DESC
 LIMIT 5;

-- C) If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?
-- I could have used the FLOOR() function, but, at the time, I didn't know about the existence of this function.

WITH percent AS (SELECT country_name,
                        forest_percent,
                        CASE WHEN forest_percent > 75 THEN 4
                 		 	       WHEN forest_percent BETWEEN 50 AND 75 THEN 3
                 			       WHEN forest_percent BETWEEN 25 AND 50 THEN 2
                 			       ELSE 1 END AS quartile
                   FROM forestation
                  WHERE year = 2016
                    AND forest_percent IS NOT NULL
                  ORDER BY 2 DESC)

SELECT quartile,
       COUNT(quartile)
  FROM percent
 GROUP BY 1
 ORDER BY 1;

-- D) List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.

WITH percent AS (SELECT country_name,
                 		    country_region,
                        forest_percent,
                        CASE WHEN forest_percent > 75 THEN 4
                 		 	       WHEN forest_percent BETWEEN 50 AND 75 THEN 3
                 			       WHEN forest_percent BETWEEN 25 AND 50 THEN 2
                 			       ELSE 1 END AS quartile
                   FROM forestation
                  WHERE year = 2016
                    AND forest_percent IS NOT NULL
                  ORDER BY 2 DESC)

SELECT country_name,
	   country_region,
       forest_percent
  FROM percent
 WHERE quartile = 4
 ORDER BY 3 DESC;

-- E) How many countries had a percent forestation higher than the United States in 2016?

WITH countries AS (SELECT fcountry_name,
                          country_code,
                          forest_percent,
                          (SELECT forest_percent
                             FROM forestation
                            WHERE fa_year = 2016
                              AND fa_country_name = 'United States') AS us_percent
                   FROM forestation AS f
                   WHERE fa_year = 2016)

SELECT COUNT(*)
  FROM countries
 WHERE forest_percent > us_percent;
