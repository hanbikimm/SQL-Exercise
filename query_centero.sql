ALTER TABLE TB_TEST
	ADD USE_YN CHAR(1) NOT NULL DEFAULT ('Y')

ALTER TABLE TB_TEST
	DROP COLUMN DELETE_YN 

ALTER TABLE TB_TEST
	ADD TEST_DATE DATETIME DEFAULT(GETDATE()) NOT NULL


USE 'STD_DB'
 

INSERT INTO 'dbo'.'TB_TEST'
     VALUES
           (2
           ,getdate()
           ,'Y'
           ,getdate()
		   )
-- 



ALTER TABLE TB_TEST
	ADD TEST_SEQ BIGINT IDENTITY(3,2) NOT NULL

SELECT * FROM TB_테스트

ALTER TABLE TB_TEST
	ALTER COLUMN TST_YN char(2) not null


exec sp_rename 'dbo.TB_TEST.TST_YN' , 'USE_YN'
exec sp_rename 'dbo.TB_TEST' , 'TB_테스트'

DROP TABLE TB_테스트

CREATE TABLE TB_TEST01
(
	TST_SEQ INT IDENTITY(1,1) NOT NULL
	, USE_YN CHAR(1) COLLATE KOREAN_WANSUNG_CS_AS
)

--INT는 문자열이 아니기에 적절하지 않음
--ALTER TABLE TB_TEST01
--	ALTER COLUMN TST_SEQ BIGINT COLLATE KOREAN_WANSUNG_CS_AS


INSERT INTO TB_TEST01
	VALUES('y')


-- 명시적 묵시적

-- 변수 선언
declare @a decimal(6,3) = 122.2121

select @a

SELECT SERVERPROPERTY('COLLATION')

SELECT DATABASEPROPERTYEX('STD_DB', 'COLLATION')

SELECT COLLATION_NAME FROM SYS.DATABASES 
	WHERE NAME = 'STD_DB'

SELECT * FROM TB_TEST01

SELECT * FROM TB_TEST01
	WHERE USE_YN = 'y'

--DECLARE @num int
--SET @num = 45000
--SET @num += 55000
--SELECT @num as num

DECLARE @num BIGINT
SET @num = 45000
SET @num *= 55000
SELECT @num

DECLARE @dec decimal(15,5)
SET @dec = 123456789.123456
SELECT @dec
--SET @dec = 123456789213.1234567
--SELECT @dec

DECLARE @dt01 datetime
DECLARE @dt02 smalldatetime
DECLARE @dt03 date
DECLARE @dt04 time
DECLARE @dt05 datetime2
DECLARE @dt06 datetimeoffset

SET @dt01 = GETDATE()
SET @dt02 = GETDATE()
SET @dt03 = SYSDATETIME()
SET @dt04 = SYSDATETIME()
SET @dt05 = SYSDATETIME()
SET @dt06 = SYSDATETIMEOFFSET()

SELECT @dt01 AS 'datetime' 
SELECT @dt02 AS 'smalldatetime'
SELECT @dt03 AS 'date' 
SELECT @dt04 AS 'time' 
SELECT @dt05 AS 'datetime2'
SELECT @dt06 AS 'datetimeoffset'


DECLARE @dt1 time(1)
DECLARE @dt2 datetime2(3)
DECLARE @dt3 datetimeoffset(4)

SET @dt1 = SYSDATETIME()
SET @dt2 = SYSDATETIME()
SET @dt3 = SYSDATETIMEOFFSET()

SELECT @dt1 AS 'time' 
SELECT @dt2 AS 'datetime2' 
SELECT @dt3 AS 'datetimeoffset'


DECLARE
@mon1 MONEY,
@mon2 MONEY,
@mon3 MONEY,
@mon4 MONEY,
@num1 DECIMAL(19,5), --고정소수점
@num2 DECIMAL(19,5),
@num3 DECIMAL(19,5),
@num4 DECIMAL(19,5),
@flo1 float, --부동소수점
@flo2 float,
@flo3 float,
@flo4 float

-- 값의 할당
SELECT @mon1 = 100, @mon2 = 339, @mon3 = 10000,
          @num1 = 100, @num2 = 339, @num3 = 10000,
          @flo1 = 100, @flo2 = 339, @flo3 = 10000
-- 연산
SET @mon4 = @mon1/@mon2*@mon3
SET @num4 = @num1/@num2*@num3
SET @flo4 = @flo1/@flo2*@flo3

SELECT @mon4 AS moneyresult
          , @num4 AS decimalresult
          , @flo4 AS floatresult

declare @str01 char(20) = 'gildong!'
declare @str02 varchar(20) = 'gildong!'
SELECT DATALENGTH(@str01) AS 'datalength char'
SELECT DATALENGTH(@str02) AS 'datalength varchar'

declare @str1 varchar(20) = '홍길동은 일지매를 알지 못한다.'
declare @str2 nvarchar(20) = N'홍길동은 일지매를 알지 못한다.'
SELECT @str1 AS 'RESULT'
SELECT @str2 AS 'RESULT'


DECLARE @TBL table(
	empID char(5),
	empName nvarchar(10),
	email varchar(60)
)
INSERT INTO @TBL VALUES('S0001', N'SON', 'son@mosti.com')
INSERT INTO @TBL VALUES('S0002', N'KIM', 'kim@mosti.com')
INSERT INTO @TBL VALUES('S0003', N'LEE', 'lee@mosti.com')
SELECT * FROM @TBL


CREATE TABLE Member(
	empID char(5),
	empName nvarchar(10),
	email varchar(60),
	uniqueID uniqueidentifier
)
INSERT INTO Member VALUES('S0001', N'SON', 'son@mosti.com', NEWID())
INSERT INTO Member VALUES('S0002', N'KIM', 'kim@mosti.com', NEWID())
INSERT INTO Member VALUES('S0003', N'LEE', 'lee@mosti.com', NEWID())
SELECT * FROM Member

ALTER TABLE Member
	ADD tstamp TIMESTAMP

UPDATE Member
	SET email = 'sonny@mosti.com'
	WHERE empID = 'S0001'
 

-- 2.3
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE Vacation
 
CREATE TABLE Vacation (
	VacationID int,
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) NULL,
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1) -- 계산 된 열
)

INSERT INTO Vacation(VacationID, EmpID, BeginDate, EndDate, Reason)
	VALUES(1, 'S0001', '2012-03-05', '2012-03-07', N'개인사유')
 
SELECT * FROM Vacation
 

IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE Vacation
 
CREATE TABLE Vacation (
	VacationID int,
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) NULL,
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1) PERSISTED 
	)
 


IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL  
	DROP TABLE Vacation

CREATE TABLE Vacation (
	VacationID int IDENTITY(1, 1),
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) NULL,
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1)
)
 

INSERT INTO Vacation(EmpID, BeginDate, EndDate, Reason)
	VALUES('S0001', '2013-12-24', '2013-12-26', N'크리스마스 기념 가족 여행')
INSERT INTO Vacation(EmpID, BeginDate, EndDate, Reason)
	VALUES('S0003', '2014-01-01', '2014-01-07', N'신년 맞이 기분 내기')

SELECT * FROM Vacation

DELETE FROM Vacation WHERE VacationID = 2

INSERT INTO Vacation(EmpID, BeginDate, EndDate, Reason)
	VALUES('S0001', '2014-05-04', '2014-05-04', N'어린이날 이벤트 준비')

SELECT * FROM Vacation

-- 임의의 값 입력 가능 설정
SET IDENTITY_INSERT Vacation ON
 

INSERT INTO Vacation(VacationID, EmpID, BeginDate, EndDate, Reason)
	VALUES(2, 'S0003', '2014-01-01', '2014-01-07', N'신년 맞이 기분 내기')
 

-- 임의의 값 입력 가능 취소(꼭!)
SET IDENTITY_INSERT Vacation OFF
 

SELECT * FROM Vacation
   	ORDER BY VacationID

DBCC CHECKIDENT ('dbo.Vacation', NORESEED) 

DELETE FROM Vacation WHERE VacationID = 3
 

DBCC CHECKIDENT ('dbo.Vacation', NORESEED) 


DBCC CHECKIDENT ('dbo.Vacation', RESEED, 2);  
DBCC CHECKIDENT ('dbo.Vacation', NORESEED) 


CREATE TABLE Member01 (
	MemID int IDENTITY(1, 1),
	MemName varchar(20)
)
 
CREATE TABLE Member02 (
	MemID int IDENTITY(100, 10),
	MemName varchar(20)
)
 

--CREATE TRIGGER trg_Member01
--	ON Member01
--	AFTER INSERT
--AS
--BEGIN
--	INSERT INTO Member02(MemName)
--		SELECT MemName FROM Inserted
--END

INSERT INTO Member01(MemName)
	VALUES('Hong')
 

SELECT @@IDENTITY
 
   
SELECT SCOPE_IDENTITY()
  
  
SELECT IDENT_CURRENT('dbo.Member01')
SELECT IDENT_CURRENT('dbo.Member02')  
 

DECLARE @num01 int
SET @num01 = @num01 + 100
SELECT @num01 AS 'num01' 
 


IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
	DROP TABLE Employee

CREATE TABLE Employee (
	EmpID char(5) NOT NULL,
	EmpName nvarchar(10) NOT NULL,
	EngName varchar(20) NULL,
)

INSERT INTO Employee(EmpID, EmpName, EngName) VALUES('S0001', N'홍길동', 'Gildong') 
INSERT INTO Employee(EmpID, EmpName) VALUES('S0002',N'일지매') 
INSERT INTO Employee(EmpID, EmpName, EngName) VALUES('S0003',N'강우동', 'NULL')  

SELECT * FROM Employee
 

SELECT * FROM Employee WHERE EngName = 'NULL'
SELECT * FROM Employee WHERE EngName IS NULL

-- 2.4
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
	DROP TABLE Employee
 

CREATE TABLE Employee (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(10) NOT NULL,
	EngName varchar(20) NULL,
	Gender char(1) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NULL,
	DeptID char(3) NOT NULL,
	EMail varchar(60) NOT NULL,
	Salary int NULL 
)
 


IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE Vacation
 
CREATE TABLE Vacation (
	VacationID int IDENTITY PRIMARY KEY, -- PRIMARY KEY 제약
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) NULL,
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1)
)
 

SELECT name
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID('dbo.Employee', 'U') AND type = 'PK'
 

ALTER TABLE Employee
	DROP CONSTRAINT PK__Employee__AF2DBA79DE7331B9
 
ALTER TABLE Employee
	ADD PRIMARY KEY (EmpID)
 


IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
	DROP TABLE Employee
 

CREATE TABLE Employee (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(10) NOT NULL,
	EngName varchar(20) NULL,
	Gender char(1) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NULL,
	DeptID char(3) NOT NULL,
	EMail varchar(60) UNIQUE NOT NULL, -- UNIQUE 제약
	Salary int NULL 
)

SELECT name
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID('dbo.Employee', 'U') AND type = 'UQ'
 
ALTER TABLE Employee
	DROP CONSTRAINT UQ__Employee__7614F5F6869308C7
 

ALTER TABLE Employee
	ADD UNIQUE(EMail) 
 

IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE Vacation

CREATE TABLE Vacation (
	VacationID int IDENTITY PRIMARY KEY,
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'개인사유',  -- DEFAULT 제약
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1)

)
 

SELECT name 
	FROM sys.default_constraints
	WHERE parent_object_id = OBJECT_ID('dbo.Vacation', 'U') AND type = 'D'
 
ALTER TABLE Vacation
	DROP CONSTRAINT DF__Vacation__Reason__398D8EEE
 

ALTER TABLE Vacation
	ADD DEFAULT N'개인사유' FOR Reason


-- 04.10
CREATE TABLE TB_TEST04(
	T_SEQ int IDENTITY NOT NULL
	,T_No int NOT NULL
	,CHECK(T_SEQ < T_No)
)

INSERT INTO TB_TEST04
	VALUES(@@IDENTITY+3, @@IDENTITY+4)

SELECT * FROM TB_TEST04

ALTER TABLE TB_TEST04
	ADD T_No1 INT DEFAULT(0) NOT NULL

UPDATE TB_TEST04
	SET T_No1 = T_No + 10

ALTER TABLE TB_TEST04
	ADD CHECK(T_NO < T_No1)

DBCC CHECKIDENT('TB_TEST04', RESEED, 30)
DBCC CHECKIDENT('TB_TEST04', NORESEED)

ALTER TABLE TB_TEST04
	DROP CONSTRAINT 'CK__TB_TEST04__07C12930','CK__TB_TEST04__09A971A2'

-- 데이터만 지우기
DELETE TB_TEST04
-- IDENTITY 값, 데이터 등 모두 지우기
TRUNCATE TABLE TB_TEST04

SELECT * FROM TB_TEST01

-- 트랜잭션 걸기
BEGIN TRAN
-- 데이터 복원
ROLLBACK
-- 트랜잭션 내용 저장/ 작업 완료
COMMIT
-- 트랜잭션 끝내기
--END

-- FOREIGN KEY
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE Vacation

CREATE TABLE Vacation (
	VacationID int IDENTITY PRIMARY KEY,
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'개인사유',
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1),
	CHECK (EndDate >= BeginDate)
)
 
SELECT name 
	FROM sys.check_constraints
	WHERE parent_object_id = OBJECT_ID('dbo.Vacation', 'U') AND type = 'C'
 

ALTER TABLE Vacation
	DROP CONSTRAINT CK__Vacation__3E52440B
 

ALTER TABLE Vacation
	ADD CHECK (EndDate >= BeginDate)

use STD_DB 

IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE Vacation

CREATE TABLE Vacation (
	VacationID int IDENTITY PRIMARY KEY,
	EmpID char(5) REFERENCES Employee(EmpID),
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'개인사유',
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1),
	CHECK (EndDate >= BeginDate)
)
 

SELECT name
	FROM sys.foreign_keys 
	WHERE parent_object_id = OBJECT_ID('dbo.Vacation', 'U') AND type = 'F'
 

ALTER TABLE Vacation
	DROP CONSTRAINT FK__Vacation__EmpID__151B244E
 
ALTER TABLE Vacation
	ADD FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)
 
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE Vacation
 

IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
	DROP TABLE Employee
 

CREATE TABLE Employee (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(10) NOT NULL,
	EngName varchar(20) NULL,
)

INSERT INTO Employee(EmpID, EmpName, EngName) VALUES('S0001', N'홍길동', 'Gildong') 
INSERT INTO Employee(EmpID, EmpName) VALUES('S0002',N'일지매') 
INSERT INTO Employee(EmpID, EmpName, EngName) VALUES('S0003',N'강우동', 'NULL')  
 

CREATE TABLE Vacation (
	VacationID int IDENTITY PRIMARY KEY,
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'개인사유',
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1),
	CHECK (EndDate >= BeginDate)
)
 

INSERT INTO Vacation VALUES('S0001','2011-01-12','2011-01-12',N'감기몸살')
INSERT INTO Vacation VALUES('S0001','2011-03-21','2011-03-21',N'글쎄요')
INSERT INTO Vacation VALUES('S0002','2012-02-10','2012-02-13',N'두통')
INSERT INTO Vacation VALUES('S0003','2012-09-17','2012-09-17',N'휴식이 필요')
 
ALTER TABLE Vacation
	ADD CONSTRAINT FK_Vacation_EmpID
	FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)

SELECT * FROM Vacation
SELECT * FROM Employee

DELETE Employee
	WHERE EmpID = 'S0003'


ALTER TABLE Vacation
	DROP CONSTRAINT FK_Vacation_EmpID 
 
ALTER TABLE Vacation
	ADD CONSTRAINT FK_Vacation_EmpID 
	FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)
	ON DELETE CASCADE    
	ON UPDATE CASCADE 
 

DELETE Employee
	WHERE EmpID = 'S0003'

UPDATE Employee
	SET EmpID = 'S0010'
	WHERE EmpID = 'S0001'

SELECT * FROM Vacation
 

ALTER TABLE Vacation
	DROP CONSTRAINT FK_Vacation_EmpID 

ALTER TABLE Vacation
	ALTER COLUMN EmpID char(5) NULL

ALTER TABLE Vacation
	ADD CONSTRAINT FK_Vacation_EmpID 
	FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)
	ON DELETE SET NULL    
	ON UPDATE SET NULL

DELETE Employee
	WHERE EmpID = 'S0002'

SELECT * FROM Vacation

INSERT INTO Employee(EmpID, EmpName, EngName) VALUES('S0000',N'NULL', 'NULL')  
 

ALTER TABLE Vacation
	ADD CONSTRAINT DF_Vacation_EmpID 
	DEFAULT 'S0000' FOR EmpID 
 

ALTER TABLE Vacation
	DROP CONSTRAINT FK_Vacation_EmpID 

ALTER TABLE Vacation
	ADD CONSTRAINT FK_Vacation_EmpID 
	FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)
	ON DELETE SET DEFAULT    
    ON UPDATE SET DEFAULT  

DELETE Employee
	WHERE EmpID = 'S0010'
 

SELECT * FROM Vacation

CREATE TABLE #Emp01 (
	EmpID char(5) NOT NULL,
	EmpName nvarchar(10) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NOT NULL,
	EMail varchar(60) NOT NULL
)
 
INSERT INTO #Emp01
	SELECT EmpID, EmpName, HireDate, RetireDate, EMail
		FROM Employee
		WHERE RetireDate IS NOT NULL
 
SELECT * FROM #Emp01


SELECT EmpID, EmpName, HireDate, RetireDate, EMail
	INTO #Emp02
	FROM Employee
	WHERE RetireDate IS NOT NULL

SELECT EmpID, EmpName, HireDate, RetireDate, EMail
	INTO ##EmpMan
	FROM Employee
	WHERE Gender = 'M' AND RetireDate IS NULL
 
SELECT * FROM ##EmpMan


-- 04.11
use 'CENTERO-1'

SELECT *
	FROM TB_ACT_ACCOUNT

SELECT *
	FROM TB_MTD_METHODOLOGY

-- IN = OR

--2.8
use STD_DB
EXEC sp_help 'dbo.Vacation'

SELECT name
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID('dbo.Vacation')

ALTER TABLE Vacation
	NOCHECK CONSTRAINT FK_Vacation_EmpID

INSERT INTO Vacation 
	VALUES('S2028', '2023-04-11', '2023-04-14', N'책쓰기')

SELECT * FROM Vacation

ALTER TABLE Vacation
	CHECK CONSTRAINT FK_Vacation_EmpID