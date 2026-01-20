WITH wage AS (
	SELECT year, AVG(payroll_value) AS avg_wage
	FROM t_veronika_jancikova_project_sql_primary_final
	WHERE record_type='payroll' AND payroll_value IS NOT NULL
	GROUP BY year
),
wage_yoy AS (
	SELECT
		year,
		((avg_wage - LAG(avg_wage) OVER (ORDER BY year)) / LAG(avg_wage) OVER (ORDER BY year)) * 100 AS wage_growth_pct
	FROM wage
),
food AS (
	SELECT year, AVG(price_value) AS avg_food_price
	FROM t_veronika_jancikova_project_sql_primary_final
	WHERE record_type='price' AND price_value IS NOT NULL
	GROUP BY year
),
food_yoy AS (
	SELECT
		year,
		((avg_food_price - LAG(avg_food_price) OVER (ORDER BY year)) / LAG(avg_food_price) OVER (ORDER BY year)) * 100 AS food_growth_pct
	FROM food
)
SELECT
	f.year,
	ROUND(f.food_growth_pct::numeric, 2) AS food_growth_pct,
	ROUND(w.wage_growth_pct::numeric, 2) AS wage_growth_pct,
	ROUND((f.food_growth_pct - w.wage_growth_pct)::numeric, 2) AS difference_pct
FROM food_yoy f
JOIN wage_yoy w ON f.year = w.year
WHERE f.food_growth_pct IS NOT NULL
	AND w.wage_growth_pct IS NOT NULL
ORDER BY f.year;