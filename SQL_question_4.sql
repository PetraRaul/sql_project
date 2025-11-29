WITH payroll_comparison AS(
	SELECT 
		prim1."year",
		round(((prim1.avg_payroll-prim2.avg_payroll)/prim2.avg_payroll)*100 ::NUMERIC,2) AS payroll_diff_pct
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
		round(((avg(prim1.avg_price)- avg(prim2.avg_price))/avg(prim2.avg_price))*100::NUMERIC,2) AS price_diff_pct
	FROM 
		t_petra_raulimova_project_SQL_primary_final AS prim1
	LEFT JOIN 
		t_petra_raulimova_project_SQL_primary_final AS prim2
		ON prim1."year" = prim2."year"+1
	WHERE
		prim1.category_name <> 'Jakostní víno bílé'
		AND prim2.category_name <> 'Jakostní víno bílé'
	GROUP BY 
		prim1."year"
	ORDER BY 
		prim1."year")
SELECT 
	pay."year", 
	pay.payroll_diff_pct,
	pri.price_diff_pct,
	pri.price_diff_pct-pay.payroll_diff_pct AS difference_pct
FROM
	payroll_comparison AS pay
LEFT JOIN 
	price_comparison AS pri
	ON pri."year"=pay."year"
ORDER BY
	difference_pct ASC;