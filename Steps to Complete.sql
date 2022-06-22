-- Steps to Complete
-- 1. Create a View called “forestation” by joining all three tables - forest_area, land_area and regions in the workspace.
-- 2. The forest_area and land_area tables join on both country_code AND year.
-- 3. The regions table joins these based on only country_code.
-- 4. In the ‘forestation’ View, include the following:
-- 4.a) All of the columns of the origin tables
-- 4.b) A new column that provides the percent of the land area that is designated as forest.
-- 4.c) Keep in mind that the column forest_area_sqkm in the forest_area table and the land_area_sqmi in the land_area table are in different units (square kilometers 
--      and square miles, respectively), so an adjustment will need to be made in the calculation you write (1 sq mi = 2.59 sq km).

CREATE VIEW forestation
AS
WITH t_fa AS (SELECT country_code AS fa_country_code,
                     country_name AS fa_country_name,
                     year AS fa_year,
                     forest_area_sqkm
                FROM forest_area),

     t_la AS (SELECT country_code AS la_country_code,
                     country_name AS la_country_name,
                     year AS la_year,
                     total_area_sq_mi
                FROM land_area),

     t_r AS (SELECT country_name AS r_country_name,
                    country_code AS r_country_code,
                    region,
                    income_group
               FROM regions)

SELECT r.r_country_code AS country_code,
       r.r_country_name AS country_name,
       r.region AS country_region,
       fa.fa_year AS year,
       fa.forest_area_sqkm,
       la.total_area_sq_mi * 2.59 AS total_area_sqkm,
	     (fa.forest_area_sqkm * 100) / (la.total_area_sq_mi * 2.59) AS "forest_percent"
  FROM t_fa AS fa
  JOIN t_la AS la
    ON fa.fa_country_code = la.la_country_code
   AND fa.fa_year = la.la_year
  JOIN t_r AS r
    ON fa.fa_country_code = r.r_country_code
 WHERE fa.fa_year = 1990
    OR fa.fa_year = 2016
 ORDER BY r.r_country_name,
 	      fa.fa_year;

-- I've chosen to select all the data related to name, code and country region from the table "regions", because these are the entities of that table. 

-- So that I could creat the "forest_percent" column, I defined the total area as the divisor and the forest area as the denominator, taking care that both have the 
-- same unit.

-- Before actually starting to write the code for the project, I read through all the instructions and noticed that the only years it would take would be 1990 and 
-- 2016. Therefore, when creating the requested view, I used the WHERE clause and selected only the data related to those years.
