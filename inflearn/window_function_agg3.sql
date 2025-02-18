-- product_id별 총 매출액을 구하고, 전체 매출 대비 개별 상품의 총 매출액 비율을 소수점 2자리로 구한 뒤 매출액 비율 내림차순 정렬
WITH temp_01 AS (
	SELECT
		product_id,
		SUM(amount) AS amount_by_product
	FROM	
		nw.order_items
	GROUP BY
		product_id
)
SELECT
	*,
	SUM(amount_by_product) OVER () AS total_amount,
	ROUND(amount_by_product / SUM(amount_by_product) OVER (), 2) AS amount_ratio
FROM
	temp_01
ORDER BY
	amount_ratio DESC
	
-- 직원별 개별 상품 매출액, 직원별 가장 높은 상품 매출액을 구하고, 직원별로 가장 높은 매출을 올리는 상품의 매출 금액 대비 개별 상품 비율 구하
WITH temp_01 AS (	
	SELECT
		employee_id,
		product_id,
		SUM(amount) AS total_amount
	FROM
		nw.orders 
		LEFT JOIN nw.order_items ON orders.order_id = order_items.order_id
	GROUP BY
		orders.employee_id,
		order_items.product_id
)
SELECT
	*,
	MAX(total_amount) OVER (PARTITION BY employee_id) AS max_employee_amount,
	ROUND(total_amount / MAX(total_amount) OVER (PARTITION BY employee_id), 2) AS max_emp_amount_ratio
FROM
	temp_01
ORDER BY
	employee_id,
	max_emp_amount_ratio DESC
	
-- 상품별 매출합을 구하되, 상품 카테고리별 매출합의 5% 이상이고, 동일 카테고리에서 상위 3개의 매출의 상품 정보 추출
-- 1. 상품별 + 상품 카테고리별 총 매출 계산. (상품별 + 상품 카테고리별 총 매출은 결국 상품별 총 매출임)
-- 2. 상품 카테고리별 총 매출 계산 및 동일 카테고리에서 상품별 랭킹 구함
-- 3. 상품 카테고리 매출의 5% 이상인 상품 매출과 매출 기준 top3 상품 추출
	
WITH temp_01 AS (
	SELECT
		product_id,
		SUM(amount) AS amount_by_product
	FROM
		nw.order_items
	GROUP BY
		product_id
), temp_02 AS (
	SELECT
		temp_01.product_id,
		temp_01.amount_by_product,
		products.category_id,
		SUM(amount_by_product) OVER (PARTITION BY category_id) AS amount_by_category,
		amount_by_product / SUM(amount_by_product) OVER (PARTITION BY category_id) AS amount_ratio
	FROM
		temp_01
		LEFT JOIN nw.products ON temp_01.product_id = products.product_id
), temp_03 AS (
SELECT
	*,
	RANK() OVER (PARTITION BY category_id ORDER BY amount_by_product DESC) AS amount_rank
FROM 
	temp_02
WHERE
	amount_ratio >= 0.05
)
SELECT
	*
FROM
	temp_03
WHERE
	amount_rank <= 3

	