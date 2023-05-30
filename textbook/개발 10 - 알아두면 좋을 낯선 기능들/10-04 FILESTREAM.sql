--*
--* 10.4. FILESTREAM
--*



--*
--* 10.4.3. FILESTREAM �����ͺ��̽� �����
--*


-- [�ҽ� 10-32] FILESTREAM �����ͺ��̽� �����

USE master
GO

-- ���� �׷� �߰�
ALTER DATABASE HRDB2
	ADD FILEGROUP FileStreamFG CONTAINS FILESTREAM 
GO

-- ���� �߰�
ALTER DATABASE HRDB2
	ADD FILE ( 
		NAME = 'HRDB2_FileStream', 
		FILENAME = 'D:\SQLData\HRDB2_FileStream'
	) TO FILEGROUP FileStreamFG
GO



--*
--* 10.4.4. FILESTREAM ���̺� �����
--*


-- [�ҽ� 10-33] FILESTREAM ���̺� �����

USE HRDB2
GO

CREATE TABLE dbo.Photos (
	PhotoID uniqueidentifier ROWGUIDCOL PRIMARY KEY,
	EmpID char(5) NOT NULL,
	Photo varbinary(MAX) FILESTREAM NULL
)
GO


-- [�ҽ� 10-34] FILESTREAM ������ �߰�

USE HRDB2
GO

DECLARE @img AS VARBINARY(MAX)

SELECT @img = CAST(bulkcolumn AS varbinary(max))
	FROM OPENROWSET(BULK 'C:\temp\s0001.jpg', SINGLE_BLOB) AS p   
	 
INSERT INTO dbo.Photos (PhotoID, EmpID, Photo)
	VALUES(NEWID(), 'S0001', @img)
GO