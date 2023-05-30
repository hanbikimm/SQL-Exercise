--*
--* 2.3. 특수한 형태의 열
--*


USE HRDB2
GO


--*
--* 2.3.1. 계산된 열(Computed Columns)
--*


-- [소스 2-29] 계산된 열

-- Vacation 테이블이 이미 있으면 삭제
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE dbo.Vacation
GO

-- Vacation 테이블 만들기
CREATE TABLE dbo.Vacation (
	VacationID int,
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) NULL,
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1) -- 계산 된 열
)
GO

-- Duration 열은 제외하고 데이터 입력
INSERT INTO dbo.Vacation(VacationID, EmpID, BeginDate, EndDate, Reason)
	VALUES(1, 'S0001', '2012-03-05', '2012-03-07', N'개인사유')
GO

-- 계산 된 결과 확인
SELECT * FROM dbo.Vacation
GO


-- [소스 2-30] 계산된 열 값을 미리 저장

-- Vacation 테이블이 이미 있으면 삭제
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE dbo.Vacation
GO

-- Vacation 테이블 만들기
CREATE TABLE dbo.Vacation (
	VacationID int,
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) NULL,
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1) PERSISTED -- 미리 계산하여 저장
	)
GO



--*
--* 2.3.2. IDENTITY 속성
--*


-- [소스 2-31] 자동으로 증가되는 값


-- 테이블이 이미 있으면 삭제
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL  
	DROP TABLE dbo.Vacation
GO

-- 테이블 만들기
CREATE TABLE dbo.Vacation (
	VacationID int IDENTITY(1, 1),
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) NULL,
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1)
)
GO

-- 데이터 추가
INSERT INTO dbo.Vacation(EmpID, BeginDate, EndDate, Reason)
	VALUES('S0001', '2013-12-24', '2013-12-26', N'크리스마스 기념 가족 여행')
INSERT INTO dbo.Vacation(EmpID, BeginDate, EndDate, Reason)
	VALUES('S0003', '2014-01-01', '2014-01-07', N'신년 맞이 기분 내기')
GO

-- 확인
SELECT * FROM dbo.Vacation
GO


-- [소스 2-32] 다시 채워지지 않는 중간 값

-- 기존 행 지우기
DELETE FROM dbo.Vacation WHERE VacationID = 2
GO

-- 새로운 행 입력
INSERT INTO dbo.Vacation(EmpID, BeginDate, EndDate, Reason)
	VALUES('S0001', '2014-05-04', '2014-05-04', N'어린이날 이벤트 준비')
GO

-- 확인
SELECT * FROM dbo.Vacation
GO


-- [소스 2-33] 지워진 중간 값 채우기

-- 임의의 값 입력 가능 설정
SET IDENTITY_INSERT dbo.Vacation ON
GO

-- 지워진 중간 값 입력
INSERT INTO dbo.Vacation(VacationID, EmpID, BeginDate, EndDate, Reason)
	VALUES(2, 'S0003', '2014-01-01', '2014-01-07', N'신년 맞이 기분 내기')
GO

-- 임의의 값 입력 가능 취소(꼭!)
SET IDENTITY_INSERT dbo.Vacation OFF
GO

-- 확인
SELECT * FROM dbo.Vacation
   	ORDER BY VacationID
GO


-- [소스 2-34] 현재 IDENTITY 정보 확인

DBCC CHECKIDENT ('dbo.Vacation', NORESEED) 
GO  
/*
ID 정보 확인: 현재 ID 값은 '3'이며, 현재 열 값은 '3'입니다.
DBCC 실행이 완료되었습니다. DBCC에서 오류 메시지를 출력하면 시스템 관리자에게 문의하십시오.
*/


-- [소스 2-35] 마지막 행 지우고 IDENTITY 정보 확인

DELETE FROM dbo.Vacation WHERE VacationID = 3
GO

DBCC CHECKIDENT ('dbo.Vacation', NORESEED) 
GO 
/*
ID 정보 확인: 현재 ID 값은 '3'이며, 현재 열 값은 '2'입니다.
DBCC 실행이 완료되었습니다. DBCC에서 오류 메시지를 출력하면 시스템 관리자에게 문의하십시오.
*/


-- [소스 2-36] IDENTITY 현재 ID값 2로 변경

DBCC CHECKIDENT ('dbo.Vacation', RESEED, 2);  
GO  
/*
 ID 정보 확인: 현재 ID 값은 '3'입니다.
DBCC 실행이 완료되었습니다. DBCC에서 오류 메시지를 출력하면 시스템 관리자에게 문의하십시오.
*/

DBCC CHECKIDENT ('dbo.Vacation', NORESEED) 
GO 
/*
ID 정보 확인: 현재 ID 값은 '2'이며, 현재 열 값은 '2'입니다.
DBCC 실행이 완료되었습니다. DBCC에서 오류 메시지를 출력하면 시스템 관리자에게 문의하십시오.
*/


-- [소스 2-37] IDENTITY 속성 열을 갖는 테이블 만들기

-- dbo.Member01 테이블 만들기
CREATE TABLE dbo.Member01 (
	MemID int IDENTITY(1, 1),
	MemName varchar(20)
)
GO

-- dbo.Member02 테이블 만들기
CREATE TABLE dbo.Member02 (
	MemID int IDENTITY(100, 10),
	MemName varchar(20)
)
GO

-- 트리거 만들기
CREATE TRIGGER dbo.trg_Member01
	ON dbo.Member01
	AFTER INSERT
AS
BEGIN
	INSERT INTO dbo.Member02(MemName)
		SELECT MemName FROM Inserted
END


-- [소스 2-38] 데이터 추가 후 관련 함수 기능 확인

INSERT INTO dbo.Member01(MemName)
	VALUES('Hong')
GO

SELECT @@IDENTITY -- 결과: 100
GO
   
SELECT SCOPE_IDENTITY() -- 결과: 1
GO 
  
SELECT IDENT_CURRENT('dbo.Member01')  -- 결과: 1  
SELECT IDENT_CURRENT('dbo.Member02')  -- 결과: 100
GO
