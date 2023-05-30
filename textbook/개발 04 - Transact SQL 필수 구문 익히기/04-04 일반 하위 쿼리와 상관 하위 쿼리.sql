--*
--* 4.4. 일반 하위 쿼리와 상관 하위 쿼리
--*


USE HRDB2
GO


--*
--* 4.4.1. 일반 하위 쿼리
--*


-- [소스 4-26] 가장 많은 급여를 받는 직원 정보 조회

SELECT EmpID, EmpName, DeptID, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE Salary = (SELECT MAX(Salary) FROM dbo.Employee)
GO


-- [소스 4-27] 휴가를 간 적이 있는 직원 정보 조회

SELECT EmpID, EmpName, DeptID, Phone, EMail
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
	AND EmpID IN (SELECT EmpID FROM dbo.Vacation) 
GO


-- [소스 4-28] 가장 최근에 퇴사한 직원 정보 조회

SELECT EmpID, EmpName, DeptID, Gender, HireDate, RetireDate, Phone 
	FROM dbo.Employee
	WHERE RetireDate = (SELECT MAX(RetireDate) FROM dbo.Employee)
GO



--*
--* 4.4.2. 상관 하위 쿼리
--*


-- [소스 4-29] 부서 이름을 포함해서 직원 정보 조회

SELECT EmpID, EmpName, DeptID, (SELECT DeptName FROM dbo.Department
	  WHERE DeptID = e.DeptID) AS [DeptName], Phone, Salary
	FROM dbo.Employee AS e
	WHERE Salary > 7000
GO


-- [소스 4-30] 휴가를 간 적이 있는 직원 정보 조회

SELECT EmpID, EmpName, DeptID, Phone, EMail
	FROM dbo.Employee e
	WHERE DeptID = 'SYS'
	AND EXISTS(
		SELECT * 
			FROM dbo.Vacation 
			WHERE EmpID = e.EmpID
	)
GO


-- [소스 4-31] 휴가를 간 적이 없는 직원 정보 조회

SELECT EmpID, EmpName, DeptID, Phone, EMail
	FROM dbo.Employee e
	WHERE DeptID = 'SYS'
		AND NOT EXISTS (
			SELECT * 
                FROM dbo.Vacation 
                WHERE EmpID = e.EmpID
		)
GO


-- [소스 4-32] 각 부서별로 가장 먼저 입사한 직원 정보 조회

SELECT EmpID, EmpName, DeptID, Gender, HireDate, Phone, EMail
	FROM dbo.Employee AS e
	WHERE HireDate = (
		SELECT MIN(HireDate) 
			FROM dbo.Employee
			WHERE DeptID = e.DeptID
	)
	ORDER BY EmpID ASC
GO