--*
--* 4.6. 기본적으로 알아두어야 할 함수
--*


USE HRDB2
GO


--*
--* 4.6.1. 날짜 관련 함수
--*


-- [소스 4-39] GETDATE, SYSDATETIME 함수

-- 기본적인 사용
SELECT GETDATE() -- 결과: 2016-11-28 09:30:06.230
SELECT SYSDATETIME() -- 결과: 2016-11-28 09:30:06.2338144
GO

-- 날짜만 가져오기
SELECT CONVERT(date, GETDATE()) -- 결과: 2016-11-27
SELECT CONVERT(date, SYSDATETIME()) -- 결과: 2016-11-27
GO

-- 시간만 가져오기
SELECT CONVERT(time, GETDATE()) -- 결과: 09:29:51.7600000
SELECT CONVERT(time, SYSDATETIME()) -- 결과: 09:29:51.7619671
GO


-- [소스 4-40] DATEADD 함수

DECLARE @date date
SET @date = GETDATE()
SELECT DATEADD(DAY, 100, @date) AS [100일후] -- 결과: 2017-03-08
SELECT DATEADD(DAY, -100, @date) AS [100일전] -- 결과: 2016-08-20
SELECT DATEADD(MONTH, 100, @date) AS [100개월후] -- 결과: 2025-03-28
GO


-- [소스 4-41] DATEDIFF 함수

DECLARE @date01 date
DECLARE @date02 date
SET @date01 = GETDATE()
SET @date02 = '2020-12-25'
SELECT DATEDIFF(HOUR, @date01, @date02) AS [시간차이] -- 결과: 35712
SELECT DATEDIFF(DAY, @date01, @date02) AS [일차이] -- 결과: 1488
SELECT DATEDIFF(MONTH, @date01, @date02) AS [개월차이] -- 결과: 49
GO


-- [소스 4-42] 퇴사자 근무 일수 구하기

SELECT EmpID, EmpName, DeptID, Gender, HireDate, RetireDate, Phone,
	   DATEDIFF(DAY, HireDate, RetireDate) AS [Duration]
	FROM dbo.Employee
	WHERE RetireDate IS NOT NULL
GO


-- [소스 4-43] YEAR, MONTH, DAY 함수

DECLARE @date date
SET @date = GETDATE()
SELECT YEAR(@date) AS [년] -- 결과: 2016
SELECT MONTH(@date) AS [월] -- 결과: 11
SELECT DAY(@date) AS [일] -- 결과: 
GO


-- [소스 4-44] DATENAME 함수

DECLARE @date datetime
SET @date = GETDATE()
SELECT 	'지금은 ' + DATENAME(YEAR, @date) + '년 ' +
		DATENAME(MONTH, @date) + '월 ' +
		DATENAME(DAY, @date) + '일 ' + 
		DATENAME(HOUR, @date) + '시 ' + 
		DATENAME(MINUTE, @date) + '분 ' + 
		DATENAME(SECOND, @date) + '초입니다.'
GO
/*
지금은 2016년 11월 28일 10시 4분 48초입니다.
*/



--*
--* 4.6.2. 문자열 관련 함수
--*


-- [소스 4-45] REPLACE 함수

DECLARE @str nvarchar(100)
SET @str = N'오늘은 슬픈 날입니다.'
SELECT REPLACE(@str, N'슬픈', N'즐거운') -- 결과: 오늘은 즐거운 날입니다.
GO


-- [소스 4-46] REPLICATE 함수

DECLARE @str01 nvarchar(100)
DECLARE @str02 nvarchar(100)
DECLARE @str03 nvarchar(100)
SET @str01 = N'오늘은'
SET @str02 = REPLICATE(N'꼭!', 3) 
SET @str03 = N'행복하세요.'

SELECT @str01 + ' ' + @str02 + ' ' + @str03 -- 결과: 오늘은 꼭!꼭!꼭! 행복하세요. 
GO


-- [소스 4-47] SUBSTRING 함수

DECLARE @str varchar(100)
SET @str = 'ABCDEFGHIJKLMN'
SELECT SUBSTRING(@str, 5, 3) -- 결과: EFG
GO


-- [소스 4-48] 전화번호 뒤 4자리 조회

SELECT EmpID, EmpName, HireDate, SUBSTRING(Phone, 10, 4) AS [Phone_Last_4]
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO


-- [소스 4-49] LEFT 함수

DECLARE @str varchar(100)
SET @str = 'ABCDEFGHIJKLMN'
SELECT LEFT(@str, 5) -- 결과: ABCDE
SELECT RIGHT(@str, 5) -- 결과: JKLMN
GO


-- [소스 4-50] 전화번호 뒤 4자리 조회

SELECT EmpID, EmpName, HireDate, RIGHT(Phone, 4) AS [Phone_Last_4]
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO


-- [소스 4-51] UPPER, LOWER 함수

DECLARE @str varchar(100)
SET @str = 'I Have a Dream.'
SELECT UPPER(@str) -- 결과: I HAVE A DREAM.
SELECT LOWER(@str) -- 결과: i have a dream.
GO