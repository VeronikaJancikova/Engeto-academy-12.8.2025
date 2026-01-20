WITH avg_price AS (
	SELECT
		category_name,
		year,
		AVG(price_value) AS avg_price
	FROM t_veronika_jancikova_project_sql_primary_final
	WHERE record_type = 'price'
		AND price_value IS NOT NULL
		AND category_name IS NOT NULL
	GROUP BY category_name, year
),
yoy AS (
	SELECT
		category_name,
		year,
		((avg_price - LAG(avg_price) OVER (PARTITION BY category_name ORDER BY year))
		/ LAG(avg_price) OVER (PARTITION BY category_name ORDER BY year)) * 100 AS yoy_growth_pct
	FROM avg_price
)
SELECT
	category_name,
	ROUND(AVG(yoy_growth_pct)::numeric, 2) AS avg_yoy_growth_pct
FROM yoy
WHERE yoy_growth_pct IS NOT NULL
GROUP BY category_name
ORDER BY avg_yoy_growth_pct ASC;