--*
--* 3.4. 다양한 데이터 집계 방법
--*


USE HRDB2
GO


--*
--* 3.4.1. SUM, AVG, MAX, MIN, COUNT 함수
--*


-- [소스 3-41] 근무 중인 직원들의 급여 합 조회

SELECT SUM(Salary) AS [Tot_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL -- 결과: 90,900
GO


-- [소스 3-42] 근무 중인 직원 수 조회

SELECT COUNT(*) AS [Emp_Count]
	FROM dbo.Employee
	WHERE RetireDate IS NULL -- 결과: 16
GO


-- [소스 3-43] 근무 중인 직원들의 급여 최댓값, 최솟값, 최댓값 - 최솟값 조회

SELECT MAX(Salary) AS [Max_Salary], 
	   MIN(Salary) AS [Min_Salary],
	   MAX(Salary) - MIN(Salary) AS [Diff_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL
GO


-- [소스 3-44] 홍길동의 2014년 휴가 일수 합계 조회  

SELECT SUM(Duration) AS [Tot_Duration]
	FROM dbo.Vacation
	WHERE EmpID = 'S0001' 
		AND BeginDate BETWEEN '2014-01-01' AND '2014-12-31' -- 결과: 17
GO


-- [소스 3-45] 직원이 맨 처음 입사한 날짜 조회

SELECT MIN(HireDate) AS [Min_HireDate]
	FROM dbo.Employee
GO


-- [소스 3-46] 가장 최근에 직원이 입사한 날짜 조회

SELECT MAX(HireDate) AS [Max_HireDate]
	FROM dbo.Employee
GO


-- [소스 3-47] 근무 중인 직원의 평균 급여 조회

SELECT SUM(Salary) / COUNT(*) AS [Avg_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL -- 결과: 5,681
GO


-- [소스 3-48] 근무 중인 직원의 급여 평균 조회

SELECT AVG(Salary) AS [Avg_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL -- 결과: 6,060
GO
 
 
 -- [소스 3-49] 근무 중인 직원의 급여 평균 조회

SELECT AVG(ISNULL(Salary, 0)) AS [Avg_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL -- 결과: 5,681
GO
 

-- [소스 3-50] COUNT 집계 결과 비교

SELECT COUNT(EngName) AS [EngName_Count]
	FROM dbo.Employee  -- 결과: 14
GO

SELECT COUNT(*) AS [EngName_Count]
	FROM dbo.Employee
	WHERE EngName IS NOT NULL -- 결과: 14
GO



--*
--* 3.4.2. GROUP BY 문
--*


-- [소스 3-51] 근무 중인 부서별 직원 수 조회

SELECT DeptID, COUNT(*) AS [Emp_Count]
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
GO


-- [소스 3-52] 실패하는 GROUP BY 문

SELECT DeptID, EmpName, COUNT(*) AS [Emp_Count]
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
GO

/*
메시지 8120, 수준 16, 상태 1, 줄 79
열 'dbo.Employee.EmpName'이(가) 집계 함수나 GROUP BY 절에 없으므로 SELECT 목록에서 사용할 수 없습니다.
*/


-- [소스 3-53] 성공하는 GROUP BY 문

SELECT DeptID, MIN(EmpName) AS [First_EmpName], COUNT(*) AS [Emp_Count]
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
GO


-- [소스 3-54] 근무 중인 직원의 부서별 급여의 합 조회

SELECT DeptID, SUM(Salary) AS [Tot_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID 
GO


-- [소스 3-55] 근무 중인 직원의 부서별 급여 최댓값, 최솟값, 최댓값 - 최솟값 조회

SELECT DeptID, 
		MAX(Salary) AS [Max_Salary], 
		MIN(Salary) AS [Min_Salary],
		MAX(Salary) - MIN(Salary) AS [Diff_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
GO


-- [소스 3-56] 급여가 5,000보다 많은 부서별 직원 수 조회

SELECT DeptID, COUNT(EmpID) AS [Emp_Count]
	FROM dbo.Employee
	WHERE Salary > 5000
	GROUP BY DeptID
GO



--*
--* 3.4.3. HAVING 문
--*


-- [소스 3-57] HAVING 절 사용

SELECT DeptID, COUNT(*) AS [Emp_Count]
	FROM dbo.Employee
	GROUP BY DeptID
	HAVING COUNT(*) >= 3
GO


-- [소스 3-58] 근무 중인 직원의 부서별 평균 급여 조회

SELECT DeptID, AVG(Salary) AS [Avg_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
GO


-- [소스 3-59] 부서 평균 급여가 전사 평균 급여보다 많은 부서의 평균 급여 조회

SELECT DeptID, AVG(Salary) AS [Avg_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
	HAVING AVG(Salary) > (
		SELECT AVG(Salary) 
			FROM dbo.Employee 
			WHERE RetireDate IS NULL
	)
GO



--*
--* 3.4.4. GROUPING SETS 문
--*


-- [소스 3-60] 남녀별, 부서별 소계 조회

SELECT DeptID, Gender, SUM(Salary) AS [Tot_Salary]
	FROM dbo.Employee
	WHERE DeptID IN('SYS', 'MKT') AND RetireDate IS NULL
	GROUP BY GROUPING SETS(DeptID, Gender)
GO


-- [소스 3-61] 전체 집계 조회

SELECT DeptID, Gender, SUM(Salary) AS [Tot_Salary]
	FROM dbo.Employee
	WHERE DeptID IN('SYS', 'MKT') AND RetireDate IS NULL
	GROUP BY GROUPING SETS(DeptID, Gender, ())
GO


-- [소스 3-62] 부서 소계 + 전체 집계 조회

SELECT DeptID, Gender, SUM(Salary) AS [Tot_Salary]
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	GROUP BY GROUPING SETS((DeptID, Gender), (DeptID))
GO


-- [소스 3-63] 전체 집계 추가

SELECT DeptID, Gender, SUM(Salary) AS [Tot_Salary]
	FROM dbo.Employee
	WHERE DeptID IN('SYS', 'MKT') AND RetireDate IS NULL
	GROUP BY GROUPING SETS((DeptID, Gender), DeptID, ())
GO