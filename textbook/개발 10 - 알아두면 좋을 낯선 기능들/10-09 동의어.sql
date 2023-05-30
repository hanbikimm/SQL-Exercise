--*
--* 10.9. 동의어(Synonyms)
--*



--*
--* 10.9.1. 동의어 만들기
--*


-- [소스 10-59] 동의어 만들기

USE HRDB2
GO

-- 서버 이름, 데이터베이스 이름 입력
CREATE SYNONYM dbo.본부
	FOR DREAM.HRDB2.dbo.Unit
GO

-- 서버 이름, 데이터베이스 이름 생략
CREATE SYNONYM dbo.부서
	FOR dbo.Department
GO

CREATE SYNONYM dbo.직원
	FOR dbo.Employee
GO

CREATE SYNONYM dbo.휴가
	FOR dbo.Vacation
GO



--*
--* 10.9.2. 동의어 사용
--*


-- [소스 10-60] 동의어 사용

USE HRDB2
GO

SELECT e.EmpID, e.EmpName, e.Gender, e.DeptID, d.DeptName, e.HireDate, e.EMail
	FROM dbo.직원 AS e
	INNER JOIN dbo.부서 AS d ON e.DeptID = d.DeptID
	WHERE e.DeptID = 'SYS' AND RetireDate IS NULL
GO