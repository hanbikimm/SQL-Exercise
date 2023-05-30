--*
--* 7.5. �������� ���� ���� �� ����
--*



--*
--* 7.5.1. �ؽ� ��ġ(Hash Match)
--*


-- [�ҽ� 7-30] �ε����� ���� ���� ���¿��� �뷮�� ������ ��ȸ

USE IndexBasic
GO

-- ��� �ε��� ����
EXEC dbo.usp_RemoveAllIndexes
GO

-- ������ ��ȸ
SELECT sh.SalesOrderID, SUM(sd.LineTotal) AS [Total]
	FROM dbo.SalesOrderHeader AS sh
	INNER JOIN dbo.SalesOrderDetail AS sd
		ON sh.SalesOrderID = sd.SalesOrderID
 	WHERE sh.SalesOrderID BETWEEN 333724 AND 435300
	GROUP BY sh.SalesOrderID, sh.OrderDate
GO



--*
--* 7.5.2. ���� ����(Merge Join)
--*


-- [�ҽ� 7-31] ���� ������ ������ ��ȸ

USE IndexBasic
GO

-- ��� �ε��� ����
EXEC dbo.usp_RemoveAllIndexes
GO

-- �ε��� �����
CREATE UNIQUE CLUSTERED INDEX UCL_SalesOrderID
	ON dbo.SalesOrderHeader(SalesOrderID)
	WITH (ONLINE = ON)
GO

CREATE UNIQUE CLUSTERED INDEX UCL_SalesOrderID_SalesOrderDetailID
	ON dbo.SalesOrderDetail(SalesOrderID, SalesOrderDetailID)
	WITH (ONLINE = ON)
GO

-- ������ ��ȸ
SELECT sh.SalesOrderID, SUM(sd.LineTotal) AS [Total]
	FROM dbo.SalesOrderHeader AS sh
	INNER JOIN dbo.SalesOrderDetail AS sd
		ON sh.SalesOrderID = sd.SalesOrderID
 	WHERE sh.SalesOrderID BETWEEN 333724 AND 435300
	GROUP BY sh.SalesOrderID 
GO



--*
--* 7.5.3. ��ø ����(Nested Loop)
--*


-- [�ҽ� 7-32] ���� ������ ������ ��ȸ

USE IndexBasic
GO

SELECT sh.SalesOrderID, SUM(sd.LineTotal) AS [Total]
	FROM dbo.SalesOrderHeader AS sh
	INNER JOIN dbo.SalesOrderDetail AS sd
		ON sh.SalesOrderID = sd.SalesOrderID
 	WHERE sh.SalesOrderID BETWEEN 333724 AND 333730
	GROUP BY sh.SalesOrderID 
GO