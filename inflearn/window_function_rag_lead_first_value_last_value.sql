-- lag() - 현재 행보다 이전 행의 데이터를 가져옴. 동일 부서에서 hiredate순으로 ename을 가져옴
SELECT
	deptno,
	hiredate,
	ename,
	LAG(ename) OVER (PARTITION BY deptno ORDER BY hiredate)
FROM
	hr.emp
	
-- lead() - 현재 행보다 다음 행의 데이터를 가져옴. 동일 부서에서 hiredate순으로 다음 ename을 가져옴
SELECT
	deptno,
	hiredate,
	ename,
	LEAD(ename) OVER (PARTITION BY deptno ORDER BY hiredate) AS lead_name
FROM
	hr.emp
	
-- lag() over (order by desc)는 lead() over (order by asc)와 동일하게 동작하므로 혼돈을 방지하기 위해 order by asc로 통일하는것이 좋음
SELECT
	deptno,
	hiredate,
	ename,
	LAG(ename) OVER (PARTITION BY deptno ORDER BY hiredate DESC) AS desc_lag,
	LEAD(ename) OVER (PARTITION BY deptno ORDER BY hiredate) AS asc_lead
FROM
	hr.emp
	
-- lag 적용 시 windows에서 가져올 값이 없을 경우 default 값을 설정할 수 있음. 이 경우 반드시 offset을 정해 줘야함
SELECT
	empno,
	deptno,
	hiredate,
	ename,
	LAG(ename, 1, 'No Previous') OVER (PARTITION BY deptno ORDER BY hiredate) AS prev_ename
FROM
	hr.emp
	
-- Null 처리를 아래와 같이 수행할 수도 있음.
SELECT
	deptno,
	hiredate,
	ename,
	COALESCE (LAG(ename) OVER (PARTITION BY deptno ORDER BY hiredate), 'No Previous') AS prev_ename
FROM
	hr.emp
	
-- 현재일과 이전일매출데이터와 그차이를 출력. 이전일 매출 데이터가 없을 경우 현재일 매출 데이터를 출력하고, 차이는 0
WITH temp_01 AS (
	SELECT
		DATE_TRUNC('day', nw.orders.order_date)::date AS ord_date,
		SUM(amount) AS total_amount
	FROM
		nw.order_items
		LEFT JOIN nw.orders ON nw.order_items.order_id = nw.orders.order_id
	GROUP BY
		DATE_TRUNC('day', nw.orders.order_date)::date
)
SELECT
	ord_date,
	total_amount,
	LAG(total_amount, 1, total_amount) OVER (ORDER BY ord_date) AS lagged_amount,
	total_amount - LAG(total_amount, 1, total_amount) OVER (ORDER BY ord_date) AS diff_amount
FROM	
	temp_01
ORDER BY
	ord_date
	
-- 부서별로 가장 hiredate가 오래된 사람의 sal 가져오기
SELECT
	deptno,
	hiredate,
	sal,
	FIRST_VALUE(sal) OVER (PARTITION BY deptno ORDER BY hiredate)
FROM
	hr.emp
	
-- 부서별로 가장 hiredate가 최근인 사람의 sal 가져오기. windows 절이 rows between unbounded preceding and unbounded following이 되어야 함.
SELECT
	deptno,
	hiredate,
	sal,
	FIRST_VALUE(sal) OVER (PARTITION BY deptno ORDER BY hiredate DESC)
FROM
	hr.emp
-- last_value() over (order by asc) 대신 first_value() over (order by desc)를 적용 가
	