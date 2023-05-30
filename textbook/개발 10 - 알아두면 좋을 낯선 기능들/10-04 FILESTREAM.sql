--*
--* 10.4. FILESTREAM
--*



--*
--* 10.4.3. FILESTREAM 데이터베이스 만들기
--*


-- [소스 10-32] FILESTREAM 데이터베이스 만들기

USE master
GO

-- 파일 그룹 추가
ALTER DATABASE HRDB2
	ADD FILEGROUP FileStreamFG CONTAINS FILESTREAM 
GO

-- 파일 추가
ALTER DATABASE HRDB2
	ADD FILE ( 
		NAME = 'HRDB2_FileStream', 
		FILENAME = 'D:\SQLData\HRDB2_FileStream'
	) TO FILEGROUP FileStreamFG
GO



--*
--* 10.4.4. FILESTREAM 테이블 만들기
--*


-- [소스 10-33] FILESTREAM 테이블 만들기

USE HRDB2
GO

CREATE TABLE dbo.Photos (
	PhotoID uniqueidentifier ROWGUIDCOL PRIMARY KEY,
	EmpID char(5) NOT NULL,
	Photo varbinary(MAX) FILESTREAM NULL
)
GO


-- [소스 10-34] FILESTREAM 데이터 추가

USE HRDB2
GO

DECLARE @img AS VARBINARY(MAX)

SELECT @img = CAST(bulkcolumn AS varbinary(max))
	FROM OPENROWSET(BULK 'C:\temp\s0001.jpg', SINGLE_BLOB) AS p   
	 
INSERT INTO dbo.Photos (PhotoID, EmpID, Photo)
	VALUES(NEWID(), 'S0001', @img)
GO