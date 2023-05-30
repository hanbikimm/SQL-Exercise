--*
--* 2.8. Ȱ��
--*


USE HRDB2
GO


--*
--* 2.8.1. ���̺� ���� Ȯ��
--*


-- [�ҽ� 2-68] ���̺� ���� Ȯ��

EXEC sp_help 'dbo.Employee'
GO



--*
--* 2.8.2. ���̺� ��� Ȯ��
--*


-- [�ҽ� 2-69] ���̺� ��� Ȯ��

SELECT DB_NAME() AS [�����ͺ��̽�], o.name AS [���̺�], i.rows AS [���]
	FROM sys.sysobjects AS o 
	INNER JOIN sys.sysindexes  AS i ON o.id = i.id
	WHERE o.xtype = 'U' AND i.indid < 2
	ORDER BY i.rows DESC, o.name ASC
GO



--*
--* 2.8.3. FOREIGN KEY ����
--*


-- [�ҽ� 2-70] FOREIGN KEY ��Ȱ��ȭ

-- FOREIGN KEY Ȯ��
SELECT name
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID('dbo.Vacation')
GO

-- FOREIGN KEY ��Ȱ��ȭ
ALTER TABLE dbo.Vacation
	NOCHECK CONSTRAINT FK__Vacation__EmpID__2D27B809
GO

-- ������ �߰�
INSERT INTO dbo.Vacation VALUES('S2028','2016-11-15','2016-11-16',N'å����')
GO

-- Ȯ��
SELECT * 
	FROM dbo.Vacation
	WHERE EmpID = 'S2028'
GO

-- FOREIGN KEY Ȱ��ȭ
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
--* 2.8.4. Ư�� ���� ���� ���̺� ã��
--*


-- [�ҽ� 2-71] Ư�� ���� ���� ���̺� ã��

USE HRDB2
GO

SELECT OBJECT_NAME(object_id) AS [���̺�] FROM sys.columns
	WHERE name ='EmpID' 
GO