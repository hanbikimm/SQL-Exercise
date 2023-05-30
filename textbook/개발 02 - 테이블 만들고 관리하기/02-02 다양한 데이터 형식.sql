--*
--* 2.2. 다양한 데이터 형식
--*



--*
--* 2.2.1. 데이터 형식에 대한 이해
--*


-- [소스 2-17] 변수와 데이터 형식

DECLARE @num int
SET @num = 45000
SET @num = @num + 55000
SELECT @num
GO

-- 참고: 2008부터 가능한 문법
DECLARE @num int = 45000
SET @num += 55000
SELECT @num
GO


-- [소스 2-18] 산술 오버플로 오류 발생

DECLARE @num int
SET @num = 45000
SET @num = @num * 55000
SELECT @num
GO



--*
--* 2.2.2. 시스템 데이터 형식
--*


-- [소스 2-19] 정수 데이터 형식

DECLARE @num01 int
SET @num01 = 5000000000 -- 50억
GO
/*
메시지 8115, 수준 16, 상태 2, 줄 32
expression을(를) 데이터 형식 int(으)로 변환하는 중 산술 오버플로 오류가 발생했습니다.
*/

DECLARE @num02 bigint
SET @num02 = 5000000000 -- 50억
GO


-- [소스 2-20] 실수 데이터 형식

DECLARE @num decimal(10, 3)
SET @num = 1234567.67890
SELECT @num -- 1234567.679
GO

DECLARE @num decimal(10, 3)
SET @num = 12345678.67890
SELECT @num  
GO
/*
메시지 8115, 수준 16, 상태 8, 줄 52
numeric을(를) 데이터 형식 numeric(으)로 변환하는 중 산술 오버플로 오류가 발생했습니다.
*/

DECLARE @num01 decimal(10, 8)
SET @num01 = 1/3.0
SELECT @num01  
GO



--*
--* 2.2.4. 날짜와 시간 데이터 형식
--*


-- [소스 2-21] 다양한 날짜와 시간 데이터 형식

-- 변수 선언
DECLARE @dt01 datetime
DECLARE @dt02 smalldatetime
DECLARE @dt03 date
DECLARE @dt04 time
DECLARE @dt05 datetime2
DECLARE @dt06 datetimeoffset

-- 변수에 날짜와 시간 관련 함수 값 대입
SET @dt01 = GETDATE()
SET @dt02 = GETDATE()
SET @dt03 = SYSDATETIME()
SET @dt04 = SYSDATETIME()
SET @dt05 = SYSDATETIME()
SET @dt06 = SYSDATETIMEOFFSET()

-- 변수의 값 표시
SELECT @dt01 AS [datetime] 
SELECT @dt02 AS [smalldatetime]
SELECT @dt03 AS [date] 
SELECT @dt04 AS [time] 
SELECT @dt05 AS [datetime2]
SELECT @dt06 AS [datetimeoffset]
GO


-- [소스 2-22] 자릿수 지정

-- 자릿수 지정하여 변수 선언
DECLARE @dt01 time(2)
DECLARE @dt02 datetime2(3)
DECLARE @dt03 datetimeoffset(4)

-- 변수에 날짜와 시간 관련 함수 값 대입
SET @dt01 = SYSDATETIME()
SET @dt02 = SYSDATETIME()
SET @dt03 = SYSDATETIMEOFFSET()

-- 변수의 값 표시
SELECT @dt01 AS [time] 
SELECT @dt02 AS [datetime2] 
SELECT @dt03 AS [datetimeoffset]
GO



--*
--* 2.2.5. 문자 데이터 형식
--*


-- [소스 2-23] 고정 길이와 가변 길이

-- 변수 선언
DECLARE @str01 char(20) -- 고정 길이
DECLARE @str02 varchar(20) -- 가변 길이

-- 변수에 값 대입
SET @str01 = 'Gildong!'
SET @str02 = 'Gildong!'

-- 변수에 문자열 결합한 결과 확인
SELECT @str01 + 'Do you know Jiemae?' AS [Result]
SELECT @str02 + 'Do you know Jiemae?' AS [Result]
GO


-- [소스 2-24] 유니코드 문자열

-- 변수 선언
DECLARE @str01 varchar(20) 
DECLARE @str02 nvarchar(20) -- 유니코드

-- 변수에 값 대입
SET @str01 = '홍길동은 일지매를 알지 못한다.'
SET @str02 = N'홍길동은 일지매를 알지 못한다.'

-- 변수 값 확인
SELECT @str01 AS [Result]
SELECT @str02 AS [Result]
GO



--*
--* 2.2.6. 기타 특수한 데이터 형식
--*


-- [소스 2-25] 테이블 변수

-- 테이블 변수 선언
DECLARE @tbl table (
	EmpID char(5),
	EmpName nvarchar(10),
	EMail varchar(60)
)

-- 데이터 추가
INSERT INTO @tbl VALUES('S0001', N'홍길동', 'hong@dbnuri.com')
INSERT INTO @tbl VALUES('S0002', N'일지매', 'jimae@dbnuri.com')
INSERT INTO @tbl VALUES('S0003', N'강우동', 'woodong@dbnuri.com')

-- 데이터 변경
UPDATE @tbl SET EmpName = N'홍길뚱'
	WHERE EmpID = 'S0001'

-- 확인
SELECT * FROM @tbl
GO


-- [소스 2-26] uniqueidentifier 데이터 형식 사용

USE HRDB2
GO

-- 테이블 만들기
CREATE TABLE dbo.Member (
	EmpID char(5),
	EmpName nvarchar(10),
	EMail varchar(60),
	UniqueID uniqueidentifier 
)

-- 데이터 추가
INSERT INTO dbo.Member VALUES('S0001', N'홍길동', 'hong@dbnuri.com', NEWID())
INSERT INTO dbo.Member VALUES('S0002', N'일지매', 'jimae@dbnuri.com', NEWID())
INSERT INTO dbo.Member VALUES('S0003', N'강우동', 'woodong@dbnuri.com', NEWID())

-- 확인
SELECT * FROM dbo.Member
GO


-- [소스 2-27] timestamp 데이터 형식 사용

USE HRDB2
GO

-- 테이블 삭제
DROP TABLE dbo.Member
GO

-- 테이블 만들기
CREATE TABLE dbo.Member (
	EmpID char(5),
	EmpName nvarchar(10),
	EMail varchar(60),
	tstamp timestamp 
)

-- 데이터 추가
INSERT INTO dbo.Member(EmpID, EmpName, EMail) VALUES('S0001', N'홍길동', 'hong@dbnuri.com')
INSERT INTO dbo.Member(EmpID, EmpName, EMail) VALUES('S0002', N'일지매', 'jimae@dbnuri.com')
INSERT INTO dbo.Member(EmpID, EmpName, EMail) VALUES('S0003', N'강우동', 'woodong@dbnuri.com')

-- 확인
SELECT * FROM dbo.Member
GO


-- [소스 2-28] 데이터 변경 후 timestamp 값 확인

-- 데이터 변경
UPDATE dbo.Member
	SET EMail = 'gildong@dbnuri.com'
	WHERE EmpID = 'S0001'
GO

-- 확인
SELECT * FROM dbo.Member
GO