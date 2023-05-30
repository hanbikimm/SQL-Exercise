--*
--* 3.2. 기본적인 데이터 조회
--*


USE HRDB2
GO


--*
--* 3.2.1. SELECT 문 시작
--*


-- [소스 3-1] 모든 데이터 조회

SELECT * FROM dbo.Employee
GO


-- [소스 3-2] 모든 데이터 조회

SELECT * FROM dbo.Department
GO

SELECT * FROM dbo.Vacation
GO

SELECT * FROM dbo.Unit
GO


-- [소스 3-3] 일부 열만 조회

SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
GO


-- [소스 3-4] 일부 행만 조회

SELECT *
	FROM dbo.Employee
	WHERE EmpID = 'S0005' 
GO


-- [소스 3-5] 일부 행의 일부 열만 조회

SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE EmpID = 'S0005'
GO



--*
--* 3.2.2. 다양한 연산자
--*


-- [소스 3-6] 비교 연산자 사용

-- 사원 번호가 'S0005'인 직원
SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE EmpID = 'S0005' 
GO

-- 급여가 8,000 이상인 직원
SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE Salary >= 8000 
GO

-- 2013년 이전에 입사한 직원
SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE HireDate < '2013-01-01' 
GO


-- [소스 3-7] 홍길동 2014년 휴가 현황 조회

SELECT BeginDate, EndDate, Reason, Duration
	FROM dbo.Vacation
	WHERE (EmpID = 'S0001') 
		AND (BeginDate >= '2014-01-01' AND BeginDate <= '2014-12-31')
GO
 

-- [소스 3-8] 문자열 패턴 비교

-- 이름이 홍길동인 직원
SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE EmpName = N'홍길동' 
GO

-- 이름이 '김'으로 시작하는 직원
SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE EmpName LIKE N'김%' 
GO

-- 이름에 '김'이 들어간 직원
SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE EmpName LIKE N'%김%' 
GO


-- [소스 3-9] 2015년에 머리가 아파 휴가를 간 경우 조회

SELECT EmpID, BeginDate, EndDate, Reason, Duration
	FROM dbo.Vacation
	WHERE (BeginDate BETWEEN '2015-01-01' AND '2015-12-31')
	      AND (Reason LIKE N'%두통%' OR Reason LIKE N'%머리%')
GO


-- [소스 3-10] 문자 개수 패턴 비교

SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE EMail LIKE '____@%'
GO


-- [소스 3-11] 문자 범위 패턴 비교

SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE Phone LIKE '___-[1-3]%'
GO


-- [소스 3-12] 문자열에 포함된 _ 조회

-- 데이터 변경
UPDATE dbo.Employee
	SET EngName = 'sam_sam'
	WHERE EmpID = 'S0004'
GO

UPDATE dbo.Employee
	SET EngName = 'five_gamja'
	WHERE EmpID = 'S0011'
GO

-- 조회
SELECT EmpID, EmpName, EngName, Phone, EMail
	FROM dbo.Employee
	WHERE EngName LIKE '%[_]%'
GO


-- [소스 3-13] 논리 연산자 사용

-- 2015년부터 입사한 남자 직원
SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail
	FROM dbo.Employee
	WHERE HireDate >= '2015-01-01' AND Gender = 'M'
GO

-- 총무팀이나 인사팀 직원
SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail
	FROM dbo.Employee
	WHERE DeptID = 'GEN' OR DeptID = 'HRD'
GO

-- 정보시스템이 아닌 여자 직원
SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail
	FROM dbo.Employee
	WHERE Gender = 'F' AND NOT DeptID = 'SYS'
GO



--*
--* 3.2.3. 범위 조건과 리스트 조건
--*


-- [소스 3-14] BETWEEN 연산자

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31'
GO

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate >= '2014-01-01' AND HireDate <= '2014-12-31'
GO


-- [소스 3-15] IN 연산자

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE DeptID IN ('ACC', 'GEN', 'HRD')
GO

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE DeptID = 'ACC' OR DeptID = 'GEN' OR DeptID = 'HRD'
GO



--*
--* 3.2.4. NULL값 비교
--*


-- [소스 3-16] IS NULL 사용

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
   FROM dbo.Employee
   WHERE Gender = 'F' AND RetireDate IS NULL
GO


-- [소스 3-17] IS NOT NULL 사용

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
   FROM dbo.Employee
   WHERE Gender = 'F' AND RetireDate IS NULL AND Salary IS NOT NULL
GO


-- [소스 3-18] 괄호로 조건 구분

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
   FROM dbo.Employee
   WHERE (Gender = 'F') AND (RetireDate IS NULL) AND (Salary IS NOT NULL)
GO


-- [참고] 괄호 사용

SELECT 10 + 5 * 2 / 4 - 5 * 2 + 10 * 2 / 5  
SELECT 10 + ((5 * 2) / 4) - (5 * 2) + ((10 * 2) / 5)  
GO



--*
--* 3.2.5. 열 별칭과 열에 대한 계산
--*


-- [소스 3-19] 열 별칭 지정

SELECT EmpID AS [사번], EmpName AS [이름], Gender AS [성별], HireDate AS [입사일], 
       RetireDate AS [퇴사일], Phone AS [전화번호]
	FROM dbo.Employee
	WHERE RetireDate IS NOT NULL
GO


-- [소스 3-20] 의도하지 않은 열 별칭

SELECT EmpID, EmpName, HireDate RetireDate, EMail, Phone
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO


-- [소스 3-21] 문자 데이터 결합

SELECT EmpName + '(' + EmpID + ')' AS [EmpName], Gender, HireDate, Phone, EMail 
	FROM dbo.Employee
	WHERE DeptID = 'MKT'
GO


-- [소스 3-22] 데이터 결합 오류

SELECT EmpName + '(' + Salary + ')' AS [EmpName], Gender, HireDate, Phone, EMail 
	FROM dbo.Employee
	WHERE DeptID = 'MKT'
GO
/*
메시지 245, 수준 16, 상태 1, 줄 191
varchar 값 ')'을(를) 데이터 형식 int(으)로 변환하지 못했습니다.
*/


-- [소스 3-23] 데이터 결합 오류 해결

SELECT EmpName + '(' + CONVERT(varchar(10), Salary) + ')' AS [EmpName], Gender, HireDate, Phone, EMail 
	FROM dbo.Employee
	WHERE DeptID = 'MKT'
GO


-- [소스 3-24] 날짜를 문자로 변환

SELECT EmpID, EmpName, CONVERT(char(10), HireDate, 102) AS 'HireDate', Gender,  
       Phone, EMail
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO


-- [소스 3-25] 천 단위 콤마 찍어서 표시
SELECT EmpID, EmpName, Gender, Phone, EMail, FORMAT(Salary, '#,###,##0.') AS [Salary] 
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO


-- [참고] 자동 형 변환

SELECT 11 + '9'
SELECT 11 + 'A'
GO



--*
--* 3.2.6. 조회 결과 정렬
--*


-- [소스 3-26] 직원 이름으로 오름차순 정렬

SELECT EmpName, EmpID, Gender, HireDate, Phone, EMail
   FROM dbo.Employee
   WHERE DeptID = 'SYS'
   ORDER BY EmpName ASC
GO


-- [소스 3-27] 직원 이름으로 내림차순 정렬

SELECT EmpName, EmpID, Gender, HireDate, Phone, EMail
   FROM dbo.Employee
   WHERE DeptID = 'SYS'
   ORDER BY EmpName DESC
GO


-- [소스 3-28] 부서 코드로 오름차순, 사원 번호로 내림차순 정렬

SELECT DeptID, EmpID, EmpName, HireDate, Phone, EMail
   FROM dbo.Employee
   WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31'
   ORDER BY DeptID ASC, EmpID DESC
GO


-- [소스 3-29] 중복 생략

SELECT DISTINCT DeptID 
	FROM dbo.Employee
GO


-- [소스 3-30] 5개 행만 조회

SET ROWCOUNT 0
GO

SELECT DeptID, EmpID, EmpName, HireDate, Phone, EMail
   FROM dbo.Employee
   ORDER BY DeptID ASC, EmpID DESC
GO