--*
--* 8.1. 뷰(Views)
--*


USE HRDB2
GO


--*
--* 8.1.2. 뷰 만들기와 관리
--*


-- [소스 8-1] 뷰로 만들 SELECT 문


SELECT e.EmpID, e.EmpName, e.HireDate, d.DeptName, e.Phone, e.EMail
	FROM dbo.Employee AS e
	INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
	WHERE e.Gender = 'M' AND e.RetireDate IS NULL
GO


-- [소스 8-2] SELECT 문을 뷰로 포장하기

CREATE VIEW dbo.vw_ManEmployee
AS
	SELECT e.EmpID, e.EmpName, e.HireDate, d.DeptName, e.Phone, e.EMail
		FROM dbo.Employee AS e
		INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
		WHERE e.Gender = 'M' AND e.RetireDate IS NULL
GO


-- [소스 8-3] 뷰 내용 확인

-- 뷰 전체 내용 가져오기
SELECT * FROM dbo.vw_ManEmployee
GO

-- 뷰에서 2014년 입사자만 가져오기
SELECT EmpID, EmpName, HireDate, DeptName 
	FROM dbo.vw_ManEmployee 
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31'
GO


-- [소스 8-4] 퇴사자 정보를 보여주는 뷰 만들기

-- 뷰 만들기
CREATE VIEW dbo.vw_RetiredEmployee
AS
	SELECT EmpID, EmpName, Gender, HireDate, RetireDate, Phone, EMail
		FROM dbo.Employee
		WHERE RetireDate IS NOT NULL
GO

-- 확인
SELECT * FROM dbo.vw_RetiredEmployee
GO


--[소스 8-5] 열 이름이 한글로 표시되는 뷰 만들기

CREATE VIEW dbo.vw_직원
AS
	SELECT EmpID AS [사번], EmpName AS [이름], Gender AS [성별], HireDate AS [입사일], 
		   Phone AS [전화번호], EMail AS [전자메일]
		FROM dbo.Employee
		WHERE RetireDate IS NULL
GO


-- [소스 8-6] 열 이름이 한글로 표시되는 뷰를 다른 방법으로 만들기

-- 뷰 변경
ALTER VIEW dbo.vw_직원(사번, 이름, 성별, 입사일, 전화번호, 전자메일)
AS
	SELECT EmpID, EmpName, Gender, HireDate, Phone, EMail 
		FROM dbo.Employee
		WHERE RetireDate IS NULL
GO

-- 확인(2014년 입사자만 조회)
SELECT * 
	FROM dbo.vw_직원
	WHERE 입사일 BETWEEN '2014-01-01' AND '2014-12-31'
GO


-- [소스 8-7] 가장 장기간 휴가를 간 TOP 5 뷰

-- 뷰 만들기
CREATE VIEW dbo.vw_MaxDuration_TOP_5
AS
SELECT TOP 5 WITH TIES v.EmpID, e.EmpName, e.DeptID, e.HireDate, v.BeginDate, 
		v.EndDate, v.Reason, v.Duration 
	FROM dbo.Vacation AS v
	INNER JOIN dbo.Employee AS e ON v.EmpID = e.EmpID
	ORDER BY Duration DESC
GO

-- 확인
SELECT * FROM dbo.vw_MaxDuration_TOP_5
GO


-- [소스 8-8] 휴가를 간 적이 없는 직원 정보 뷰

-- 뷰 만들기
CREATE VIEW dbo.vw_NoVacation
AS
SELECT EmpID, EmpName, Gender, DeptID, HireDate, Phone, EMail
	FROM dbo.Employee AS e
	WHERE NOT EXISTS (
		SELECT * 
			FROM dbo.Vacation
			WHERE EmpID = e.EmpID
	)
GO

-- 확인
SELECT * FROM dbo.vw_NoVacation
GO

 
-- [소스 8-9] 뷰 변경

-- 뷰 변경
ALTER VIEW dbo.vw_ManEmployee
AS
	SELECT e.EmpName + '(' + e.EmpID + ')' AS [EmpName], e.HireDate, 
		   d.DeptName, e.Phone, e.EMail
		FROM dbo.Employee AS e
		INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
		WHERE e.Gender = 'M' AND e.RetireDate IS NULL
GO

-- 확인(2014년 입사자만 조회)
SELECT * 
	FROM dbo.vw_ManEmployee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31'
GO


-- [소스 8-10] 뷰 제거거

DROP VIEW dbo.vw_직원
GO


-- [소스 8-11] 뷰 생성 구문 확인

EXEC sp_helptext 'dbo.vw_ManEmployee'
GO


-- [소스 8-12] 뷰 암호화

-- 뷰 암호화
ALTER VIEW dbo.vw_ManEmployee
	WITH ENCRYPTION
AS
	SELECT e.EmpName + '(' + e.EmpID + ')' AS [EmpName], e.HireDate, 
		   d.DeptName, e.Phone, e.EMail
		FROM dbo.Employee AS e
		INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
		WHERE e.Gender = 'M' AND e.RetireDate IS NULL
GO

-- 뷰 구문 확인
EXEC sp_helptext 'dbo.vw_ManEmployee'
GO
/*
개체 'dbo.vw_ManEmployee'의 텍스트가 암호화되었습니다.
*/


-- [소스 8-13] 암호 해제

ALTER VIEW dbo.vw_ManEmployee
AS
	SELECT e.EmpName + '(' + e.EmpID + ')' AS [EmpName], e.HireDate, 
		   d.DeptName, e.Phone, e.EMail
		FROM dbo.Employee AS e
		INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
		WHERE e.Gender = 'M' AND e.RetireDate IS NULL
GO


-- [소스 8-14] SCHEMABINDING 옵션 사용

ALTER VIEW dbo.vw_ManEmployee
	WITH SCHEMABINDING
AS
	SELECT e.EmpName + '(' + e.EmpID + ')' AS [EmpName], e.HireDate, 
		   d.DeptName, e.Phone, e.EMail
		FROM dbo.Employee AS e
		INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
		WHERE e.Gender = 'M' AND e.RetireDate IS NULL
GO


-- [소스 8-15] 열 제거 시도

ALTER TABLE dbo.Employee
	DROP COLUMN EMail
GO

-- 결과
/*
메시지 5074, 수준 16, 상태 1, 줄 158
개체 'vw_ManEmployee'은(는) 열 'EMail'에 종속되어 있습니다.
메시지 5074, 수준 16, 상태 1, 줄 158
개체 'UQ__Employee__7614F5F60E6FED82'은(는) 열 'EMail'에 종속되어 있습니다.
메시지 4922, 수준 16, 상태 9, 줄 158
하나 이상의 개체가 이 열에 액세스하므로 ALTER TABLE DROP COLUMN EMail이(가) 실패했습니다.
*/