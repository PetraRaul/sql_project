SELECT 
	prim1."year",
	prim1.category_name,
	prim1.avg_price,
	prim2.avg_payroll,
	round(prim2.avg_payroll/(prim1.avg_price*prim1.price_value)::NUMERIC,2) AS purchased_quantity,
	prim1.price_unit
FROM 
	t_petra_raulimova_project_SQL_primary_final AS prim1
LEFT JOIN 
	t_petra_raulimova_project_SQL_primary_final AS prim2
	ON prim1."year"=prim2."year"
WHERE 
	prim1."year" IN ('2006','2018')
	AND (prim1.category_name LIKE 'Mléko%' OR prim1.category_name LIKE 'Chléb%')
	AND (prim2.industry_name IS NULL)
	AND (prim2.avg_payroll IS NOT NULL);