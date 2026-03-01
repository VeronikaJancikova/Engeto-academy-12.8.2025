CREATE TABLE t_veronika_jancikova_project_sql_secondary_final AS
WITH years_in_primary AS (
    SELECT DISTINCT year
    FROM t_veronika_jancikova_project_sql_primary_final
    WHERE year IS NOT NULL
),
wages AS (
    SELECT
        year,
        AVG(payroll_value)::numeric AS avg_wage
    FROM t_veronika_jancikova_project_sql_primary_final
    WHERE record_type = 'payroll'
      AND payroll_value IS NOT NULL
    GROUP BY year
),
food_prices AS (
    SELECT
        year,
        AVG(price_value)::numeric AS avg_food_price
    FROM t_veronika_jancikova_project_sql_primary_final
    WHERE record_type = 'price'
      AND price_value IS NOT NULL
    GROUP BY year
)
SELECT
    e.country,
    c.continent, 
    e.year,
    e.gdp::numeric AS gdp,
    e.gini,
    w.avg_wage,
    f.avg_food_price
FROM economies e
JOIN years_in_primary y
    ON e.year = y.year
LEFT JOIN wages w
    ON e.year = w.year
LEFT JOIN food_prices f
    ON e.year = f.year
LEFT JOIN countries c
    ON e.country = c.country
ORDER BY e.country, e.year