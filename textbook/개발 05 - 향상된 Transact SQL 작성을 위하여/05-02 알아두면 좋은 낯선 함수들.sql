--*
--* 5.2. 알라두면 좋을 낯선 함수들
--*


USE HRDB2
GO


--*
--* 5.2.1. EOMONTH, CHOOSE, IIF 함수
--*


-- [소스 5-47] EOMONTH 함수

DECLARE @date date
SET @date = GETDATE()
SELECT EOMONTH (@date) AS [이번달_말일] -- 결과: 2016-11-30
SELECT EOMONTH (@date, 1) AS [다음달_말일] -- 결과: 2016-12-31
SELECT EOMONTH (@date, -1) AS [지난달_말일] -- 결과: 2016-10-31
GO


-- [소스 5-48] CHOOSE 함수

SELECT CHOOSE (3, N'나', N'너', N'우리', N'우리나라')  -- 결과: 우리
GO


-- [소스 5-49] 휴가간 계절 확인

SELECT EmpID, BeginDate, EndDate, Reason, 
	CHOOSE(MONTH(BeginDate), 
		'겨울', '겨울', '봄', '봄', 
		'봄', '여름', '여름', '여름', 
		'가을', '가을', '가을', '겨울') AS [Season]
	FROM dbo.Vacation
	WHERE EmpID = 'S0005'
GO


-- [소스 5-50] IIF 함수

DECLARE @num1 int = 100
DECLARE @num2 int = 200
SELECT IIF (@num1 > @num2, N'참', N'거짓')  -- 결과: 거짓
GO


-- [소스 5-51] 영어 이름이 없으면 N/A

SELECT EmpID, EmpName, Gender, Phone,
	   IIF(EngName IS NULL, 'N/A', EngName) AS [EngName] 
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO



--*
--* 5.2.2. CONCAT, FORMAT 함수
--*


-- [소스 5-52] CONCAT 함수

SELECT CONCAT (N'크리스', N'마스는 ', 12, N'월 ', '25', N'일 입니다.')  -- 결과: 크리스마스는 12월 25일 입니다.
GO


-- [소스 5-53] 휴가 정보 조회

SELECT v.EmpID, e.EmpName, e.DeptID, v.BeginDate, v.EndDate,
       CONCAT(N'사유:', v.Reason, N'(기간:', v.Duration, N'일)') AS [Info]
	FROM dbo.Vacation AS v
	INNER JOIN dbo.Employee AS e ON v.EmpID = e.EmpID
	WHERE v.BeginDate BETWEEN '2016-06-01' AND '2016-08-31'
GO


-- [소스 5-54] FORMAT 함수

SELECT FORMAT(123456, '###,###')  -- 결과: 123,456
SELECT FORMAT(123.4, '##,##0.00')  -- 결과: 123.40
SELECT FORMAT(0.521, '0.00%')  -- 결과: 52.10%
GO


-- [소스 5-55] 급여 정보 조회

DECLARE @Tot_Salary Decimal(10, 2)

SELECT @Tot_Salary = SUM(Salary)
	FROM dbo.Employee
	WHERE (RetireDate IS NULL) AND (DeptID = 'SYS')

SELECT EmpID, EmpName, Gender, HireDate, Phone, FORMAT(Salary, '#,###,###') AS [Salary],  
	   FORMAT(Salary / @Tot_Salary, '#,#0.#0%') AS [Percent]
	FROM dbo.Employee
	WHERE (RetireDate IS NULL) AND (DeptID = 'SYS')
GO



--*
--* 5.2.3. LAST_VALUE, FIRST_VALUE 함수
--*


-- [소스 5-56] 처음 입사일과 마지막 입사일 표시

SELECT HireDate, DeptID, EmpID, EmpName, EMail,
		FIRST_VALUE(HireDate) OVER(ORDER BY HireDate) AS [FirstHireDate],
		LAST_VALUE(HireDate) OVER(ORDER BY HireDate) AS [LastHireDate]
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY HireDate
GO


-- [소스 5-57] 동일한 쿼리

SELECT HireDate, DeptID, EmpID, EmpName, EMail,
		FIRST_VALUE(HireDate) OVER(
			ORDER BY HireDate
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [FirstHireDate],
		LAST_VALUE(HireDate) OVER(			
			ORDER BY HireDate
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [LastHireDate]
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY HireDate
GO


-- [소스 5-58] 원하는 결과가 나오도록 수정

SELECT HireDate, DeptID, EmpID, EmpName, EMail,
		FIRST_VALUE(HireDate) OVER(
			ORDER BY HireDate
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [FirstHireDate],
		LAST_VALUE(HireDate) OVER(			
			ORDER BY HireDate
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [LastHireDate]
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY HireDate
GO


-- [소스 5-59] 다른 방법으로 동일한 결과 얻기

SELECT HireDate, DeptID, EmpID, EmpName, EMail,
		FIRST_VALUE(HireDate) OVER(
			ORDER BY HireDate
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [FirstHireDate],
		LAST_VALUE(HireDate) OVER(			
			ORDER BY HireDate
			ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS [LastHireDate]
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY HireDate
GO


-- [소스 5-60] 부서별로 구분하여 표시

SELECT DeptID, HireDate, EmpID, EmpName, EMail,
		FIRST_VALUE(HireDate) OVER(
			PARTITION BY DeptID
			ORDER BY HireDate
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [FirstHireDate],
		LAST_VALUE(HireDate) OVER(	
			PARTITION BY DeptID	
			ORDER BY HireDate
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [LastHireDate]
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY DeptID, HireDate
GO



--*
--* 5.2.4. LEAD, LAG 함수
--*


-- [소스 5-61] LEAD, LAG 함수 기본 사용법

SELECT HireDate, DeptID, EmpID, EmpName, EMail,
	LEAD(EmpName) OVER (ORDER BY HireDate) AS [NextHiredEmployee],
	LAG(EmpName) OVER (ORDER BY HireDate) AS [PrevHiredEmployee]
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY HireDate
GO


-- [소스 5-62] 위치 지정

SELECT HireDate, DeptID, EmpID, EmpName, EMail,
	LEAD(EmpName, 2) OVER (ORDER BY HireDate) AS [Next2HiredEmployee],
	LAG(EmpName, 2) OVER (ORDER BY HireDate) AS [Prev2HiredEmployee]
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY HireDate
GO


-- [소스 5-63] NULL 값 처리

SELECT HireDate, DeptID, EmpID, EmpName, EMail,
	LEAD(EmpName, 2, 'N/A') OVER (ORDER BY HireDate) AS [Next2HiredEmployee],
	LAG(EmpName, 2, 'N/A') OVER (ORDER BY HireDate) AS [Prev2HiredEmployee]
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY HireDate
GO


-- [소스 5-64] 부서별로 구분하여 표시하기

SELECT DeptID, HireDate, EmpID, EmpName, EMail,
	LEAD(EmpName, 1, 'N/A') OVER (
		PARTITION BY DeptID
		ORDER BY HireDate) AS [NextHiredEmployee],
	LAG(EmpName, 1, 'N/A') OVER (
		PARTITION BY DeptID
		ORDER BY HireDate) AS [PrevHiredEmployee]
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY DeptID, HireDate
GO



--*
--* 5.2.5. STRING_SPLIT 함수
--*


-- [소스 5-65] STRING_SPLIT 함수

DECLARE @str varchar(1000)
SET @str = 'S0001,S0003,S0004,S0005,S0008,S0010,S0014'
SELECT * FROM STRING_SPLIT(@str, ',')
GO


-- [소스 5-66] STRING_SPLIT 함수 활용

DECLARE @str varchar(1000)
SET @str = 'S0001,T0003,S0104,S0005,S0008,S1010,E0014'
SELECT v.value, e.EmpName, e.Gender, e.DeptID, e.HireDate, e.EMail, e.Phone 
	FROM STRING_SPLIT(@str, ',') AS v
	LEFT OUTER JOIN dbo.Employee AS e ON v.value = e.EmpID
GO



--*
--* 5.2.6. SPACE, REVERSE 함수
--*


-- [소스 5-67] SPACE 함수

-- 1) 공백 처리
DECLARE @str01 varchar(10) = 'ABCD'
DECLARE @str02 varchar(10) = 'EFGH'
SELECT @str01 + '     ' + @str02 AS [Result]
GO

-- 2) SPACE 함수 사용
DECLARE @str01 varchar(10) = 'ABCD'
DECLARE @str02 varchar(10) = 'EFGH'
SELECT @str01 + SPACE(5) + @str02 AS [Result]
GO


-- [소스 5-68] REVERSE 함수

DECLARE @str varchar(20) = 'ABCDEFGHIJKLMN'
DECLARE @num int = 123456789
SELECT REVERSE(@str) AS [Result] -- 결과: NMLKJIHGFEDCBA
SELECT REVERSE(@num) AS [Result] -- 결과: 987654321
GO


-- [소스 5-69] REVERSE 함수

DECLARE @str nvarchar(20) = N'다좋은것은좋다'
SELECT REVERSE(@str) AS [Result] -- 결과: 다좋은것은좋다
GO