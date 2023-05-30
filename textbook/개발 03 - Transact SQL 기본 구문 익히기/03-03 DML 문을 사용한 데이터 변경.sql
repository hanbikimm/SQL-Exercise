--*
--* 3.3. DML 문을 사용한 데이터 변경
--*



USE HRDB2
GO


--*
--* 3.3.1. INSERT 문
--*


-- [소스 3-31] 행 INSERT(대상 열 이름 나열)

-- 대상 열 이름 나열
INSERT INTO dbo.Department(DeptID, DeptName, UnitID, StartDate)
   VALUES('PRD', N'상품', 'A', GETDATE())
GO

-- 확인
SELECT * FROM dbo.Department
GO


-- [소스 3-32] 행 INSERT(대상 열 이름 생략)

-- 대상 열 이름 생략
INSERT INTO dbo.Department
   VALUES('DBA', N'DB관리', 'A', GETDATE())
GO


-- [소스 3-33] 열 이름 나열이 필요한 이유

-- 실패
INSERT INTO dbo.Department 
   VALUES('CST', N'고객관리', GETDATE())
GO
/*
메시지 213, 수준 16, 상태 1, 줄 29
제공된 값의 개수나 열 이름이 테이블 정의와 일치하지 않습니다.
*/

-- 성공
INSERT INTO dbo.Department(DeptID, DeptName, StartDate)
   VALUES('CST', N'고객관리', GETDATE())
GO


-- [소스 3-34] 동시에 여러 행 INSERT

-- 여러 행 추가
INSERT INTO dbo.Department(DeptID, DeptName, UnitID, StartDate)
   VALUES('OPR', N'운영', 'A', GETDATE()), ('DGN', N'디자인', NULL, GETDATE())
GO

-- 확인
SELECT * FROM dbo.Department
GO


-- [소스 3-35] SELECT 결과 INSERT

-- 테이블 만들기
CREATE TABLE dbo.RetiredEmployee (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(4) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NOT NULL,
	EMail varchar(50)
)
GO

-- 데이터 추가
INSERT INTO dbo.RetiredEmployee
	SELECT EmpID, EmpName, HireDate, RetireDate, EMail
		FROM dbo.Employee
		WHERE RetireDate IS NOT NULL
GO

-- 확인
SELECT * FROM dbo.RetiredEmployee
GO


-- [소스 3-36] 저장 프로시저 실행 결과를 테이블에 INSERT

-- 저장 프로시저 만들기
CREATE PROC dbo.usp_GetVacation
	@EmpID char(5)
AS
	SELECT EmpID, BeginDate, EndDate, Duration, Reason
		FROM dbo.Vacation
		WHERE EmpID = @EmpID
GO

-- 임시 테이블 만들기
CREATE TABLE #Vacation (
   EmpID char(5),
   BeginDate date,
   EndDate date,
   Duration int,
   Reason nvarchar(50)
)
GO

-- 저장 프로시저 결과 추가
INSERT INTO #Vacation EXEC dbo.usp_GetVacation 'S0001'
GO

-- 확인
SELECT EmpID, BeginDate, EndDate, Duration, Reason
	FROM #Vacation
	WHERE Duration > 5
GO



--*
--* 3.3.2. UPDATE 문
--*


-- [소스 3-37] 전화번호 변경

-- 전화번호 변경
UPDATE dbo.Employee
   SET Phone = '010-1239-1239'
   WHERE EmpID = 'S0001'
GO

-- 확인
SELECT EmpID, EmpName, Gender, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE EmpID = 'S0001'
GO


-- [소스 3-38] FROM 절을 사용한 조건 지정

UPDATE dbo.Employee
   SET Salary = Salary * 0.8
   FROM dbo.Employee AS e
   WHERE (SELECT COUNT (*) 
            FROM dbo.Vacation 
		    WHERE EmpID = e.EmpID) > 10
GO



--*
--* 3.3.3. DELETE 문
--*


-- [소스 3-39] 2012년 이전 휴가 기록 삭제

DELETE dbo.Vacation
   WHERE EndDate <= '2011-12-31'
GO


-- [소스 3-40] TRUNCATE TABLE 문으로 모든 행 삭제

TRUNCATE TABLE dbo.Vacation
GO


-- [참고]

SELECT *
	FROM dbo.Vacation
	WHERE EndDate <= '2011-12-31'
GO

/*
DELETE dbo.Vacation
	WHERE EndDate <= '2011-12-31'
GO
*/