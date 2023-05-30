--*
--* 8.4. 트리거(Triggers)
--*


USE HRDB2
GO


--*
--* 8.4.2. DML 트리거 만들기
--*


-- [소스 8-49] 잘못된 트리거

CREATE TRIGGER dbo.trg_Employee_S0009
	ON dbo.Employee
	AFTER DELETE
AS
	DECLARE @EmpID char(5)
	SELECT @EmpID = EmpID FROM Deleted
	IF @EmpID = 'S0009'
	BEGIN
		RAISERROR('최사모 직원이 포함된 삭제 작업은 수행될 수 없습니다', 16, 1)
		ROLLBACK TRANSACTION
	END
GO


-- [소스 8-50] 데이터 삭제 시도

DELETE dbo.Employee
	WHERE EmpID = 'S0009'
GO
/*
메시지 50000, 수준 16, 상태 1, 프로시저 trg_Employee_S0004, 줄 9 [배치 시작 줄 35]
최사모 직원이 포함된 삭제 작업은 수행될 수 없습니다
메시지 3609, 수준 16, 상태 1, 줄 36
트리거가 발생하여 트랜잭션이 종료되었습니다. 일괄 처리가 중단되었습니다.
*/


-- [소스 8-51] 데이터 삭제 시도

DELETE dbo.Employee	
	WHERE EmpID IN ('S0004', 'S0009', 'S0014')
GO


-- [소스 8-52] 삭제 확인

SELECT * FROM dbo.Employee
	WHERE EmpID = 'S0009'
GO


-- [소스 8-53] 데이터 복구

INSERT INTO dbo.Employee VALUES('S0004', N'김삼순', 'samsam', 'F', '2012-08-01', NULL, 'MKT', '010-3212-3212', 'samsoon@dbnuri.com',	7000)
INSERT INTO dbo.Employee VALUES('S0009', N'최사모', 'samoya', 'F', '2013-10-01', NULL, 'SYS', '010-8899-9988', 'samo@dbnuri.com', 5800)
INSERT INTO dbo.Employee VALUES('S0014', N'이최고', 'first', 'M', '2014-04-01', NULL, 'MKT', '010-2345-9886', 'one@dbnuri.com', 5000)
GO


-- [소스 8-54] 트리거 수정

ALTER TRIGGER dbo.trg_Employee_S0009
	ON dbo.Employee
	AFTER DELETE
AS
	IF EXISTS (SELECT * FROM Deleted WHERE EmpID = 'S0009')
	BEGIN
		RAISERROR('최사모 직원이 포함된 삭제 작업은 수행될 수 없습니다', 16, 1)
		ROLLBACK TRANSACTION
	END
GO


-- [소스 8-55] 데이터 삭제 시도

DELETE dbo.Employee	
	WHERE EmpID IN ('S0004', 'S0009', 'S0014')
GO
/*
메시지 50000, 수준 16, 상태 1, 프로시저 trg_Employee_S0009, 줄 7 [배치 시작 줄 84]
최사모 직원이 포함된 삭제 작업은 수행 될 수 없습니다
메시지 3609, 수준 16, 상태 1, 줄 85
트리거가 발생하여 트랜잭션이 종료되었습니다. 일괄 처리가 중단되었습니다.
*/


-- [소스 8-56] 트리거 제거

DROP TRIGGER dbo.trg_Employee_S0009
GO


-- [소스 8-57] 변경 이력 테이블 만들기

IF OBJECT_ID('dbo.EmployeeHistory', 'U') IS NOT NULL
	DROP TABLE dbo.EmployeeHistory
GO

CREATE TABLE dbo.EmployeeHistory (
	Seq int IDENTITY PRIMARY KEY,
	TranType char(1),
	TranDate datetime,
	EmpID char(5),
	EmpName nvarchar(4),
	EngName varchar(20),
	Gender char(1),
	HireDate date,
	RetireDate date,
	DeptID char(3),
	Phone char(13),
	EMail varchar(50),
	Salary int
)
GO


-- [소스 8-58] INSERT 트리거

CREATE TRIGGER dbo.trg_Employee_Insert
	ON dbo.Employee
	AFTER INSERT
AS
	SET NOCOUNT ON
	INSERT INTO dbo.EmployeeHistory
		SELECT 'I', GETDATE(), * FROM Inserted
GO


-- [소스 8-59] DELETE 트리거

CREATE TRIGGER dbo.trg_Employee_Delete
	ON dbo.Employee
	AFTER DELETE
AS
	SET NOCOUNT ON
	INSERT INTO dbo.EmployeeHistory
		SELECT 'D', GETDATE(), * FROM Deleted
GO


-- [소스 8-60] UPDATE 트리거

CREATE TRIGGER dbo.trg_Employee_Update
	ON dbo.Employee
	AFTER UPDATE
AS
	SET NOCOUNT ON
	INSERT INTO dbo.EmployeeHistory
		SELECT 'B', GETDATE(), * FROM Deleted
	INSERT INTO dbo.EmployeeHistory
		SELECT 'A', GETDATE(), * FROM Inserted
GO


-- [소스 8-61] 데이터 변경 처리

-- Insert문 수행
INSERT INTO dbo.Employee 
	VALUES('S0021', N'나처럼', 'nana', 'M', '2016-05-01', NULL, 'MKT', '010-7711-3311', 'nana@dbnuri.com', 4000)
GO

-- Update문 수행
UPDATE dbo.Employee
	SET EmpName = N'너처럼'
	WHERE EmpID = 'S0021'
GO
 
-- Delete문 수행
DELETE dbo.Employee
	WHERE EmpID = 'S0021'
GO


-- [소스 8-62] 변경 기록 확인

SELECT * FROM dbo.EmployeeHistory
GO


-- [소스 8-63] 트리거 제거

DROP TRIGGER dbo.trg_Employee_Insert
DROP TRIGGER dbo.trg_Employee_Update
DROP TRIGGER dbo.trg_Employee_Delete
GO


-- [소스 8-64] 문제의 쿼리문

INSERT INTO dbo.Employee 
	VALUES('S0021', N'나처럼', 'nana', 'M', '2016-05-01', NULL, 'NKT', '010-7711-3311', 'nana@dbnuri.com', 4000)
GO
/*
메시지 547, 수준 16, 상태 0, 줄 206
INSERT 문이 FOREIGN KEY 제약 조건 "FK__Employee__DeptID__2A4B4B5E"과(와) 충돌했습니다. 데이터베이스 "HRDB2", 테이블 "dbo.Department", column 'DeptID'에서 충돌이 발생했습니다.
문이 종료되었습니다.
*/


-- [소스 8-65] INSTEAD OF 트리거 만들기

CREATE TRIGGER dbo.trg_Employee_Instead
	ON dbo.Employee
	INSTEAD OF INSERT
AS
	SET NOCOUNT ON
	INSERT INTO dbo.Employee
		SELECT EmpID, EmpName, EngName, Gender, HireDate, RetireDate,
			   CASE DeptID WHEN 'NKT' THEN 'MKT' ELSE DeptID END, Phone, EMail, Salary
			FROM Inserted
GO


-- [소스 8-66] 트리거 동작 확인

INSERT INTO dbo.Employee 
	VALUES('S0021', N'나처럼', 'nana', 'M', '2016-05-01', NULL, 'NKT', '010-7711-3311', 'nana@dbnuri.com', 4000)
GO

SELECT * FROM dbo.Employee WHERE EmpID = 'S0021'
GO


-- [소스 8-67] 트리거 제거

DROP TRIGGER dbo.trg_Employee_Instead
GO



--*
--* 8.4.3. DDL 트리거 만들기
--*


-- [소스 8-68] 데이터베이스 영역의 DDL 트리거 만들기

USE HRDB2
GO

CREATE TRIGGER trg_Table01
	ON DATABASE 
	FOR DROP_TABLE, ALTER_TABLE 
AS 
	PRINT '테이블을 삭제 하거나 변경할 수 없습니다!!!' 
	ROLLBACK TRANSACTION
GO


-- [소스 8-69] DDL 트리거에 의해 DROP TABLE 문 강제 롤백

DROP TABLE dbo.Vacation
GO
/*
테이블을 삭제 하거나 변경할 수 없습니다!!!
메시지 3609, 수준 16, 상태 2, 줄 272
트리거가 발생하여 트랜잭션이 종료되었습니다. 일괄 처리가 중단되었습니다.
*/


-- [소스 8-70] FOREIGN KEY 제약이 우선적으로 체크됨

DROP TABLE dbo.Employee
GO
/*
메시지 3726, 수준 16, 상태 1, 줄 283
개체 'dbo.Employee'은(는) FOREIGN KEY 제약 조건에서 참조하므로 삭제할 수 없습니다.
*/


-- [소스 8-71] DDL 트리거에 의해 ALTER TABLE 문 강제 롤백

ALTER TABLE dbo.Employee
	ADD Facebook varchar(20) NULL
GO
/*
테이블을 삭제 하거나 변경할 수 없습니다!!!
메시지 3609, 수준 16, 상태 2, 줄 293
트리거가 발생하여 트랜잭션이 종료되었습니다. 일괄 처리가 중단되었습니다.
*/


-- [소스 8-72] 서버 영역의 트리거 만들기

CREATE TRIGGER trg_Login01
	ON ALL SERVER -- 서버 영역의 트리거임을 지정
	FOR CREATE_LOGIN 
AS 
	SET NOCOUNT ON
	SELECT EVENTDATA()
	PRINT '관리자의 허락없이 로그인 계정을 만들 수 없습니다!!!' 
	ROLLBACK TRANSACTION
GO


-- [소스 8-73] DDL 트리거에 의해 CREATE LOGIN 문 강제 롤백

CREATE LOGIN James
	WITH PASSWORD = 'Pa$$w0rd'
GO
/*
관리자의 허락없이 로그인 계정을 만들 수 없습니다!!!
메시지 3609, 수준 16, 상태 2, 줄 321
트리거가 발생하여 트랜잭션이 종료되었습니다. 일괄 처리가 중단되었습니다.
*/


-- [소스 8-74] EVENTDATA 함수가 XML 형태로 보여주는 값

/*
<EVENT_INSTANCE>
  <EventType>CREATE_LOGIN</EventType>
  <PostTime>2016-11-04T09:52:52.877</PostTime>
  <SPID>53</SPID>
  <ServerName>JUHEE</ServerName>
  <LoginName>JUHEE\Administrator</LoginName>
  <ObjectName>James</ObjectName>
  <ObjectType>LOGIN</ObjectType>
  <DefaultLanguage>한국어</DefaultLanguage>
  <DefaultDatabase>master</DefaultDatabase>
  <LoginType>SQL Login</LoginType>
  <SID>THJg9Bqb20CXc3XIOeGDrw==</SID>
  <TSQLCommand>
    <SetOptions ANSI_NULLS="ON" ANSI_NULL_DEFAULT="ON" ANSI_PADDING="ON" QUOTED_IDENTIFIER="ON" ENCRYPTED="FALSE" />
    <CommandText>CREATE LOGIN James
	WITH PASSWORD = '******'
</CommandText>
  </TSQLCommand>
</EVENT_INSTANCE>
*/


-- [소스 8-75] 트리거 비활성화 및 활성화

DISABLE TRIGGER trg_Login01
	ON ALL SERVER 
GO

CREATE LOGIN James
	WITH PASSWORD = 'Pa$$w0rd'
GO

ENABLE TRIGGER trg_Login01
	ON ALL SERVER 
GO


-- [소스 8-76] 트리거 삭제

USE HRDB2
GO

DROP TRIGGER trg_Table01
	ON DATABASE 
GO

DROP TRIGGER trg_Login01
	ON ALL SERVER 
GO

DROP LOGIN James
GO