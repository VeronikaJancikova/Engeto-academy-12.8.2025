WITH avg_wage AS (
	SELECT
		industry_name,
		year,
		AVG(payroll_value) AS avg_wage
	FROM t_veronika_jancikova_project_sql_primary_final
	WHERE record_type = 'payroll'
		AND payroll_value IS NOT NULL
		AND industry_name IS NOT NULL
	GROUP BY industry_name, year
),
yoy AS (
	SELECT
		industry_name,
		year,
		avg_wage,
		avg_wage - LAG(avg_wage) OVER (PARTITION BY industry_name ORDER BY year) AS diff_from_prev_year
	FROM avg_wage
)
SELECT
	industry_name,
	year,
	ROUND(avg_wage::numeric, 2) AS avg_wage,
	ROUND(diff_from_prev_year::numeric, 2) AS diff_from_prev_year
FROM yoy
WHERE diff_from_prev_year IS NOT NULL
ORDER BY diff_from_prev_year ASC;