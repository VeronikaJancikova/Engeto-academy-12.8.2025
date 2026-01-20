WITH wage AS (
	SELECT
		year,
		AVG(payroll_value) AS avg_wage
	FROM t_veronika_jancikova_project_sql_primary_final
	WHERE record_type = 'payroll'
		AND payroll_value IS NOT NULL
	GROUP BY year
),
bread AS (
	SELECT
		year,
		AVG(price_value) AS avg_bread_price
	FROM t_veronika_jancikova_project_sql_primary_final
	WHERE record_type = 'price'
		AND price_value IS NOT NULL
		AND TRIM(category_code) = '111301'
	GROUP BY year
),
milk AS (
	SELECT
		year,
		AVG(price_value) AS avg_milk_price
	FROM t_veronika_jancikova_project_sql_primary_final
	WHERE record_type = 'price'
		AND price_value IS NOT NULL
		AND TRIM(category_code) = '114201'
	GROUP BY year
),
merged AS (
	SELECT
		w.year,
		w.avg_wage,
		b.avg_bread_price,
		m.avg_milk_price
	FROM wage w
	JOIN bread b ON w.year = b.year
	JOIN milk m ON w.year = m.year
),
limits AS (
	SELECT MIN(year) AS first_year, MAX(year) AS last_year
	FROM merged
)
SELECT
	me.year,
	ROUND(me.avg_wage::numeric, 2) AS avg_wage,
	ROUND(me.avg_bread_price::numeric, 2) AS avg_bread_price,
	ROUND(me.avg_milk_price::numeric, 2) AS avg_milk_price,
	ROUND((me.avg_wage / me.avg_bread_price)::numeric, 0) AS bread_units,
	ROUND((me.avg_wage / me.avg_milk_price)::numeric, 0) AS milk_units
FROM merged me
JOIN limits l
	ON me.year IN (l.first_year, l.last_year)
ORDER BY me.year;