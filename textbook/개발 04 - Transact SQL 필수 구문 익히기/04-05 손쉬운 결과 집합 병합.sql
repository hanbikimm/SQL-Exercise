--*
--* 4.5. 손쉬운 결과 집합 병합
--*


USE HRDB2
GO


--*
--* 4.5.1. UNION, UNION ALL 문
--*


-- [소스 4-33] 2014년 입사한 직원 정보 조회

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31' 
GO


-- [소스 4-34] 급여를 7,000 이상 받는 직원 정보 조회

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE Salary >= 7000
GO


-- [소스 4-35] 2014년에 입사 했거나 급여를 7,000 이상 받는 직원 정보 조회

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31' 

UNION

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE Salary >= 7000
GO


-- [소스 4-36] 2014년에 입사 했거나 급여를 7,000 이상 받는 직원 정보 조회

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31' 

UNION ALL

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE Salary >= 7000
GO



--* 
--* 4.5.2. INTERSECT 문
--*


-- [소스 4-37] 2014년에 입사했으며 급여를 7,000 이상 받는 직원 정보 조회

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31' 

INTERSECT

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE Salary >= 7000
GO



--*
--* 4.5.3. EXCEPT 문
--*


-- [소스 4-38] 2014년에 입사했지만 급여를 7,000 이상 받으면 제외

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31' 

EXCEPT

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE Salary >= 7000
GO