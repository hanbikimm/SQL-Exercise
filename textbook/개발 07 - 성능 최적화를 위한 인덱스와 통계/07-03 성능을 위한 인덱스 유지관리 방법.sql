--*
--* 7.3. ������ ���� �ε��� �������� ���
--*


USE IndexBasic
GO


--*
--* 7.3.1. �ε��� �ٽ� ������ �ٽ� �ۼ�
--*


-- [�ҽ� 7-10] �ε��� �ٽ� ����

ALTER INDEX NCL_CustomerID 
	ON dbo.SalesOrderHeader
	REORGANIZE
GO


-- [�ҽ� 7-11] �ε��� �ٽ� �ۼ�

ALTER INDEX NCL_CustomerID
	ON dbo.SalesOrderHeader
	REBUILD
GO


-- [�ҽ� 7-12] ���̺��� ��� �ε��� �ɼ� ������ �ٽ� �ۼ�

ALTER INDEX ALL 
	ON dbo.SalesOrderHeader
	REBUILD
GO



--*
--* 7.3.2. FILLFACTOR �ɼ� ���
--*


-- [�ҽ� 7-13] FILLFACTOR ����

ALTER INDEX NCL_CustomerID
	ON dbo.SalesOrderHeader
	REBUILD WITH (
		PAD_INDEX = ON, 
		FILLFACTOR = 80
	)
GO



--*
--* 7.3.3. �ε��� ����
--*


-- [�ҽ� 7-14] �ε��� ����

DROP INDEX NCL_CustomerID 
	ON dbo.SalesOrderHeader
GO