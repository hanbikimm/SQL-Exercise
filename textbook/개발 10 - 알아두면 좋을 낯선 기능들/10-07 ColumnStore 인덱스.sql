--*
--* 10.7. ColumnStore �ε���
--*



--*
--* 10.7.2. Columnstore �ε��� �����
--*


-- [�ҽ� 10-47] �ε��� �����

USE IndexBasic
GO

-- ���� ��� �ε��� ����
EXEC dbo.usp_RemoveAllIndexes
GO

-- Ŭ�������� �ε��� �����
CREATE CLUSTERED INDEX CL_SalesOrderHeader
	ON dbo.SalesOrderHeader(SalesOrderID)
GO

-- �� Ŭ�������� Columnstore �ε��� �����
CREATE COLUMNSTORE INDEX CSI_SalesOrderHeader
	ON dbo.SalesOrderHeader(SalesOrderID, OrderDate, DueDate, ShipDate, 
		CustomerID, SalesPersonID, SubTotal, TotalDue)
GO


-- [�ҽ� 10-48] ���� ���� ��

SET STATISTICS IO ON
GO

-- Ŭ�������� �ε��� ���
SELECT CustomerID, 
		SUM(SubTotal) AS [SUM_Subtotal], AVG(SubTotal) AS [AVG_Subtotal], 	
		SUM(TotalDue) AS [SUM_TotalDue], AVG(TotalDue) AS [AVG_TotalDue] 
	FROM dbo.SalesOrderHeader
	GROUP BY CustomerID
	ORDER BY CustomerID
	OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX) -- Columnstore �ε��� ����
GO
/*
(19053�� ���� ������ ����)
���̺� 'Worktable'. �˻� �� 0, ���� �б� �� 0, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
���̺� 'Workfile'. �˻� �� 0, ���� �б� �� 0, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
���̺� 'SalesOrderHeader'. �˻� �� 1, ���� �б� �� 24944, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/

-- �� Ŭ�������� Columnstore �ε��� ���
SELECT CustomerID, 
		SUM(SubTotal) AS [SUM_Subtotal], AVG(SubTotal) AS [AVG_Subtotal], 	
		SUM(TotalDue) AS [SUM_TotalDue], AVG(TotalDue) AS [AVG_TotalDue] 
	FROM dbo.SalesOrderHeader
	GROUP BY CustomerID
	ORDER BY CustomerID 
GO
/*
(19053�� ���� ������ ����)
���̺� 'SalesOrderHeader'. �˻� �� 2, ���� �б� �� 0, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 1300, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
'SalesOrderHeader' ���̺��� ���׸�Ʈ�� 1��(��) �а� 0��(��) �ǳʶپ����ϴ�.
���̺� 'Worktable'. �˻� �� 0, ���� �б� �� 0, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/
SELECT * FROM dbo.SalesOrderHeader

UPDATE dbo.SalesOrderHeader
	SET TotalDue = 40000.
	WHERE SalesOrderID = 333724
GO

-- [�ҽ� 10-49] �ε��� �����

-- ���� ��� �ε��� ����
EXEC dbo.usp_RemoveAllIndexes
GO

-- ���� ���̺� Ŭ�������� �ε��� �����
CREATE CLUSTERED INDEX CL_SalesOrderHeader
	ON dbo.SalesOrderHeader(SalesOrderID)
GO

-- ���� ���ο� ���̺� �����
SELECT * 
	INTO dbo.New_SalesOrderHeader
	FROM dbo.SalesOrderHeader
GO

-- ���ο� ���̺� Ŭ�������� Columnstore �ε��� �����
CREATE CLUSTERED COLUMNSTORE INDEX CSI_New_SalesOrderHeader
	ON dbo.New_SalesOrderHeader 
GO


-- [�ҽ� 10-50] ���� ���� ��

-- Ŭ�������� �ε��� ���
SELECT CustomerID, 
		SUM(SubTotal) AS [SUM_Subtotal], AVG(SubTotal) AS [AVG_Subtotal], 	
		SUM(TotalDue) AS [SUM_TotalDue], AVG(TotalDue) AS [AVG_TotalDue] 
	FROM dbo.SalesOrderHeader
	GROUP BY CustomerID
	ORDER BY CustomerID
GO
/*
(19053�� ���� ������ ����)
���̺� 'Worktable'. �˻� �� 0, ���� �б� �� 0, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
���̺� 'Workfile'. �˻� �� 0, ���� �б� �� 0, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
���̺� 'SalesOrderHeader'. �˻� �� 1, ���� �б� �� 24944, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/

-- Ŭ�������� Columnstore �ε��� ���
SELECT CustomerID, 
		SUM(SubTotal) AS [SUM_Subtotal], AVG(SubTotal) AS [AVG_Subtotal], 	
		SUM(TotalDue) AS [SUM_TotalDue], AVG(TotalDue) AS [AVG_TotalDue] 
	FROM dbo.New_SalesOrderHeader
	GROUP BY CustomerID
	ORDER BY CustomerID 
GO
/*
(19053�� ���� ������ ����)
���̺� 'New_SalesOrderHeader'. �˻� �� 1, ���� �б� �� 0, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 891, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
'New_SalesOrderHeader' ���̺��� ���׸�Ʈ�� 2��(��) �а� 0��(��) �ǳʶپ����ϴ�.
���̺� 'Worktable'. �˻� �� 0, ���� �б� �� 0, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/
