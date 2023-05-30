--*
--* 7.6. ��� ����� �������� ���
--*



--*
--* 7.6.1. ��� �����ϱ�
--*


-- [�ҽ� 7-33] Ư�� ���̺� ��� Ȯ��

USE HRDB2
GO

EXEC sp_helpstats 'dbo.Vacation', 'ALL'
GO
 

-- [�ҽ� 7-34] ������ ����� �� �ڵ����� ��������� ���

SELECT VacationID, EmpID, BeginDate, EndDate, Reason, Duration
	FROM dbo.Vacation
	WHERE EmpID = 'S0001'
GO

EXEC sp_helpstats 'dbo.Vacation', 'ALL'
GO


--[�ҽ� 7-35] �ε����� ���� �� ��������� ���

CREATE NONCLUSTERED INDEX NCL_BeginDate 
	ON dbo.Vacation(BeginDate)
GO
 
EXEC sp_helpstats 'dbo.Vacation', 'ALL'
GO


-- [�ҽ� 7-36] �������� ��� �����

CREATE STATISTICS ST_EndDate 
	ON dbo.Vacation(EndDate)
GO

EXEC sp_helpstats 'dbo.Vacation', 'ALL'
GO


-- [�ҽ� 7-37] EmpID ���� ���� ��� ���� ����

DBCC SHOW_STATISTICS ('dbo.Vacation', EmpID)
GO
-- �Ǵ�
DBCC SHOW_STATISTICS ('dbo.Vacation', _WA_Sys_00000002_2B3F6F97)
GO



--*
--* 7.6.2. ��迡 �����ϴ� SQL Server
--*


-- [�ҽ� 7-38] ��� �ε��� ����

USE IndexBasic
GO

EXEC dbo.usp_RemoveAllIndexes
GO


-- [�ҽ� 7-39] �ε��� �����

-- �ε��� �����
CREATE NONCLUSTERED INDEX NCL_OrderDate
	ON dbo.SalesOrderHeader(OrderDate)
GO

-- ��� ���� ����
DBCC SHOW_STATISTICS('dbo.SalesOrderHeader', NCL_OrderDate)
GO


-- [�ҽ� 7-40] ���� ���� ���� ���� ���� �� �� #1

-- �÷� ĳ�� ����
DBCC FREEPROCCACHE
GO

-- ���� ����
SELECT SalesOrderID, SalesOrderNumber, OrderDate, DueDate, ShipDate 
	FROM dbo.SalesOrderHeader
	WHERE OrderDate = '2014-06-20'
GO


-- [�ҽ� 7-41] ���� ���� ���� ���� ���� �� �� #2

-- �÷� ĳ�� ����
DBCC FREEPROCCACHE
GO

-- ���� ����
SELECT SalesOrderID, SalesOrderNumber, OrderDate, DueDate, ShipDate 
	FROM dbo.SalesOrderHeader
	WHERE OrderDate = '2014-06-10'
GO



--*
--* 7.6.3. ���� ��� ����
--*


-- [�ҽ� 7-42] �⺻ ���ø����� ��� ����

-- �⺻ ���ø����� ��� ����
UPDATE STATISTICS dbo.SalesOrderHeader(NCL_OrderDate) 
GO

-- ��� ���� Ȯ��
DBCC SHOW_STATISTICS('dbo.SalesOrderHeader', NCL_OrderDate)
GO


-- [�ҽ� 7-43] ���ø� �ۼ�Ʈ ����

-- ���ø� 20 �ۼ�Ʈ�� ��� ����
UPDATE STATISTICS dbo.SalesOrderHeader(NCL_OrderDate) 
	WITH SAMPLE 20 PERCENT
GO

-- ��� ���� Ȯ��
DBCC SHOW_STATISTICS('dbo.SalesOrderHeader', NCL_OrderDate)
GO


-- [�ҽ� 7-44] Ǯ ��ĵ ����

-- Ǯ ��ĵ���� ��� ����
UPDATE STATISTICS dbo.SalesOrderHeader(NCL_OrderDate)
	 WITH FULLSCAN
GO

-- ��� ���� Ȯ��
DBCC SHOW_STATISTICS('dbo.SalesOrderHeader', NCL_OrderDate)
GO


-- [�ҽ� 7-45] Ư�� ���̺��� ��� ��� ����

UPDATE STATISTICS dbo.SalesOrderHeader
GO


-- [�ҽ� 7-46] Ư�� �����ͺ��̽��� ��� ��� ����

USE IndexBasic
GO

EXEC sp_updatestats
GO
