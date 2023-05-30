--*
--* 4.7. 쿼리문 작성에 대한 단상
--*



--*
--* 4.7.1. 좋은 쿼리문
--*


-- [소스 4-52] 모순된 쿼리문

USE HRDB2
GO

-- 급여를 많이 받는 상위 5명
SELECT TOP (5) EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC
GO


-- [소스 4-53] 정확한 쿼리문

-- 급여를 많이 받는 상위 5명
SELECT TOP (5) WITH TIES EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC
GO
