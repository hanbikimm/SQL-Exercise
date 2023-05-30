--*
--* 7.7. Ȱ��
--*



--*
--* 7.7.1 �ε��� ��Ȳ ��ȸ
--*


-- [�ҽ� 7-47] �ε��� ��Ȳ

USE HRDB2
GO

SELECT OBJECT_NAME(object_id) AS [���̺��̸�], 
		[HEAP] AS [��(Heap)], 
		[CLUSTERED] AS [Ŭ��������], 
		[NONCLUSTERED] AS [��Ŭ��������], 
		[XML] AS [XML], 
		[SPATIAL] AS [����], 
		[CLUSTERED COLUMNSTORE] AS [�÷������],
		CASE WHEN [HEAP] = 1 AND [NONCLUSTERED] = 0 THEN 'Y' ELSE 'N' END AS [�ε�������]
	FROM (
		SELECT object_id, type_desc
			FROM sys.indexes
			WHERE object_id IN (
				SELECT object_id 
					FROM sys.objects 
					WHERE type = 'U')
			) AS p
	PIVOT (
		COUNT(type_desc) FOR type_desc IN ([HEAP], [CLUSTERED], [NONCLUSTERED], 
			[XML], [SPATIAL], [CLUSTERED COLUMNSTORE], [NONCLUSTERED COLUMNSTORE])
	) AS pvt
	ORDER BY [���̺��̸�]
GO



--*
--* 7.7.2 �ε��� ����ȭ ���� Ȯ��
--*


-- [�ҽ� 7-48] �ε��� ����ȭ ���� Ȯ��

SELECT	DB_NAME(database_id) AS [�����ͺ��̽�], 
		OBJECT_NAME(ps.OBJECT_ID) AS [��ü], 
		i.name AS [�ε���], 
		ps.index_id AS [�ε���ID], 
		index_type_desc AS [�ε�������],
		avg_fragmentation_in_percent AS [����ȭ����], 
		fragment_count AS [����ȭ��], 
		page_count AS [��������]
	FROM sys.dm_db_index_physical_stats(DB_ID(),NULL, NULL, NULL ,'LIMITED') AS ps 
	INNER JOIN sys.indexes AS i WITH (NOLOCK)
		ON ps.[object_id] = i.[object_id] AND ps.index_id = i.index_id
	WHERE database_id = DB_ID()	AND page_count > 1500
	ORDER BY avg_fragmentation_in_percent DESC OPTION (RECOMPILE)
GO 



--*
--* 7.7.3. ONLINE = ON �ɼ�
--*


-- [�ҽ� 7-49] ONLINE = ON �ɼ� ���

-- ��1
CREATE NONCLUSTERED INDEX NCL_CustomerID
	ON dbo.SalesOrderHeader(CustomerID)
	INCLUDE(SalesPersonID)
	WITH (DROP_EXISTING = ON, ONLINE = ON) 
GO

-- ��2
ALTER INDEX NCL_CustomerID
	ON dbo.SalesOrderHeader
	REBUILD WITH (
		PAD_INDEX = ON, 
		FILLFACTOR = 80,
		ONLINE = ON
	)
GO



--*
--* 7.7.4. �ε��� ��Ȱ��ȭ�� Ȱ��ȭ
--*


-- [�ҽ� 7-50] �ε��� �����

USE IndexBasic
GO

-- ��� �ε��� ����
EXEC usp_RemoveAllIndexes
GO

-- �ε��� �����
CREATE NONCLUSTERED INDEX NCL_OrderDate 
	ON dbo.SalesOrderHeader(OrderDate)
GO


-- [�ҽ� 7-51] 2�ϰ��� �ֹ� ��Ȳ ��ȸ

SELECT SalesOrderID, OrderDate, DueDate, ShipDate, TotalDue 
	FROM dbo.SalesOrderHeader
	WHERE OrderDate BETWEEN '2015-07-01' AND '2015-07-02'
GO


-- [�ҽ� 7-52] �ε��� ��Ȱ��ȭ

ALTER INDEX	NCL_OrderDate
	ON dbo.SalesOrderHeader DISABLE
GO


-- [�ҽ� 7-53] 2�ϰ��� �ֹ� ��Ȳ ��ȸ

SELECT SalesOrderID, OrderDate, DueDate, ShipDate, TotalDue 
	FROM dbo.SalesOrderHeader
	WHERE OrderDate BETWEEN '2015-07-01' AND '2015-07-02'
GO


-- [�ҽ� 7-54] �ε��� Ȱ��ȭ

ALTER INDEX	NCL_OrderDate
	ON dbo.SalesOrderHeader REBUILD
GO