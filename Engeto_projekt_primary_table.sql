CREATE TABLE t_veronika_jancikova_project_sql_primary_final AS
SELECT
	'payroll' AS record_type,
	cp.payroll_year AS year,
	cp.value_type_code,
	cp.industry_branch_code::text AS industry_branch_code,
	cpib.name AS industry_name,
	NULL::text AS category_code,
	NULL::text AS category_name,
	NULL::date AS date_from,
	cp.value AS payroll_value,
	NULL::numeric AS price_value
FROM czechia_payroll cp
LEFT JOIN czechia_payroll_industry_branch cpib
	ON cp.industry_branch_code = cpib.code
WHERE cp.value_type_code = 5958
UNION ALL
SELECT
	'price' AS record_type,
	EXTRACT(YEAR FROM p.date_from)::int AS year,
	NULL::int AS value_type_code,
	NULL::text AS industry_branch_code,
	NULL::text AS industry_name,
	p.category_code::text AS category_code,
	pc.name AS category_name,
	p.date_from,
	NULL::numeric AS payroll_value,
	p.value::numeric AS price_value
FROM czechia_price p
LEFT JOIN czechia_price_category pc
	ON p.category_code = pc.code;