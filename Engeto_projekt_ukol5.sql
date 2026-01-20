WITH calc AS (
	SELECT
		country,
		year,
		ROUND((
			(gdp - LAG(gdp) OVER (PARTITION BY country ORDER BY year))
			/ LAG(gdp) OVER (PARTITION BY country ORDER BY year)
			* 100)::numeric, 2
		) AS gdp_growth_pct,
		ROUND((
			(avg_wage - LAG(avg_wage) OVER (PARTITION BY country ORDER BY year))
			/ LAG(avg_wage) OVER (PARTITION BY country ORDER BY year)
			* 100)::numeric, 2
		) AS wage_growth_pct,
		ROUND((
			(avg_food_price - LAG(avg_food_price) OVER (PARTITION BY country ORDER BY year))
			/ LAG(avg_food_price) OVER (PARTITION BY country ORDER BY year)
			* 100)::numeric, 2
		) AS food_price_growth_pct
	FROM t_veronika_jancikova_project_sql_secondary_final
)
SELECT
	country,
	year,
	gdp_growth_pct,
	wage_growth_pct,
	food_price_growth_pct,
	LEAD(wage_growth_pct) OVER (PARTITION BY country ORDER BY year) AS wage_growth_next_year,
	LEAD(food_price_growth_pct) OVER (PARTITION BY country ORDER BY year) AS food_price_growth_next_year
FROM calc
WHERE country = 'Czech Republic'
	AND gdp_growth_pct IS NOT NULL
ORDER BY year;