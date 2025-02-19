-- 3일 이동 평균 매출
WITH temp_01 AS (
	SELECT
		order_date,
		SUM(amount) AS sum_amount
	FROM
		nw.order_items
		LEFT JOIN nw.orders ON order_items.order_id = orders.order_id
	GROUP BY
		order_date
	ORDER BY
		order_date
)
SELECT
	*,
	AVG(sum_amount) OVER (ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS three_days_ma
FROM
	temp_01 
	
SELECT
	*
FROM
	nw.orders

-- 3일 중앙 평균 매출
WITH temp_01 AS (
	SELECT
		order_date,
		SUM(amount) AS sum_amount
	FROM
		nw.order_items 
		LEFT JOIN nw.orders ON order_items.order_id = orders.order_id
	GROUP BY
		order_date
	ORDER BY
		order_date
)
SELECT
	*,
	AVG(sum_amount) OVER (ORDER BY order_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS med_avg_3days,
	CASE
		WHEN ROW_NUMBER() OVER (ORDER BY order_date) <= 2 THEN NULL 
		ELSE AVG(sum_amount) OVER (ORDER BY order_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
	END AS real_med_avg_3days
FROM	
	temp_01
	
