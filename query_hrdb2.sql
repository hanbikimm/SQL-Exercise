USE HRDB2

SELECT OBJECT_NAME(object_id) AS '테이블'
	FROM sys.columns
	WHERE name = 'EmpID'

--3.2
SELECT * FROM Department

SELECT * FROM Employee
	WHERE EmpID = 'S0005'


SELECT EmpID, EmpName, EMail FROM Employee
	WHERE EmpID = 'S0005'

SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM Employee
	WHERE EmpID = 'S0005' 

SELECT EmpID, EmpName, HireDate, Phone, EMail, Salary
	FROM Employee
	WHERE Salary >= 8000 

SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM Employee
	WHERE HireDate < '2013-01-01' 

SELECT BeginDate, EndDate, Reason, Duration
	FROM Vacation
	WHERE EmpID = 'S0001' AND (BeginDate BETWEEN '2014-01-01' AND '2014-12-31')


SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM Employee
	WHERE EmpName = N'홍길동' 

SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM Employee
	WHERE EmpName LIKE N'김%' 

SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM Employee
	WHERE EmpName LIKE N'%김%' 

SELECT EmpID, BeginDate, EndDate, Reason, Duration
	FROM Vacation
	WHERE BeginDate BETWEEN '2015-01-01' AND '2015-12-31'
		AND (Reason LIKE N'%두통%' OR Reason LIKE N'%머리%')

SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM Employee
	WHERE EMail LIKE '____@%'

SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM Employee
	WHERE Phone LIKE '010-'1-3'%'


UPDATE Employee
	SET EngName = 'sam_soon'
	WHERE EmpID = 'S0004'

UPDATE Employee
	SET EngName = 'five_gamja'
	WHERE EmpID = 'S0011'

SELECT EmpID, EmpName, EngName, Phone, EMail
	FROM Employee
	WHERE EngName LIKE '%'_'%'


SELECT EmpID, EmpName, Gender, HireDate, DeptID, Phone, EMail
	FROM Employee
	WHERE HireDate >= '2015-01-01' AND Gender = 'M'

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail
	FROM Employee
	WHERE DeptID = 'GEN' OR DeptID = 'HRD'


SELECT EmpID, EmpName, Gender, HireDate, DeptID, Phone, EMail
	FROM Employee
	WHERE Gender = 'F' AND NOT DeptID = 'SYS'


SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
	FROM Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31'

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
	FROM Employee
	WHERE HireDate >= '2014-01-01' AND HireDate <= '2014-12-31'


SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
	FROM Employee
	WHERE DeptID IN ('ACC', 'GEN', 'HRD')

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
	FROM Employee
	WHERE DeptID = 'ACC' OR DeptID = 'GEN' OR DeptID = 'HRD'



SELECT EmpID, EmpName, HireDate, RetireDate, DeptID, Phone, EMail, Salary
   FROM Employee
   WHERE Gender = 'F' AND RetireDate IS NULL

SELECT EmpID, EmpName, HireDate, RetireDate, DeptID, Phone, EMail, Salary
   FROM Employee
   WHERE Gender = 'F' AND RetireDate IS NULL AND Salary IS NOT NULL

SELECT EmpID, EmpName, HireDate, RetireDate, DeptID, Phone, EMail, Salary
   FROM Employee
   WHERE (Gender = 'F') AND (RetireDate IS NULL) AND (Salary IS NOT NULL)


SELECT EmpID AS '사번', EmpName AS '이름', Gender AS '성별', HireDate AS '입사일', 
       RetireDate AS '퇴사일', Phone AS '전화번호'
	FROM Employee
	WHERE RetireDate IS NOT NULL

SELECT EmpName + '(' + EmpID + ')' AS 'EmpName', Gender, HireDate, Phone, EMail
	FROM Employee
	WHERE DeptID = 'MKT'

-- ERROR 형변환
SELECT EmpName + '(' + Salary + ')' AS 'EmpName', Gender, HireDate, Phone, EMail
	FROM Employee
	WHERE DeptID = 'MKT'

SELECT EmpName + '(' + CONVERT(varchar(10), Salary) + ')' AS 'EmpName', Gender, HireDate, Phone, EMail
	FROM Employee
	WHERE DeptID = 'MKT'

SELECT EmpID, EmpName, HireDate, Gender, Phone, EMail
	FROM Employee
	WHERE DeptID = 'SYS'

SELECT EmpID, EmpName, CONVERT(char(10), HireDate, 102) AS 'HireDate', Gender, Phone, EMail
	FROM Employee
	WHERE DeptID = 'SYS'

SELECT EmpID, EmpName, Gender, Phone, EMail, FORMAT(Salary, '#,###,##0.') AS 'Salary'
	FROM Employee
	WHERE DeptID = 'SYS'

SELECT 11 + '9', 11+'a'

SELECT EmpName, EmpID, Gender, HireDate, Phone, EMail
   FROM Employee
   WHERE DeptID = 'SYS'
   ORDER BY EmpName ASC

SELECT EmpName, EmpID, Gender, HireDate, Phone, EMail
   FROM Employee
   WHERE DeptID = 'SYS'
   ORDER BY EmpName DESC

SELECT DeptID, EmpID, EmpName, HireDate, Phone, EMail
   FROM Employee
   WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31'
   ORDER BY DeptID ASC, EmpID DESC


SELECT DISTINCT DeptID 
	FROM Employee

SET ROWCOUNT 0
SELECT DeptID, EmpID, EmpName, HireDate, Phone, EMail
   FROM Employee
   ORDER BY DeptID ASC, EmpID DESC

-- 3.3
INSERT INTO Department(DeptID, DeptName, UnitID, StartDate)
   VALUES('PRD', N'상품', 'A', GETDATE())

SELECT * FROM Department

INSERT INTO Department
	VALUES('DBA',N'DB관리', 'A', GETDATE())

INSERT INTO Department(DeptID, DeptName, StartDate)
   VALUES('CST', N'고객관리', GETDATE())

INSERT INTO Department(DeptID, DeptName, UnitID, StartDate)
   VALUES('OPR', N'운영', 'A', GETDATE()), ('DGN', N'디자인', NULL, GETDATE())


CREATE TABLE RetiredEmployee(
	EmpID char(5) PRIMARY KEY
	,EmpName nvarchar(4) NOT NULL
	,HireDate date NOT NULL
	,RetireDate date NOT NULL
	,EMail varchar(50)
)

SELECT * FROM RetiredEmployee
SELECT * FROM Employee

INSERT INTO RetiredEmployee
	SELECT EmpID, EmpName, HireDate, RetireDate, EMail
		FROM Employee
		WHERE RetireDate IS NOT NULL

-- 저장 프로시저 실행 결과 INSERT
CREATE PROC usp_GetVacation
	@EmpID char(5)
AS
	SELECT EmpID, BeginDate, EndDate, Duration, Reason
		FROM Vacation
		WHERE EmpID = @EmpID

-- 일반 테이블이어도 저장 가능
CREATE TABLE #Vacation(
	EmpID char(5),
    BeginDate date,
    EndDate date,
    Duration int,
    Reason nvarchar(50)
)

INSERT INTO #Vacation EXEC usp_GetVacation 'S0001'

SELECT EmpID, BeginDate, EndDate, Duration, Reason
	FROM #Vacation
	WHERE Duration > 5

DROP TABLE #Vacation
-----------------------------------------------------

UPDATE Employee
   SET Phone = '010-1239-1239'
   WHERE EmpID = 'S0001'

SELECT EmpID, EmpName, Gender, HireDate, Phone, EMail
	FROM Employee
	WHERE EmpID = 'S0001'

SELECT * FROM Vacation

UPDATE Employee
   SET Salary = Salary * 0.8
   FROM Employee AS e
   WHERE (SELECT COUNT (*) 
            FROM Vacation 
		    WHERE EmpID = e.EmpID) > 10

DELETE Vacation
	WHERE EndDate <= '2011-12-31'

-- 3.4
SELECT SUM(Salary) AS 'Tot_Salary'
	FROM Employee
	WHERE RetireDate IS NULL

SELECT COUNT(*) AS 'Emp_Count'
	FROM Employee
	WHERE RetireDate IS NULL

SELECT MAX(Salary) AS 'Max_Salary', 
	   MIN(Salary) AS 'Min_Salary',
	   MAX(Salary) - MIN(Salary) AS 'Diff_Salary'
	FROM Employee
	WHERE RetireDate IS NULL


SELECT SUM(Duration) AS 'Tot_Duration'
	FROM Vacation
	WHERE EmpID = 'S0001' 
		AND BeginDate BETWEEN '2014-01-01' AND '2014-12-31'

SELECT MIN(HireDate) AS 'Min_HireDate'
	FROM Employee

SELECT MAX(HireDate) AS 'Max_HireDate'
	FROM Employee

SELECT SUM(Salary) / COUNT(*) AS 'Avg_Salary'
	FROM Employee
	WHERE RetireDate IS NULL

-- NULL값 무시해 분모가 15가 됨
SELECT AVG(Salary) AS 'Avg_Salary'
	FROM Employee
	WHERE RetireDate IS NULL

-- NULL값 체크
SELECT AVG(ISNULL(Salary, 0)) AS 'Avg_Salary'
	FROM Employee
	WHERE RetireDate IS NULL

SELECT COUNT(EngName) AS 'EngName_Count'
	FROM Employee

SELECT COUNT(*) AS 'EngName_Count'
	FROM Employee
	WHERE EngName IS NOT NULL

SELECT DeptID, COUNT(*) AS 'Emp_Count'
	FROM Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID

SELECT DeptID, MIN(EmpName) AS 'First_EmpName', COUNT(*) AS 'Emp_Count'
	FROM Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID

SELECT DeptID, ISNULL(AVG(Salary),0) AS 'AVG_Salary'
	FROM Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID

SELECT DeptID, MAX(Salary) AS 'Max_Salary', MIN(Salary) AS 'Min_Salary',
		MAX(Salary) - MIN(Salary) AS 'Diff_Salary'
	FROM Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID

SELECT DeptID, COUNT(EmpID) AS 'Emp_Count'
	FROM Employee
	WHERE Salary > 5000
	GROUP BY DeptID

SELECT DeptID, COUNT(*) AS 'Emp_Count'
	FROM Employee
	GROUP BY DeptID
	HAVING COUNT(*) >= 3



SELECT DeptID, AVG(Salary) AS 'Avg_Salary'
	FROM Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID

SELECT DeptID, AVG(Salary) AS 'Avg_Salary'
	FROM Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
	HAVING AVG(Salary) > (
		SELECT AVG(Salary) 
			FROM Employee 
			WHERE RetireDate IS NULL
	)


SELECT DeptID, Gender, SUM(Salary) AS 'Tot_Salary'
	FROM Employee
	WHERE DeptID IN('SYS', 'MKT') AND RetireDate IS NULL
	GROUP BY GROUPING SETS(DeptID, Gender)

SELECT DeptID, Gender, SUM(Salary) AS 'Tot_Salary'
	FROM Employee
	WHERE DeptID IN('SYS', 'MKT') AND RetireDate IS NULL
	GROUP BY GROUPING SETS(DeptID, Gender, ())

SELECT DeptID, Gender, SUM(Salary) AS 'Tot_Salary'
	FROM Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	GROUP BY GROUPING SETS((DeptID, Gender), (DeptID))


SELECT DeptID, Gender, SUM(Salary) AS 'Tot_Salary'
	FROM Employee
	WHERE DeptID IN('SYS', 'MKT') AND RetireDate IS NULL
	GROUP BY GROUPING SETS((DeptID, Gender), DeptID, ())


-- 3.5

-- IF...ELSE
DECLARE @Retired char(1)
SET @Retired = 'N'

IF @Retired = 'Y'
	SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
		FROM Employee
		WHERE RetireDate IS NOT NULL
ELSE
	SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
		FROM Employee
		WHERE RetireDate IS NULL

-- 중첩 IF...ELSE
DECLARE @Retired char(1)
DECLARE @Order varchar(10)
SET @Retired = 'Y'
SET @Order = 'DESC'

IF @Retired = 'Y'
	IF @Order = 'DESC' 
		SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
			FROM Employee
			WHERE RetireDate IS NOT NULL
			ORDER BY EmpID DESC
	ELSE
		SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
			FROM Employee
			WHERE RetireDate IS NOT NULL
			ORDER BY EmpID ASC
ELSE
	IF @Order = 'DESC' 
		SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
			FROM Employee
			WHERE RetireDate IS NULL
			ORDER BY EmpID DESC
	ELSE
		SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
			FROM Employee
			WHERE RetireDate IS NULL
			ORDER BY EmpID ASC

-- BEGIN...END
DECLARE @Retired char(1)
SET @Retired = 'N'

IF @Retired = 'Y'
	BEGIN
		SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
			FROM Employee
			WHERE Gender = 'M' AND RetireDate IS NOT NULL
		SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
			FROM Employee
			WHERE Gender = 'F' AND RetireDate IS NOT NULL
	END
ELSE
	BEGIN
		SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
			FROM Employee
			WHERE Gender = 'M' AND RetireDate IS NULL
		SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
			FROM Employee
			WHERE Gender = 'F' AND RetireDate IS NULL
	END


-- WHILE
DECLARE @num int = 1
DECLARE @sum int = 0
--SET @num = 1
--SET @sum = 0
WHILE @num <= 10
	BEGIN
		SET @sum += @num
		SET @num += 1
	END
PRINT @sum


-- WHILE...BREAK
DECLARE @num int = 1
DECLARE @Sum int = 0

WHILE 1 = 1
	BEGIN
		IF @num > 10
			BREAK
		SET @sum += @num
		SET @num += 1
	END
PRINT @sum


-- WHILE...CONTINUE
DECLARE @num int = 0
DECLARE @sum int = 0

WHILE 1 = 1
	BEGIN
		SET @num += 1
		IF @num > 10
			BREAK
		IF @num % 2 = 1
			CONTINUE
		SET @sum += @num
		PRINT @sum
	END
PRINT @sum


-- Rank 순위 매기기
SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary,
		RANK() OVER(ORDER BY Salary DESC) AS 'RANK'
		FROM Employee
		WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
		ORDER BY Salary DESC

-- order by 를 쓸 땐 파티션 조건이 앞!
SELECT EmpID, EmpName, DeptID, Gender, Phone, HireDate, Salary,
		RANK() OVER(PARTITION BY DeptID ORDER BY HireDate DESC) AS 'RANK'
		FROM Employee
		WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
		ORDER BY DeptID DESC, HireDate DESC

SELECT EmpID, SUM(Duration) AS 'Tot_Duration',
		RANK() OVER(ORDER BY SUM(Duration) DESC) AS 'Rank'
	FROM Vacation
	GROUP BY EmpID
	ORDER BY SUM(Duration) DESC

SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary,
		DENSE_RANK() OVER(ORDER BY Salary DESC) AS 'RANK'
		FROM Employee
		WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
		ORDER BY Salary DESC

SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary,
		DENSE_RANK() OVER(PARTITION BY Gender ORDER BY Salary DESC) AS 'RANK'
		FROM Employee
		WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
		ORDER BY Gender ASC, Salary DESC

-- Row number:순번 매기기
SELECT ROW_NUMBER() OVER(ORDER BY EmpID ASC) AS 'Num',
		EmpID, EmpName, DeptID, Gender, Phone, Salary
		FROM Employee
		WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
		ORDER BY EmpID ASC

SELECT ROW_NUMBER() OVER(PARTITION BY Gender ORDER BY EmpID ASC) AS 'Num',
		EmpID, EmpName, DeptID, Gender, Phone, Salary
		FROM Employee
		WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
		ORDER BY Gender ASC, EmpID ASC

SELECT ROW_NUMBER() OVER(ORDER BY BeginDate ASC) AS 'Num',
		EmpID, BeginDate, EndDate,Reason, Duration
		From Vacation
		WHERE BeginDate BETWEEN '2014-10-01' AND '2014-10-31'
		ORDER BY BeginDate ASC

-- NTILE: 영역을 나눴을 때 어느 영역에 포함되는지
SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary,
		NTILE(3) OVER(ORDER BY Salary DESC) AS 'Num'
		FROM Employee
		WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL

SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary,
		NTILE(3) OVER(PARTITION BY Gender ORDER BY Salary DESC) AS 'Num'
		FROM Employee
		WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL

-- PIVOT UNPIVOT
SELECT EmpID, MONTH(BeginDate) AS 'Month', Duration
	FROM Vacation
	WHERE BeginDate BETWEEN '2016-04-01' AND '2016-06-30'

SELECT EmpID, [4], [5], [6]
	FROM(
		SELECT EmpID, MONTH(BeginDate) AS 'Month', Duration
			FROM Vacation
			WHERE BeginDate BETWEEN '2016-04-01' AND '2016-06-30'
	)AS A
	PIVOT(
		SUM(Duration)
		FOR Month IN ([4], [5], [6])
	) AS pvt

SELECT EmpID, ISNULL([4], 0) AS '4월', ISNULL([5],0) AS '5월', ISNULL([6],0) AS '6월'
	FROM(
		SELECT EmpID, MONTH(BeginDate) AS 'Month', Duration
			FROM Vacation
			WHERE BeginDate BETWEEN '2016-04-01' AND '2016-06-30'
		)AS A
		PIVOT(
			SUM(Duration)
			FOR Month IN ([4], [5], [6])
		) AS Pvt

SELECT EmpID, [4], [5], [6]
	INTO mVacation
	FROM (
		SELECT EmpID, MONTH(BeginDate) AS 'Month', Duration
			FROM Vacation
			WHERE BeginDate BETWEEN '2016-04-01' AND '2016-06-30'
		) AS src 
		PIVOT (
			SUM(Duration) FOR Month IN ([4], [5], [6])) AS pvt

SELECT * FROM mVacation

SELECT EmpID, Month, Duration
	FROM mVacation
	UNPIVOT(Duration FOR Month IN ([4], [5], [6])) AS UPVT

-- join
SELECT e.EmpID, e.EmpName, e.DeptID, d.DeptName, e.Phone, e.EMail
	FROM Employee AS e
	INNER JOIN Department as d ON e.DeptID = d.DeptID
	WHERE e.HireDate BETWEEN '2014-01-01' AND '2015-12-31'
		AND RetireDate IS NULL

SELECT e.EmpID, e.EmpName, v.BeginDate, v.EndDate, v.Reason, v.Duration
	FROM Employee AS e
	INNER JOIN Vacation as v ON e.EmpID = v.EmpID
	WHERE e.HireDate BETWEEN '2015-01-01' AND '2016-12-31'
		AND RetireDate IS NULL
	ORDER BY e.EmpID ASC

SELECT d.DeptID, d.DeptName, d.UnitID, u.UnitName, d.StartDate
	FROM Department AS d
	INNER JOIN Unit as u ON d.UnitID = u.UnitID

SELECT e.EmpID, e.EmpName, v.BeginDate, v.EndDate, v.Reason, v.Duration
	FROM Employee AS e
	LEFT OUTER JOIN Vacation as v ON e.EmpID = v.EmpID
	WHERE e.HireDate BETWEEN '2015-01-01' AND '2016-12-31'
		AND RetireDate IS NULL
	ORDER BY e.EmpID ASC

SELECT d.DeptID, d.DeptName, d.UnitID, u.UnitName
	FROM Department AS d
	LEFT OUTER JOIN Unit AS u ON d.UnitID = u.UnitID

SELECT e.EmpID, e.EmpName, d.DeptName, u.UnitName, 
       v.BeginDate, v.EndDate, v.Duration
   FROM Employee AS e
   INNER JOIN Department AS d ON e.DeptID = d.DeptID
   LEFT OUTER JOIN Unit AS u ON d.UnitID = u.UnitID
   INNER JOIN Vacation AS v ON e.EmpID = v.EmpID
   WHERE v.BeginDate BETWEEN '2016-01-01' AND '2016-03-31'
   ORDER BY e.EmpID ASC


-- 하위 쿼리
SELECT EmpID, EmpName, DeptID, Phone, EMail, Salary
	FROM Employee
	WHERE Salary = (SELECT MAX(Salary) FROM Employee)

SELECT EmpID, EmpName, DeptID, Phone, EMail, Salary
	FROM Employee
	WHERE DeptID = 'SYS'
		AND EmpID IN (SELECT EmpID FROM Vacation)

SELECT EmpID, EmpName, DeptID, Phone, EMail, Salary, RetireDate
	FROM Employee
	WHERE RetireDate = (SELECT MAX(RetireDate) FROM Employee)

SELECT EmpID, EmpName, DeptID, (SELECT DeptName FROM Department
	  WHERE DeptID = e.DeptID) AS 'DeptName', Phone, Salary
	FROM Employee AS e
	WHERE Salary > 7000

-- Exists, Not Exists
SELECT EmpID, EmpName, DeptID, Phone, EMail
	FROM Employee e
	WHERE DeptID = 'SYS'
	AND EXISTS (SELECT *
					FROM Vacation
					WHERE EmpID = e.EmpID
				)


SELECT EmpID, EmpName, DeptID, Phone, EMail
	FROM Employee e
	WHERE DeptID = 'SYS'
	AND NOT EXISTS (SELECT *
					FROM Vacation
					WHERE EmpID = e.EmpID
				)


SELECT EmpID, EmpName, DeptID, Gender, HireDate, Phone, EMail
	FROM Employee e
	WHERE HireDate = (
		SELECT MIN(HireDate)
			FROM Employee
			WHERE DeptID = e.DeptID
	)
	ORDER BY EmpID ASC

-- UNION, UNION ALL: 합집합

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31' 

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM Employee
	WHERE Salary >= 7000

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31' 
UNION
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM Employee
	WHERE Salary >= 7000

-- 중복 제거 안되는 UNION ALL
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31' 
UNION ALL
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM Employee
	WHERE Salary >= 7000


-- INTERSECT: 교집합
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31' 
INTERSECT
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM Employee
	WHERE Salary >= 7000


-- EXCEPT: 차집합
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31' 
EXCEPT
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM Employee
	WHERE Salary >= 7000


SELECT GETDATE() -- 밀리초 3자리
SELECT SYSDATETIME() -- 밀리초 7자리

-- 날짜만 가져오기
SELECT CONVERT(date, GETDATE())
SELECT CONVERT(date, SYSDATETIME())

-- 시간만 가져오기: 밀리초 7자리
SELECT CONVERT(time, GETDATE())
SELECT CONVERT(time, SYSDATETIME())

-- DATEADD
DECLARE @date date
SET @date = GETDATE()
SELECT DATEADD(DAY, 100, @date) AS '100일후'
SELECT DATEADD(DAY, -100, @date) AS '100일전'
SELECT DATEADD(MONTH, 100, @date) AS '100개월후'

-- DATEDIFF: 뒤에서 앞의 것 계산하기
DECLARE @date01 date
DECLARE @date02 date
SET @date01 = GETDATE()
SET @date02 = '2020-12-25'
SELECT DATEDIFF(HOUR, @date01, @date02) AS '시간차이'
SELECT DATEDIFF(DAY, @date01, @date02) AS '일차이' 
SELECT DATEDIFF(MONTH, @date01, @date02) AS '개월차이'
SELECT DATEDIFF(YEAR, @date01, @date02) AS '년도차이'

SELECT TOP (5) EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC

SELECT EmpID, EmpName, DeptID, Gender, HireDate, RetireDate, Phone,
	   DATEDIFF(DAY, HireDate, RetireDate) AS [Duration]
	FROM Employee
	WHERE RetireDate IS NOT NULL


-- YEAR, MONTH, DAY

DECLARE @date date
SET @date = GETDATE()
SELECT YEAR(@date) AS [년]
SELECT MONTH(@date) AS [월]
SELECT DAY(@date) AS [일] 


-- DATENAME 

DECLARE @date datetime
SET @date = GETDATE()
SELECT 	'지금은 ' + DATENAME(YEAR, @date) + '년 ' +
		DATENAME(MONTH, @date) + '월 ' +
		DATENAME(DAY, @date) + '일 ' + 
		DATENAME(HOUR, @date) + '시 ' + 
		DATENAME(MINUTE, @date) + '분 ' + 
		DATENAME(SECOND, @date) + '초'


-- REPLACE 

DECLARE @str nvarchar(100)
SET @str = N'오늘은 슬픈 날입니다.'
SELECT REPLACE(@str, N'슬픈', N'즐거운')


-- REPLICATE

DECLARE @str01 nvarchar(100)
DECLARE @str02 nvarchar(100)
DECLARE @str03 nvarchar(100)
SET @str01 = N'오늘은'
SET @str02 = REPLICATE(N'꼭!', 3) 
SET @str03 = N'행복하세요.'

SELECT @str01 + ' ' + @str02 + ' ' + @str03


-- SUBSTRING

DECLARE @str varchar(100)
SET @str = 'ABCDEFGHIJKLMN'
SELECT SUBSTRING(@str, 5, 3)


SELECT EmpID, EmpName, HireDate, SUBSTRING(Phone, 10, 4) AS [Phone_Last_4]
	FROM Employee
	WHERE DeptID = 'SYS'



-- LEFT 함수

DECLARE @str varchar(100)
SET @str = 'ABCDEFGHIJKLMN'
SELECT LEFT(@str, 5)
SELECT RIGHT(@str, 5)

SELECT EmpID, EmpName, HireDate, RIGHT(Phone, 4) AS [Phone_Last_4]
	FROM Employee
	WHERE DeptID = 'SYS'


-- UPPER, LOWER
DECLARE @str varchar(100)
SET @str = 'I Have a Dream.'
SELECT UPPER(@str)
SELECT LOWER(@str)

SELECT TOP (5) EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC

SELECT TOP (5) WITH TIES EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC

-- TOP(n)

-- 정수만 가능
SELECT TOP (5) WITH TIES EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC

-- 소수 가능
SELECT TOP (14.5) PERCENT EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC


SELECT TOP (5) WITH TIES v.EmpID, e.EmpName, SUM(v.Duration) AS [Tot_Duration]
	FROM Vacation AS v
	INNER JOIN Employee AS e ON v.EmpID = e.EmpID
	GROUP BY v.EmpID, e.EmpName
	ORDER BY SUM(v.Duration) DESC


-- CASE
SELECT EmpID, EmpName, 
		 CASE WHEN Gender = 'M' THEN N'남'
			  WHEN Gender = 'F' THEN N'여'
			  ELSE '' END AS [Gender], DeptID, HireDate, Phone, EMail 
	FROM Employee
	WHERE RetireDate IS NOT NULL

SELECT EmpID, EmpName, 
		 CASE Gender WHEN 'M' THEN N'남'
					 WHEN 'F' THEN N'여'
					 ELSE '' END AS [Gender], DeptID, HireDate, EMail 
	FROM Employee
	WHERE RetireDate IS NOT NULL
 


SELECT EmpID, EmpName, 
		 CASE WHEN RetireDate IS NULL THEN N'근무'
			  ELSE N'퇴사' END AS [Status], DeptID, HireDate, Phone, EMail 
	FROM Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31'

SELECT EmpID, EmpName, 
		CASE WHEN EngName IS NULL THEN 'N/A'
			 ELSE EngName END AS [EngName], Phone, EMail
	FROM Employee
	WHERE DeptID = 'SYS'

SELECT EmpID, EmpName, ISNULL(EngName, 'N/A') AS [EngName], Phone, EMail
	FROM Employee
	WHERE DeptID = 'SYS'


SELECT DeptID, EmpID, EmpName, HireDate, Phone, EMail
	FROM Employee
	WHERE RetireDate IS NULL
	ORDER BY CASE DeptID WHEN 'STG' THEN 'AAA' ELSE DeptID END ASC
 


-- IIF

SELECT DeptID, EMpID, EmpName, HireDate, Phone, EMail
	FROM Employee
	WHERE RetireDate IS NULL
	ORDER BY IIF(DeptID = 'STG', 'AAA', DeptID) ASC
 
 -- CTE
 WITH DeptSalary(DeptID, Tot_Salary)
	AS(
		SELECT DeptID, SUM(Salary)
			FROM Employee
			WHERE RetireDate IS NULL
			GROUP BY DeptID
	)
	SELECT * FROM DeptSalary
	WHERE Tot_Salary >=10000


WITH DeptSalary(DeptID, Tot_Salary)
	AS(
		SELECT DeptID, SUM(Salary)
			FROM Employee
			WHERE RetireDate IS NULL
			GROUP BY DeptID
	)
	SELECT CTE.DeptID, D.DeptName, D.UnitID, CTE.Tot_Salary
		FROM DeptSalary AS CTE
		INNER JOIN Department AS D ON CTE.DeptID = D.DeptID
		WHERE CTE.Tot_Salary >= 10000

WITH DeptSalary(DeptID, Tot_Salary)
	AS(
		SELECT DeptID, SUM(Salary)
			FROM Employee
			WHERE RetireDate IS NULL
			GROUP BY DeptID
	),
	DeptNameSalary(DeptID, DeptName, UnitID, Tot_Salary)
	AS(
		SELECT CTE.DeptID, D.DeptName, D.UnitID, CTE.Tot_Salary
			FROM DeptSalary AS CTE
			INNER JOIN  Department AS D ON CTE.DeptID = D.DeptID
			WHERE CTE.Tot_Salary >= 10000
	)

	SELECT CTE.DeptID, CTE.DeptName, CTE.UnitID, U.UnitName, CTE.Tot_Salary
		FROM DeptNameSalary AS CTE
		LEFT OUTER JOIN Unit AS U ON CTE.UnitID = U.UnitID


WITH HireDate_RNK 
	AS (
		SELECT EmpID, EmpName, DeptID, Gender, HireDate, Phone,
				RANK() OVER(PARTITION BY Gender ORDER BY HireDate ASC) AS [Rnk]
			FROM Employee
			WHERE RetireDate IS NULL
	)
SELECT * 
	FROM HireDate_RNK
	WHERE Rnk <= 3


-- 재귀 CTE

SELECT EmpID, EmpName, DeptID, ManagerID
	FROM Employee

WITH CTE_Emp (EmpID, EmpName, DeptID, ManagerID, Level) 
	AS (
	SELECT EmpID, EmpName, DeptID, ManagerID, 0 
		FROM Employee
		WHERE ManagerID IS NULL

	UNION ALL

	SELECT e.EmpID, e.EmpName, e.DeptID, e.ManagerID, c.Level + 1
		FROM Employee AS e
		INNER JOIN CTE_Emp AS c ON c.EmpID = e.ManagerID
)
SELECT * 
	FROM CTE_Emp
	ORDER BY Level ASC



WITH CTE_Emp(EmpID, EmpName, DeptID, ManagerID, Level, ManagerList)
	AS (
		SELECT EmpID, EmpName, DeptID, ManagerID, 0, CAST('' AS nvarchar(1000))
			FROM Employee
			WHERE ManagerID IS NULL

		UNION ALL

		SELECT E.EmpID, E.EmpName, E.DeptID, E.ManagerID, CTE.Level+1,
				CAST('->' + CTE.EmpName + CTE.ManagerList AS nvarchar(1000))
			   FROM Employee AS E
			   INNER JOIN CTE_Emp AS CTE ON CTE.EmpID = E.ManagerID
	)
	SELECT *
		FROM CTE_Emp
		WHERE DeptID = 'SYS'


WITH Dates AS (
	SELECT CAST('2017-01-01' AS date) AS [CalDate]

	UNION ALL

	SELECT DATEADD(day, 1, CalDate) AS [CalDate]
		FROM Dates
		WHERE DATEADD(day, 1, CalDate) < '2018-01-01'
)
SELECT *
	FROM Dates
	-- 재귀 한계 설정
	OPTION (MAXRECURSION 366)


-- Merge
use HRDB2

CREATE TABLE dbo.EmpChanged (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(4) NOT NULL,
	EngName varchar(20) NULL,
	Gender char(1) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NULL,
	DeptID char(3) REFERENCES Department(DeptID) NOT NULL,
	Phone char(13) NULL,
	EMail varchar(50) NOT NULL,
	Salary int NULL
)

INSERT INTO dbo.EmpChanged VALUES('S0001', N'홍길뚱', 'hong', 'M', '2011-01-01', NULL, 'SYS', '010-1234-1234', 'hong@dbnuri.com', 8500)
INSERT INTO dbo.EmpChanged VALUES('S0006', N'김치국', 'kimchi','M', '2013-03-01', NULL, 'HRD', '010-8765-8765', 'kimchi@dbnuri.com',	6000)
INSERT INTO dbo.EmpChanged VALUES('S0020', N'고소해', 'gogo', 'F', '2013-03-01', '2016-09-30', 'STG', '010-9966-1230', 'haha@dbnuri.com', 5000)
INSERT INTO dbo.EmpChanged VALUES('S0021', N'박오버', 'over', 'M', '2016-10-01', NULL, 'SYS', '010-9922-1100', 'over@dbnuri.com', 4500)
INSERT INTO dbo.EmpChanged VALUES('S0022', N'나머지', 'nama', 'F', '2016-10-01', NULL, 'HRD', '010-5599-2271', 'merge@dbnuri.com', 4500)



MERGE Employee AS e1
	USING (SELECT * FROM EmpChanged) AS e2
	ON (e1.EmpID = e2.EmpID)
	WHEN MATCHED THEN
		UPDATE SET e1.EmpName = e2.EmpName, 
					e1.EngName = e2.EngName, 
					e1.Gender = e2.Gender, 
					e1.HireDate = e2.HireDate,
					e1.RetireDate = e2.RetireDate,
					e1.DeptID = e2.DeptID,
					e1.EMail = e2.EMail,
					e1.Phone = e2.Phone,
					e1.Salary = e2.Salary
	WHEN NOT MATCHED THEN
		INSERT VALUES(e2.EmpID, e2.EmpName, e2.EngName, e2.Gender
		, e2.HireDate, e2.RetireDate, e2.DeptID, e2.Phone, e2.EMail, e2.Salary);

SELECT * FROM Employee
	WHERE EmpID IN( 'S0001', 'S0006', 'S0020', 'S0021', 'S0022' )


SELECT * FROM EmpChanged

TRUNCATE TABLE EmpChanged

-- OUTPUT
CREATE TABLE EmpSalaryLog (
	LogID int IDENTITY PRIMARY KEY,
	LogType char(1) NOT NULL,
	EmpID char(5) NOT NULL,
	EmpName nvarchar(4) NOT NULL,
	Salary int NULL,
	chgDate datetime DEFAULT GETDATE()
)

INSERT INTO Employee
		OUTPUT 'I', Inserted.EmpID, Inserted.EmpName, Inserted.Salary
		INTO EmpSalaryLog(LogType, EmpID, EmpName, Salary)
	VALUES ('S0023', N'김새나', 'sana', 'F', '2016-10-01', NULL, 'MKT', '010-6677-3366', 'kimsae@dbnuri.com', 4000)


UPDATE Employee
	SET Salary = Salary * 1.5
		OUTPUT 'U', Inserted.EmpID, Inserted.EmpName, Inserted.Salary
		INTO EmpSalaryLog(LogType, EmpID, EmpName, Salary)
	WHERE DeptID = 'SYS'


DELETE Employee
		OUTPUT 'D', Deleted.EmpID, Deleted.EmpName, Deleted.Salary
		INTO EmpSalaryLog(LogType, EmpID, EmpName, Salary)
	WHERE EmpID = 'S0020'


SELECT * FROM EmpSalaryLog