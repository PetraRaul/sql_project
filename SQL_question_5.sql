WITH payroll_comparison AS(
	SELECT 
		prim1."year",
		prim1.avg_payroll - prim2.avg_payroll AS payroll_development
	FROM 
		t_petra_raulimova_project_SQL_primary_final AS prim1
	LEFT JOIN 
		t_petra_raulimova_project_SQL_primary_final AS prim2
		ON prim1."year"=prim2."year"+1
	WHERE 
	prim1.industry_name IS NULL 
	AND prim1.avg_payroll IS NOT NULL
	AND prim2.industry_name IS NULL 
	AND prim2.avg_payroll IS NOT NULL),
price_comparison AS(
	SELECT 
		prim1."year",
		(avg(prim1.avg_price)-avg(prim2.avg_price)) AS price_development
	FROM 
		t_petra_raulimova_project_SQL_primary_final AS prim1
	LEFT JOIN 
		t_petra_raulimova_project_SQL_primary_final AS prim2
		ON prim1."year"=prim2."year"+1
	GROUP BY 
		prim1."year"
	ORDER BY 
		prim1."year"),
gdp_comparison AS (
	SELECT 
		secon."year",	
		round((secon.gdp-LAG(secon.gdp) OVER (PARTITION BY secon.country ORDER BY secon."year"))::NUMERIC,2) AS gdp_development	
	FROM 
		t_petra_raulimova_project_SQL_secondary_final AS secon
	WHERE
		country='Czech Republic')
SELECT 
	pay."year",
	gdp.gdp_development,
	pay.payroll_development,
	round(pri.price_development::NUMERIC,2) AS price_development
FROM
	gdp_comparison AS gdp
LEFT JOIN 
	payroll_comparison AS pay
	ON pay."year"=gdp."year"
LEFT JOIN
	price_comparison AS pri
	ON pri."year"=gdp."year"
WHERE
	pay."year"<> '2006';