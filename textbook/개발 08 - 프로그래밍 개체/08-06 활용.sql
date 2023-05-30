--*
--* 8.6. 활용
--*


USE HRDB2
GO


--*
--* 8.6.1. CREATE OR ALTER
--*


-- [소스 8-80] 기존의 방법

IF OBJECT_ID('dbo.usp_DeptEmployee', 'P') IS NOT NULL
	DROP PROC dbo.usp_DeptEmployee
GO

CREATE PROC dbo.usp_DeptEmployee
	@DeptID char(3)
AS
	SELECT EmpID, EmpName, Gender, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE RetireDate IS NULL AND DeptID = @DeptID
GO


-- [소스 8-81] CREATE OR ALTER 문 사용

CREATE OR ALTER PROC dbo.usp_DeptEmployee
	@DeptID char(3)
AS
	SELECT EmpID, EmpName, Gender, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE RetireDate IS NULL AND DeptID = @DeptID
GO



--*
--* 8.6.2. 뷰 새로 고침(Refresh)
--*


-- [소스 8-82] 뷰 만들기

CREATE VIEW dbo.vw_FemaleEmployee
AS
SELECT * 
	FROM dbo.Employee
	WHERE Gender = 'F' AND RetireDate IS NULL
GO

SELECT * FROM dbo.vw_FemaleEmployee
GO


-- [소스 8-83] 열 추가

ALTER TABLE dbo.Employee
	ADD Facebook varchar(60) NULL
GO


-- [소스 8-84] 일반 쿼리문 결과 확인

SELECT * 
	FROM dbo.Employee
	WHERE Gender = 'F' AND RetireDate IS NULL
GO


-- [소스 8-85] 뷰 확인

SELECT * FROM dbo.vw_FemaleEmployee
GO

-- [소스 8-86] 열 제거

ALTER TABLE dbo.Employee
	DROP COLUMN EngName
GO


-- [소스 8-87] 뷰 확인

SELECT * FROM dbo.vw_FemaleEmployee
GO


-- [소스 8-88] 뷰 새로 고침

EXEC sp_refreshview 'dbo.vw_FemaleEmployee'
GO

SELECT * FROM dbo.vw_FemaleEmployee
GO



--*
--* 8.6.3. 자동으로 실행되는 저장 프로시저
--*


-- [소스 8-89] 자동으로 실행할 저장 프로시저 만들기

USE master
GO

CREATE PROC dbo.usp_CopyEmployee
AS
BEGIN
	IF OBJECT_ID('HRDB2.dbo.Employee_bak', 'U') IS NOT NULL
		DROP TABLE HRDB2.dbo.Employee_bak
	SELECT *
		INTO HRDB2.dbo.Employee_bak
		FROM HRDB2.dbo.Employee
END
GO


-- [소스 8-90] 자동으로 실행하도록 설정

USE master
GO

-- 자동 시작 옵션 변경
EXEC sp_procoption 
	@ProcName = 'dbo.usp_CopyEmployee', 
	@OptionName = 'startup',   
	@OptionValue = 'on'
GO

-- 자동 시작 저장 프로시저 확인
SELECT name, type_desc, create_date, modify_date
	FROM sys.procedures 
	WHERE is_auto_executed = 1
GO

-- [소스 8-91] 자동으로 실행하지 않도록 설정

USE master
GO

EXEC sp_procoption 
	@ProcName = 'dbo.usp_CopyEmployee',  
	@OptionName = 'startup',	
	@OptionValue = 'off'
GO 



--*
--* 8.6.4. 동적 쿼리문, 나름의 디버깅
--*


-- [소스 8-92] 자동으로 실행하지 않도록 설정

IF OBJECT_ID('dbo.usp_GetEmployee_New', 'P') IS NOT NULL
	DROP PROC dbo.usp_GetEmployee_New
GO

CREATE PROC dbo.usp_GetEmployee_New
	@DeptID char(3) = '',
	@Retired char(1) = '',
	@Debug int = 0
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @str varchar(2000)
	SET @str = 'SELECT EmpID, EmpName, Gender, DeptID, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE 1 = 1 '
	IF ISNULL(@DeptID,'') <> ''
		SET @str = @str + ' AND DeptID = ''' + @DeptID + ''''
	IF @Retired = 'Y'
		SET @str = @str + ' AND RetireDate IS NOT NULL'
	IF @Retired = 'N'
		SET @str = @str + ' AND RetireDate IS NULL'
	IF @Debug = 1
		PRINT @str
	ELSE
		EXECUTE(@str)		
END
GO


-- [소스 8-93] 저장 프로시저 정상 호출

EXEC dbo.usp_GetEmployee_New @DeptID = 'MKT', @Retired = 'Y', @Debug = 0
GO
-- 또는
EXEC dbo.usp_GetEmployee_New @DeptID = 'MKT', @Retired = 'Y'
GO


-- [소스 8-94] 디버그 모드로 저장 프로시저 호출

EXEC dbo.usp_GetEmployee_New @DeptID = 'MKT', @Retired = 'Y', @Debug = 1
GO
/*
SELECT EmpID, EmpName, Gender, DeptID, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE 1 = 1  AND DeptID = 'MKT' AND RetireDate IS NOT NULL
*/