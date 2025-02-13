-- 회사내 근무 기간 순위(hiredate) : 공동 순위가 있을 경우 차순위는 밀려서 순위 정함
SELECT
	*
FROM 
	hr.emp

WITH a AS (
	SELECT
		*,
		TO_CHAR(NOW() - emp.hiredate, 'dd') AS work_days
	FROM
		hr.emp
)
SELECT
	*,
	RANK() OVER(ORDER BY work_days DESC)
FROM
	a

-- 부서별로 가장 급여가 높은/낮은 순으로 순위 : 공동 순위 시 차순위는 밀리지 않음
SELECT
	*,
	DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) AS sal_rank_desc,
	DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal) AS sal_asc
FROM
	hr.emp
	
-- 부서별 가장 급여가 높은 직원 정보 : 공동 순위는 없으며 반드시 고유 순위를 정함
WITH a AS (
	SELECT
		*,
		ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) AS sal_rank
	FROM
		hr.emp
)
SELECT
	empno,
	ename,
	deptno,
	sal_rank
FROM
	a
WHERE
	sal_rank = 1
	
-- 부서별 급여 top2 직원 정보 : 공동 순위는 없으며 반드시 고유 순위를 정함
WITH a AS (
	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) AS sal_rank
	FROM
		hr.emp
)
SELECT
	empno,
	ename,
	job,
	sal,
	deptno,
	sal_rank
FROM
	a
WHERE
	sal_rank IN (1, 2)
	
-- 부서별 가장 급여가 높은 직원과 가장 급여가 낮은 직원 정보. 그리고 두 직원의 급여 차이도 함께 추출. 공동 순위는 없으며 반드시 고유 순위를 정함
WITH temp01 AS (
	SELECT
		*,
		CASE
			WHEN sal_desc = 1 THEN 'top'
			WHEN sal_asc = 1 THEN 'bottom'
			ELSE 'middle'
		END AS lv
	FROM (
		SELECT
			*,
			ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) AS sal_desc,
			ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) AS sal_asc
		FROM
			hr.emp
	) AS a
	WHERE
		sal_desc = 1 OR sal_asc = 1
), temp02 AS (
SELECT
	deptno,
	MAX(sal) - MIN(sal) AS diff
FROM
	temp01
GROUP BY
	deptno
)
SELECT
	*
FROM
	temp01
	LEFT JOIN temp02 ON temp01.deptno = temp02.deptno

-- 회사내 커미션 높은 순위, rank와 row_number 모두 추출
	SELECT
		comm,
		RANK() OVER (ORDER BY comm DESC NULLS LAST) AS comm_rank,
		ROW_NUMBER() OVER (ORDER BY comm DESC NULLS LAST) AS comm_row_number
	FROM
		emp
