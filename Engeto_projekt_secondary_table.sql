CREATE TABLE t_veronika_jancikova_project_sql_secondary_final AS
WITH wages AS (
	SELECT
		payroll_year AS year,
		AVG(value)::numeric AS avg_wage
	FROM czechia_payroll
	WHERE value_type_code = 5958
	GROUP BY payroll_year
),
food_prices AS (
	SELECT
		EXTRACT(YEAR FROM date_from)::int AS year,
		AVG(value)::numeric AS avg_food_price
	FROM czechia_price
	GROUP BY EXTRACT(YEAR FROM date_from)::int
)
SELECT
	e.year,
	e.country,
	e.gdp::numeric AS gdp,
	w.avg_wage,
	f.avg_food_price
FROM economies e
LEFT JOIN wages w ON e.year = w.year
LEFT JOIN food_prices f ON e.year = f.year
WHERE e.country = 'Czech Republic'
ORDER BY e.YEAR
