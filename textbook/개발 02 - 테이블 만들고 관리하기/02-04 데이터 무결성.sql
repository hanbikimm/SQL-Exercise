--*
--* 2.4. 데이터 무결성
--*


USE HRDB2
GO



--*
--* 2.4.2. NULL과 NOT NULL
--*


-- [소스 2-39] 초기화 하지 않은 변수의 NULL

DECLARE @num01 int
SET @num01 = @num01 + 100
SELECT @num01 AS [num01]  -- NULL 표시됨
GO


-- [소스 2-40] NULL 값이 허용된 열에 대한 NULL

-- 테이블이 이미 있으면 삭제
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
	DROP TABLE dbo.Employee
GO

-- 테이블 만들기
CREATE TABLE dbo.Employee (
	EmpID char(5) NOT NULL,
	EmpName nvarchar(10) NOT NULL,
	EngName varchar(20) NULL,
)
GO

-- 데이터 추가
INSERT INTO dbo.Employee(EmpID, EmpName, EngName) VALUES('S0001', N'홍길동', 'Gildong') 
INSERT INTO dbo.Employee(EmpID, EmpName) VALUES('S0002',N'일지매') 
INSERT INTO dbo.Employee(EmpID, EmpName, EngName) VALUES('S0003',N'강우동', 'NULL')  
GO

-- 확인
SELECT * FROM dbo.Employee
GO


-- [소스 2-41] NULL 조회

-- 문자열 NULL을 찾는 조건(NULL 조회 방법이 아님)
SELECT * FROM dbo.Employee WHERE EngName = 'NULL'
GO

-- NULL을 갖는 데이터 조회
SELECT * FROM dbo.Employee WHERE EngName IS NULL
GO

-- NULL은 = 로 조회하지 않도록 함
SELECT * FROM dbo.Employee WHERE EngName = NULL
GO



--*
--* 1.4.3. 제약(Constraints)
--*


-- [소스 2-42] PRIMARY KEY 제약을 갖는 테이블 만들기

-- 테이블이 이미 있으면 삭제
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
	DROP TABLE dbo.Employee
GO

-- PRIMARY KEY 제약을 갖는 테이블 만들기
CREATE TABLE dbo.Employee (
	EmpID char(5) PRIMARY KEY, -- PRIMARY KEY 설정
	EmpName nvarchar(10) NOT NULL,
	EngName varchar(20) NULL,
	Gender char(1) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NULL,
	DeptID char(3) NOT NULL,
	EMail varchar(60) NOT NULL,
	Salary int NULL 
)
GO


-- [소스 2-43] PRIMARY KEY 제약을 갖는 Vacation 테이블 만들기기

-- 테이블이 이미 있으면 삭제
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE dbo.Vacation
GO

-- PRIMARY KEY 제약을 갖는 테이블 만들기
CREATE TABLE dbo.Vacation (
	VacationID int IDENTITY PRIMARY KEY, -- PRIMARY KEY 제약
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) NULL,
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1)
)
GO


-- [소스 2-44] PRIMARY KEY 제약 삭제

-- PRIMARY KEY 제약 이름 확인
SELECT name
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID('dbo.Employee', 'U') AND type = 'PK'
GO

-- 테이블에서 PRIMARY KEY 제약 삭제
ALTER TABLE dbo.Employee
	DROP CONSTRAINT PK__Employee__AF2DBA79DE7331B9
GO


-- [소스 2-45] 기존 테이블에 PRIMARY KEY 제약 추가

-- 테이블에 PRIMARY KEY 제약 추가
ALTER TABLE dbo.Employee
	ADD PRIMARY KEY (EmpID)
GO


-- [소스 2-46] UNIQUE 제약을 갖는 테이블 만들기

-- 테이블이 이미 있으면 삭제
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
	DROP TABLE dbo.Employee
GO

-- UNIQUE 제약을 갖는 테이블 만들기
CREATE TABLE dbo.Employee (
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
GO


-- [소스 2-47] UNIQUE 제약 삭제

-- UNIQUE 제약 이름 확인
SELECT name
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID('dbo.Employee', 'U') AND type = 'UQ'
GO

-- 테이블에서 UNIQUE 제약 삭제
ALTER TABLE dbo.Employee
	DROP CONSTRAINT UQ__Employee__7614F5F6869308C7
GO


-- [소스 2-48] 기본 테이블에 UNIQUE 제약 추가

-- 테이블에 UNIQUE 제약 추가
ALTER TABLE dbo.Employee
	ADD UNIQUE(EMail) 
GO


-- [소스 2-49] DEFAULT 제약을 갖는 테이블 만들기

-- 테이블이 이미 있으면 삭제
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE dbo.Vacation
GO

-- DEFAULT 제약을 갖는 테이블 만들기
CREATE TABLE dbo.Vacation (
	VacationID int IDENTITY PRIMARY KEY,
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'개인사유',  -- DEFAULT 제약
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1)

)
GO


-- [소스 2-50] DEFAULT 제약 삭제

-- DEFAULT 제약 이름 확인
SELECT name 
	FROM sys.default_constraints
	WHERE parent_object_id = OBJECT_ID('dbo.Vacation', 'U') AND type = 'D'
GO

-- 테이블에서 DEFAULT 제약 삭제
ALTER TABLE dbo.Vacation
	DROP CONSTRAINT DF__Vacation__Reason__398D8EEE
GO


-- [소스 2-51] 기존 테이블에 DEFAULT 제약 추가

-- 테이블에 DEFAULT 제약 추가
ALTER TABLE dbo.Vacation
	ADD DEFAULT N'개인사유' FOR Reason
GO


-- [소스 2-52] CHECK 제약을 갖는 테이블 만들기

-- 테이블이 이미 있으면 삭제
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE dbo.Vacation
GO

--  CHECK 제약을 갖는 테이블 만들기
CREATE TABLE dbo.Vacation (
	VacationID int IDENTITY PRIMARY KEY,
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'개인사유',
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1),
	CHECK (EndDate >= BeginDate) -- CHECK 제약
)
GO


-- [소스 2-53] CHECK 제약 삭제

-- CHECK 제약 이름 확인
SELECT name 
	FROM sys.check_constraints
	WHERE parent_object_id = OBJECT_ID('dbo.Vacation', 'U') AND type = 'C'
GO

-- 테이블에서 CHECK 제약 삭제
ALTER TABLE dbo.Vacation
	DROP CONSTRAINT CK__Vacation__3E52440B
GO


-- [소스 2-54] 기존 테이블에 CHECK 제약 추가

-- 테이블에 CHECK 제약 추가
ALTER TABLE dbo.Vacation
	ADD CHECK (EndDate >= BeginDate)
GO


-- [소스 2-55] FOREIGN KEY 제약을 갖는 테이블 만들기

-- 테이블이 이미 있으면 삭제
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE dbo.Vacation
GO

-- FOREIGN KEY 제약을 갖는 테이블 만들기
CREATE TABLE dbo.Vacation (
	VacationID int IDENTITY PRIMARY KEY,
	EmpID char(5) REFERENCES dbo.Employee(EmpID), -- FOREIGN KEY 제약
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'개인사유',
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1),
	CHECK (EndDate >= BeginDate)
)
GO


-- [소스 2-56] FOREIGN KEY 제약 삭제

-- FOREIGN KEY 제약 이름 확인
SELECT name
	FROM sys.foreign_keys 
	WHERE parent_object_id = OBJECT_ID('dbo.Vacation', 'U') AND type = 'F'
GO

-- 테이블에서 FOREIGN KEY 제약 삭제
ALTER TABLE dbo.Vacation
	DROP CONSTRAINT FK__Vacation__EmpID__4222D4EF
GO


-- [소스 2-57] 기존 테이블에 FOREIGN KEY 제약 추가

-- 테이블에 FOREIGN KEY 제약 추가
ALTER TABLE dbo.Vacation
	ADD FOREIGN KEY (EmpID) REFERENCES dbo.Employee(EmpID)
GO


-- [소스 2-58] 단순 FOREIGN KEY 제약 설정

-- dbo.Vacation 테이블 삭제
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE dbo.Vacation
GO

-- dbo.Employee 테이블 삭제
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
	DROP TABLE dbo.Employee
GO

-- dbo.Employee 테이블 만들기
CREATE TABLE dbo.Employee (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(10) NOT NULL,
	EngName varchar(20) NULL,
)
GO

-- 데이터 추가
INSERT INTO dbo.Employee(EmpID, EmpName, EngName) VALUES('S0001', N'홍길동', 'Gildong') 
INSERT INTO dbo.Employee(EmpID, EmpName) VALUES('S0002',N'일지매') 
INSERT INTO dbo.Employee(EmpID, EmpName, EngName) VALUES('S0003',N'강우동', 'NULL')  
GO

-- dbo.Employee 테이블 만들기
CREATE TABLE dbo.Vacation (
	VacationID int IDENTITY PRIMARY KEY,
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'개인사유',
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1),
	CHECK (EndDate >= BeginDate)
)
GO

-- 데이터 추가
INSERT INTO dbo.Vacation VALUES('S0001','2011-01-12','2011-01-12',N'감기몸살')
INSERT INTO dbo.Vacation VALUES('S0001','2011-03-21','2011-03-21',N'글쎄요')
INSERT INTO dbo.Vacation VALUES('S0002','2012-02-10','2012-02-13',N'두통')
INSERT INTO dbo.Vacation VALUES('S0003','2012-09-17','2012-09-17',N'휴식이 필요')
GO

-- FOREIGN KEY 제약 추가(제약 이름을 명시)
ALTER TABLE dbo.Vacation
	ADD CONSTRAINT FK_Vacation_EmpID
	FOREIGN KEY (EmpID) REFERENCES dbo.Employee(EmpID)
GO

-- 직원 정보 삭제
DELETE dbo.Employee
	WHERE EmpID = 'S0003'
GO
/*
메시지 547, 수준 16, 상태 0, 줄 323
DELETE 문이 REFERENCE 제약 조건 "FK_Vacation_EmpID"과(와) 충돌했습니다. 
데이터베이스 "HRDB2", 테이블 "dbo.Vacation", column 'EmpID'에서 충돌이 발생했습니다.
문이 종료되었습니다.
*/


-- [소스 2-59] CASCADE 옵션 설정

-- 기존 FOREIGN KEY 제약 삭제
ALTER TABLE dbo.Vacation
	DROP CONSTRAINT FK_Vacation_EmpID 
GO

-- FOREIGN KEY 제약 추가(CASCADE)
ALTER TABLE dbo.Vacation
	ADD CONSTRAINT FK_Vacation_EmpID 
	FOREIGN KEY (EmpID) REFERENCES dbo.Employee(EmpID)
	ON DELETE CASCADE    
	ON UPDATE CASCADE 
GO

-- 직원 정보 삭제
DELETE dbo.Employee
	WHERE EmpID = 'S0003'
GO

-- 직원 정보 변경
UPDATE dbo.Employee
	SET EmpID = 'S0010'
	WHERE EmpID = 'S0001'
GO

-- 확인
SELECT * FROM dbo.Vacation
GO


-- [소스 2-60] SET NULL 옵션 설정

-- 기존 FOREIGN KEY 제약 삭제
ALTER TABLE dbo.Vacation
	DROP CONSTRAINT FK_Vacation_EmpID 
GO

-- EmpID에 NULL 값 허용
ALTER TABLE dbo.Vacation
	ALTER COLUMN EmpID char(5) NULL
GO

-- FOREIGN KEY 제약 추가(SET NULL)
ALTER TABLE dbo.Vacation
	ADD CONSTRAINT FK_Vacation_EmpID 
	FOREIGN KEY (EmpID) REFERENCES dbo.Employee(EmpID)
	ON DELETE SET NULL    
	ON UPDATE SET NULL
GO

-- 직원 정보 삭제
DELETE dbo.Employee
	WHERE EmpID = 'S0002'
GO

-- 확인
SELECT * FROM dbo.Vacation
GO


-- [소스 2-61] SET DEFAULT 옵션 설정

-- dbo.Employee에 데이터 추가
INSERT INTO dbo.Employee(EmpID, EmpName, EngName) VALUES('S0000',N'NULL', 'NULL')  
GO

-- EmpID 열에 기본 값 설정
ALTER TABLE dbo.Vacation
	ADD CONSTRAINT DF_Vacation_EmpID 
	DEFAULT 'S0000' FOR EmpID 
GO

-- 기존 FOREIGN KEY 제약 삭제
ALTER TABLE dbo.Vacation
	DROP CONSTRAINT FK_Vacation_EmpID 
GO

-- FOREIGN KEY 제약 추가(SET DEFAULT)
ALTER TABLE dbo.Vacation
	ADD CONSTRAINT FK_Vacation_EmpID 
	FOREIGN KEY (EmpID) REFERENCES dbo.Employee(EmpID)
	ON DELETE SET DEFAULT    
    ON UPDATE SET DEFAULT  
GO

-- 직원 정보 삭제
DELETE dbo.Employee
	WHERE EmpID = 'S0010'
GO

-- 확인
SELECT * FROM dbo.Vacation
GO