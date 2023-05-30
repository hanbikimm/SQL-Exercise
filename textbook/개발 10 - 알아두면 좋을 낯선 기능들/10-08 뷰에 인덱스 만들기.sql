--*
--* 10.8. �ε��̵� ��(Indexed Views)
--*



--*
--* 10.8.2. �Ϲ����� �� �����
--*


-- [�ҽ� 10-51] �Ϲ����� �� �����

USE IndexBasic
GO

-- ��� �ε��� ����
EXEC dbo.usp_RemoveAllIndexes
GO

-- �䰡 ������ ����
IF OBJECT_ID ('dbo.vw_Orders', 'V') IS NOT NULL
	DROP VIEW dbo.vw_Orders
GO

-- �� �����
CREATE VIEW dbo.vw_Orders
AS
	SELECT SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS [Revenue],
		   OrderDate, ProductID, COUNT_BIG(*) AS [Count]
		FROM dbo.SalesOrderDetail AS od
		INNER JOIN dbo.SalesOrderHeader AS o ON od.SalesOrderID = o.SalesOrderID
		GROUP BY OrderDate, ProductID
GO


-- [�ҽ� 10-52] ���� Ȯ��

SET STATISTICS IO ON
GO

SELECT * 
	FROM dbo.vw_Orders
GO

/*

(142113�� ���� ������ ����)
���̺� 'Worktable'. �˻� �� 0, ���� �б� �� 0, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
���̺� 'Workfile'. �˻� �� 0, ���� �б� �� 0, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
���̺� 'SalesOrderDetail'. �˻� �� 1, ���� �б� �� 44274, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
���̺� 'SalesOrderHeader'. �˻� �� 1, ���� �б� �� 24688, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/

SET STATISTICS IO OFF
GO



--*
--* 10.8.3. �信 �ε��� �����
--*


-- [�ҽ� 10-53] SCHEMABINDING �ɼ��� ����� �� �����

ALTER VIEW dbo.vw_Orders
	WITH SCHEMABINDING
AS
	SELECT SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS 'Revenue',
		   OrderDate, ProductID, COUNT_BIG(*) AS 'Count'
		FROM dbo.SalesOrderDetail AS od
		INNER JOIN dbo.SalesOrderHeader AS o ON od.SalesOrderID = o.SalesOrderID
		GROUP BY OrderDate, ProductID
GO


-- [�ҽ� 10-54] �ε��� ���� ���� Ȯ��

SELECT OBJECTPROPERTY(OBJECT_ID('dbo.vw_Orders'), 'IsIndexable')  -- ���: 1
GO


-- [�ҽ� 10-55] �ε��� �����

-- ������ Ŭ�������� �ε��� �����
CREATE UNIQUE CLUSTERED INDEX UCL_vw_Orders_OrderDate_ProductID
    ON dbo.vw_Orders (OrderDate, ProductID)
GO

-- �� Ŭ�������� �ε��� �����
CREATE NONCLUSTERED INDEX NCL_vw_Orders_Revenue
    ON dbo.vw_Orders (Revenue)
GO


-- [�ҽ� 10-56] ���� Ȯ��

SET STATISTICS IO ON
GO

SELECT * 
	FROM dbo.vw_Orders
GO

/*
(142113�� ���� ������ ����)
���̺� 'vw_Orders'. �˻� �� 1, ���� �б� �� 726, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/

SET STATISTICS IO OFF
GO


-- [�ҽ� 10-57] �ٸ� ������ ���� Ȯ��

SET STATISTICS IO ON
GO

SELECT SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS [Rev], 
			OrderDate, ProductID
	FROM dbo.SalesOrderDetail AS od
	INNER JOIN dbo.SalesOrderHeader AS o ON od.SalesOrderID=o.SalesOrderID
			AND ProductID BETWEEN 700 AND 800
			AND OrderDate >= '2016-05-01'
	GROUP BY OrderDate, ProductID
	ORDER BY Rev DESC
GO

/*
(6975�� ���� ������ ����)
���̺� 'vw_Orders'. �˻� �� 1, ���� �б� �� 534, ������ �б� �� 0, �̸� �б� �� 4, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/

SET STATISTICS IO OFF
GO



--*
--* 10.8.4. �ε��� ����
--*


-- [�ҽ� 10-58] �ε��� ����

DROP INDEX UCL_vw_Orders_OrderDate_ProductID 
	ON dbo.vw_Orders 
GO