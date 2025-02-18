-- 직원 정보 및 부서별로 직원 급여의 hiredate순으로 누적 급여합
SELECT
	*,
	SUM(sal) OVER (PARTITION BY deptno ORDER BY hiredate) AS sum_sal
FROM
	hr.emp
	
-- 직원 정보 및 부서별 평균 급여와 개인 급여와의 차이 출력
SELECT
	*,
	sal - AVG(sal) OVER (PARTITION BY deptno) AS diff_sal
FROM
	hr.emp
	
-- analytic을 사용하지 않고 위와 동일한 결과 출력
WITH a AS (
	SELECT
		deptno,
		AVG(sal) AS avg_sal
	FROM
		hr.emp
	GROUP BY
		deptno
)
SELECT
	emp.deptno,
	emp.sal,
	a.avg_sal,
	emp.sal - a.avg_sal AS diff_sal
FROM
	hr.emp
	LEFT JOIN a ON emp.deptno = a.deptno
ORDER BY
	deptno
	
-- 직원 정보 및 부서별 총 급여 대비 개인 급여의 비율 출력(소수점 2자리까지로 비율 출)
SELECT
	*,
	SUM(sal) OVER (PARTITION BY deptno) AS total_sal,
	ROUND(sal / (SUM(sal) OVER (PARTITION BY deptno)), 2) AS sal_ratio
FROM
	hr.emp
	
-- 직원 정보 및 부서에서 가장 높은 급여 대비 비율 출력 (소수점 2자리까지로 비율 출)
SELECT
	*,
	MAX(sal) OVER (PARTITION BY deptno) AS max_sal,
	ROUND(sal / MAX(sal) OVER (PARTITION BY deptno), 2) AS max_sal_ratio
FROM
	hr.emp