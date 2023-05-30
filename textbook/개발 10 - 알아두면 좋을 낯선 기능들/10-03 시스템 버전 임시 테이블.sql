--*
--* 10.3. 시스템 버전 임시 테이블(System-Versioned Temporal Table)
--*


USE HRDB2
GO


--*
--* 10.3.1. 시스템 버전 임시 테이블 만들기 
--*


-- [소스 10-17] 시스템 버전 임시 테이블 만들기

CREATE TABLE dbo.Employee (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(4) NOT NULL,
	EngName varchar(20) NULL,
	Gender char(1) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NULL,
	DeptID char(3) REFERENCES Department(DeptID) NOT NULL,
	Phone char(13) UNIQUE NOT NULL,
	EMail varchar(50) UNIQUE NOT NULL,
	Salary int NULL,
	SysStartTime datetime2 GENERATED ALWAYS AS ROW START NOT NULL, 
	SysEndTime datetime2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime) 
) 
WITH (   
	SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Employee2History)   
) 
GO



--*
--* 10.3.2. 기존 테이블을 시스템 버전 임시 테이블로 변경
--*


-- [소스 10-18] 기존 테이블을 시스템 버전 임시 테이블로 변경

ALTER TABLE dbo.Employee
   ADD   
      SysStartTime datetime2 GENERATED ALWAYS AS ROW START HIDDEN    
           CONSTRAINT DF_SysStart DEFAULT SYSUTCDATETIME() NOT NULL,
      SysEndTime datetime2 GENERATED ALWAYS AS ROW END HIDDEN    
           CONSTRAINT DF_SysEnd DEFAULT '9999-12-31 23:59:59.9999999' NOT NULL,   
      PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime);   
GO   

ALTER TABLE dbo.Employee   
   SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory))   
GO



--*
--* 10.3.3. 추가한 열 확인
--*


-- [소스 10-19] 기존 쿼리문으로 확인

SELECT *
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO


-- [소스 10-20] 열 이름 지정하여 확인

SELECT EmpID, EmpName, EngName, Gender, DeptID, SysStartTime, SysEndTime
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO



--*
--* 10.3.4. 데이터 변경
--*


-- [소스 10-21] 데이터 변경

-- 최사모 이메일 변경
UPDATE dbo.Employee
	SET EMail = 'samonim@dbnuri.com'
	WHERE EmpID = 'S0009'
GO

-- 최사모 전화번호 변경
UPDATE dbo.Employee
	SET Phone = '010-8899-9999'
	WHERE EmpID = 'S0009'
GO

-- 홍길동 이름 변경
UPDATE dbo.Employee
	SET EmpName = N'홍길서'
	WHERE EmpID = 'S0001'
GO

-- 최사모 이메일 변경
UPDATE dbo.Employee
	SET EMail = 'choisamonim@dbnuri.com'
	WHERE EmpID = 'S0009'
GO

-- 홍길동 급여 변경
UPDATE dbo.Employee
	SET Salary = 9000
	WHERE EmpID = 'S0001'
GO

-- 최사모 이메일 변경
UPDATE dbo.Employee
	SET EMail = 'samochoi@dbnuri.com'
	WHERE EmpID = 'S0009'
GO

-- 최사모 퇴사 처리
UPDATE dbo.Employee
	SET RetireDate = '2016-11-30'
	WHERE EmpID = 'S0009'
GO



--*
--* 10.3.5. 테이블에 기록된 정보 확인
--*


-- [소스 10-22] 테이블 현재 데이터 확인

SELECT EmpID, EmpName, RetireDate, Phone, EMail, Salary, SysStartTime, SysEndTime
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO


-- [소스 10-23] 기록 테이블 확인

SELECT EmpID, EmpName, RetireDate, Phone, EMail, Salary, SysStartTime, SysEndTime
	FROM dbo.EmployeeHistory
	WHERE DeptID = 'SYS'
GO



--*
--* 10.3.6. AS OF 구문으로 특정 시점 데이터 확인
--*


-- [소스 10-24] 특정 시점 데이터 확인 #1

SELECT EmpID, EmpName, RetireDate, Phone, EMail, Salary, SysStartTime, SysEndTime
	FROM dbo.Employee
	FOR SYSTEM_TIME AS OF '2016-12-12 14:27:00'
	WHERE DeptID = 'SYS'
	ORDER BY EmpID ASC
GO


-- [소스 10-25] 특정 시점 데이터 확인 #2

SELECT EmpID, EmpName, RetireDate, Phone, EMail, Salary, SysStartTime, SysEndTime
	FROM dbo.Employee
	FOR SYSTEM_TIME AS OF '2016-12-12 14:28:30'
	WHERE DeptID = 'SYS'
	ORDER BY EmpID ASC
GO



--*
--* 10.3.7. 변경 기록 확인
--*


-- [소스 10-26] CONTAINED IN 사용

DECLARE @Start datetime2 = '2016-12-12 14:27:00.0000000'
DECLARE @End datetime2 = '2016-12-12 14:28:40.7037494'
SELECT EmpID, EmpName, EngName, DeptID, EMail, Phone, SysStartTime, SysEndTime
	FROM dbo.Employee
	FOR SYSTEM_TIME CONTAINED IN(@Start, @End)
	WHERE EmpID = 'S0009'
	ORDER BY SysStartTime ASC
GO


-- [소스 10-27] BETWEEN … AND 사용

DECLARE @Start datetime2 = '2016-12-13 02:51:45.2792746'
DECLARE @End datetime2 = '2016-12-13 02:52:05.5816841'
SELECT EmpID, EmpName, EngName, DeptID, EMail, Phone, SysStartTime, SysEndTime
	FROM dbo.Employee
	FOR SYSTEM_TIME BETWEEN @Start AND @End
	WHERE EmpID = 'S0009'
	ORDER BY SysStartTime ASC
GO


-- [소스 10-28] FROM … TO 사용

DECLARE @Start datetime2 = '2016-12-12 14:27:00.0000000'
DECLARE @End datetime2 = '2016-12-12 14:28:40.7037494'
SELECT EmpID, EmpName, EngName, DeptID, EMail, Phone, SysStartTime, SysEndTime
	FROM dbo.Employee
	FOR SYSTEM_TIME FROM @Start TO @End
	WHERE EmpID = 'S0009'
	ORDER BY SysStartTime ASC
GO


-- [소스 10-29] ALL 사용

SELECT EmpID, EmpName, EngName, DeptID, EMail, Phone, SysStartTime, SysEndTime
	FROM dbo.Employee
	FOR SYSTEM_TIME ALL
	WHERE EmpID = 'S0009'
	ORDER BY SysStartTime ASC
GO



--*
--* 10.3.8. 시스템 버전 관리 중지
--*


-- [소스 10-30] 임시로 시스템 버전 관리 중지

ALTER TABLE dbo.Employee 
	SET (SYSTEM_VERSIONING = OFF) 
GO

TRUNCATE TABLE dbo.EmployeeHistory
GO

ALTER TABLE dbo.Employee 
	SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory))  
GO


-- [소스 10-31] 영구적으로 시스템 버전 관리 중지

ALTER TABLE dbo.Employee 
	SET (SYSTEM_VERSIONING = OFF) 
GO

ALTER TABLE dbo.Employee
	DROP PERIOD FOR SYSTEM_TIME
GO