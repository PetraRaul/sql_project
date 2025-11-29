WITH payroll_development AS (
	SELECT
		"year",
		industry_name,
		avg_payroll - LAG(avg_payroll) OVER (PARTITION BY industry_name ORDER BY "year") AS avg_payroll_diff
	FROM 
		t_petra_raulimova_project_SQL_primary_final
	WHERE
		industry_name IS NOT NULL)
SELECT 
	industry_name,
	sum(avg_payroll_diff) AS total_avg_payroll_change,
	sum(CASE WHEN avg_payroll_diff > 0 THEN avg_payroll_diff END) AS avg_payroll_increase,
	sum(CASE WHEN avg_payroll_diff < 0 THEN avg_payroll_diff END) AS avg_payroll_decrease,
	STRING_AGG (
		CASE 
			WHEN avg_payroll_diff < 0 THEN "year"::varchar END, ', '
			) AS year_payroll_decrease
FROM
	payroll_development
GROUP BY 
	industry_name
ORDER BY
	total_avg_payroll_change DESC;