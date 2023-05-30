--*
--* 2.8. 활용
--*


USE HRDB2
GO


--*
--* 2.8.1. 테이블 정보 확인
--*


-- [소스 2-68] 테이블 정보 확인

EXEC sp_help 'dbo.Employee'
GO



--*
--* 2.8.2. 테이블 행수 확인
--*


-- [소스 2-69] 테이블 행수 확인

SELECT DB_NAME() AS [데이터베이스], o.name AS [테이블], i.rows AS [행수]
	FROM sys.sysobjects AS o 
	INNER JOIN sys.sysindexes  AS i ON o.id = i.id
	WHERE o.xtype = 'U' AND i.indid < 2
	ORDER BY i.rows DESC, o.name ASC
GO



--*
--* 2.8.3. FOREIGN KEY 무시
--*


-- [소스 2-70] FOREIGN KEY 비활성화

-- FOREIGN KEY 확인
SELECT name
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID('dbo.Vacation')
GO

-- FOREIGN KEY 비활성화
ALTER TABLE dbo.Vacation
	NOCHECK CONSTRAINT FK__Vacation__EmpID__2D27B809
GO

-- 데이터 추가
INSERT INTO dbo.Vacation VALUES('S2028','2016-11-15','2016-11-16',N'책쓰기')
GO

-- 확인
SELECT * 
	FROM dbo.Vacation
	WHERE EmpID = 'S2028'
GO

-- FOREIGN KEY 활성화
ALTER TABLE dbo.Vacation
	CHECK CONSTRAINT FK__Vacation__EmpID__2D27B809
GO


/*
ALTER TABLE dbo.Vacation WITH NOCHECK
	ADD CHECK (EndDate >= BeginDate)
GO


ALTER TABLE dbo.Vacation
	NOCHECK CONSTRAINT CK__Vacation__4BAC3F29
GO
*/



--*
--* 2.8.4. 특정 열을 갖는 테이블 찾기
--*


-- [소스 2-71] 특정 열을 갖는 테이블 찾기

USE HRDB2
GO

SELECT OBJECT_NAME(object_id) AS [테이블] FROM sys.columns
	WHERE name ='EmpID' 
GO