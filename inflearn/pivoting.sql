-- GROUP BY 실습 - 04(Group by의 Aggregate 함수의 case when을 이용한 pivoting)
SELECT
	job,
	SUM(sal) AS sales_sum
FROM 
	hr.emp
GROUP BY
	job;

-- deptno로 groupby하고 job으로 pivoting
SELECT
	SUM(CASE WHEN job = 'SALESMAN' THEN sal	END) AS sales_sum,
	SUM(CASE WHEN job = 'MANAGER' THEN sal END) AS manager_sum,
	SUM(CASE WHEN job = 'ANALYST' THEN sal END) AS analyst_sum,
	SUM(CASE WHEN job = 'CLERK' THEN sal END) AS clerk_sum,
	SUM(CASE WHEN job = 'PRESIDENT' THEN sal END) AS president_sum
FROM
	hr.emp;
	

-- deptno + job 별로 group by
SELECT
	deptno,
	job,
	SUM(sal) AS sales_sum
FROM
	hr.emp
GROUP BY
	deptno,
	job
ORDER BY
	sales_sum DESC
	
SELECT
	deptno,
	SUM(CASE WHEN job = 'SALESMAN' THEN sal ELSE NULL END) AS sales_sum,
	SUM(CASE WHEN job = 'MANAGER' THEN sal ELSE NULL END) AS manager_sum,
	SUM(CASE WHEN job = 'ANALYST' THEN sal ELSE NULL END) AS analyst_sum, 
	SUM(CASE WHEN job = 'CLERK' THEN sal ELSE NULL END) AS clerk_sum,
	SUM(CASE WHEN job = 'PRESIDENT' THEN sal ELSE NULL END) AS president_sum
FROM
	hr.emp
GROUP BY
	deptno