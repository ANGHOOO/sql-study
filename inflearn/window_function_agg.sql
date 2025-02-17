-- order_items 테이블에서 order_id 별 amount 총합까지 표시
SELECT
	*,
	SUM(amount) OVER(PARTITION BY order_id) AS sum_amount
FROM
	nw.order_items

-- order_items 테이블에서 order_id별 line_prod_seq순으로 누적 amount 합까지 표시
SELECT
	*,
	SUM(amount) OVER(PARTITION BY order_id ORDER BY line_prod_seq) AS cum_amonut
FROM
	nw.order_items
	
-- order_items 테이블에서 order_id별 line_prod_seq순으로 누적 amount 합 (partition 또는 order by 절이 없을 경우 windows)
SELECT
	*,
	SUM(amount) OVER () AS total_sum
FROM
	nw.order_items
	
-- order_items 테이블에서 order_id 별 상품 최대 구매금액, order_id별 상품 누적 최대 구매금액
SELECT
	*,
	MAX(unit_price) OVER(PARTITION BY order_id) AS max_price,
	MAX(unit_price) OVER(PARTITION BY order_id ORDER BY product_id) AS cum_max_price
FROM
	nw.order_items
	
-- order_items 테이블에서 order_id 별 상품 최소 구매금액, order_id별 상품 누적 최소 구매금액
SELECT
	*,
	MIN(unit_price) OVER(PARTITION BY order_id) AS min_price,
	MIN(unit_price) OVER(PARTITION BY order_id ORDER BY product_id) AS cum_min_price
FROM
	nw.order_items
	
-- order_items 테이블에서 order_id 별 상품 평균 구매금액, order_id별 상품 누적 평균 구매금액
SELECT
	*,
	AVG(unit_price) OVER(PARTITION BY order_id) AS avg_price,
	AVG(unit_price) OVER(PARTITION BY order_id ORDER BY product_id) AS cum_avg_price
FROM
	nw.order_items