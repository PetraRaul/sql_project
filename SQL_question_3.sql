WITH price_development AS(
	SELECT
		category_name,
		FIRST_VALUE(avg_price) OVER (PARTITION BY category_name ORDER BY "year") AS price_first_year, 
		LAST_VALUE(avg_price) OVER (PARTITION BY category_name ORDER BY "year" 
			ROWS BETWEEN UNBOUNDED PRECEDING 
			AND UNBOUNDED FOLLOWING ) AS price_last_year
	FROM 
		t_petra_raulimova_project_SQL_primary_final
	ORDER BY 
		category_name, "year")
SELECT
	DISTINCT(category_name),
	round((price_last_year/price_first_year-1)*100 ::numeric,2) AS price_increase_pct
FROM 
	price_development
ORDER BY 
	price_increase_pct ASC;