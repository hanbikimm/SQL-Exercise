--*
--* 4.1. 순위와 번호를 표시하는 다양한 함수
--*


USE HRDB2
GO


--*
--* 4.1.1. RANK 함수
--*


-- [소스 4-1] 전체 급여 순위 표시

SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary, 
	   RANK() OVER(ORDER BY Salary DESC) AS [Rnk]
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
   ORDER BY Salary DESC
GO


-- [소스 4-2] 남녀별 급여 순위 표시

SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary, 
	   RANK() OVER(PARTITION BY Gender ORDER BY Salary DESC) AS [Rnk]
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
   ORDER BY Gender ASC, Salary DESC
GO


-- [소스 4-3] 입사일 순으로 순위 표시

SELECT EmpID, EmpName, HireDate, DeptID, Gender, Phone, Salary, 
	   RANK() OVER(ORDER BY HireDate DESC) AS [Rnk]
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
   ORDER BY HireDate DESC
GO


-- [소스 4-4] 직원별 휴가 일수 합계 조회

SELECT EmpID, SUM(Duration) AS [Tot_Duration]
	FROM dbo.Vacation
	GROUP BY EmpID
GO


-- [소스 4-5] 휴가 일수 합계 순위 조회

SELECT EmpID, SUM(Duration) AS [Tot_Duration],
	   RANK() OVER(ORDER BY SUM(Duration) DESC) AS [Rnk]
	FROM dbo.Vacation
	GROUP BY EmpID
	ORDER BY SUM(Duration) DESC
GO



--*
--* 4.1.2. DENSE_RANK 함수
--*


-- [소스 4-6] 전체 급여 순위 표시

SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary, 
	   DENSE_RANK() OVER(ORDER BY Salary DESC) AS [Rnk]
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
   ORDER BY Salary DESC
GO


-- [소스 4-7] 남녀별 급여 순위 표시

SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary, 
	   DENSE_RANK() OVER(PARTITION BY Gender ORDER BY Salary DESC) AS [Rnk]
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
   ORDER BY Gender ASC, Salary DESC
GO



--*
--* 4.1.3. ROW_NUMBER 함수
--*


-- [소스 4-8] 전체 번호 표시

SELECT ROW_NUMBER() OVER(ORDER BY EmpID ASC) AS [Num],
		EmpID, EmpName, DeptID, Gender, Phone, Salary
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
   ORDER BY EmpID ASC
GO


-- [소스 4-9] 남녀별 번호 표시

SELECT ROW_NUMBER() OVER(PARTITION BY Gender ORDER BY EmpID ASC) AS [Num],
		EmpID, EmpName, DeptID, Gender, Phone, Salary
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
   ORDER BY Gender ASC, EmpID ASC
GO


-- [소스 4-10] 2014년 10월 휴가 현황 조회

SELECT ROW_NUMBER() OVER(ORDER BY BeginDate ASC) AS [Num],
	EmpID, BeginDate, EndDate, Reason, Duration
	FROM dbo.Vacation
	WHERE BeginDate BETWEEN '2014-10-01' AND '2014-10-31'
	ORDER BY BeginDate ASC
GO



--*
--* 4.1.4. NTILE 함수
--*


-- [소스 4-11] 전체 급여순 범위 표시

SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary,
		NTILE(3) OVER(ORDER BY Salary DESC) AS [Num]
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
GO


-- [소스 4-12] 남녀별 급여순 범위 표시

SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary,
		NTILE(3) OVER(PARTITION BY Gender ORDER BY Salary DESC) AS [Num]
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
GO