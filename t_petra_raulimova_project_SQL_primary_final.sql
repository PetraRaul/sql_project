CREATE TABLE t_petra_raulimova_project_SQL_primary_final AS
WITH price_aggregated AS(
	SELECT 
		date_part('YEAR',cp.date_to) AS price_year,	
		cpc.name AS category_name,
		round(avg(cp.value)::NUMERIC,2) AS avg_price,
		cpc.price_value,
		cpc.price_unit,
		ROW_NUMBER() OVER (PARTITION BY date_part('YEAR',cp.date_to) ORDER BY cp.category_code) AS price_row_index
	FROM
		czechia_price AS cp
	LEFT JOIN 
		czechia_price_category AS cpc
		ON cp.category_code=cpc.code
	WHERE
		cp.region_code IS NULL
	GROUP BY
		cpc.name,cp.category_code, price_year, cpc.price_value, cpc.price_unit
	ORDER BY
		price_year ASC),
payroll_aggregated AS(
	SELECT 
		cpib.name AS industry_name,
		cpay.payroll_year,
		round(avg(cpay.value)::NUMERIC,2) AS avg_payroll,
		ROW_NUMBER() OVER (PARTITION BY cpay.payroll_year ORDER BY cpay.industry_branch_code) AS payroll_row_index
	FROM
		czechia_payroll AS cpay
	LEFT JOIN 
		czechia_payroll_calculation AS ccal
		ON cpay.calculation_code=ccal.code
	LEFT JOIN 
		czechia_payroll_value_type AS cpvt 
		ON cpay.value_type_code=cpvt.code
	LEFT JOIN
		czechia_payroll_industry_branch AS cpib
		ON cpay.industry_branch_code=cpib.code
	WHERE 
		cpay.calculation_code='200' 
		AND cpay.value_type_code='5958'
	GROUP BY
		cpib.name, cpay.industry_branch_code, cpay.payroll_year)
SELECT
	pri.price_year AS "year",
	pri.category_name,
	pri.avg_price,
	pri.price_value,
	pri.price_unit,
	pay.industry_name,
	pay.avg_payroll
FROM 
	price_aggregated AS pri
LEFT JOIN 
	payroll_aggregated AS pay
	ON pri.price_row_index=pay.payroll_row_index
	AND pri.price_year=pay.payroll_year;