--*
--* 7.4. �ε����� ����� ������ �ۼ�
--*



--*
--* 7.4.1. �� �������� �ʱ�
--*


-- [�ҽ� 7-15] �ε��� �����

USE IndexBasic
GO

-- ��� �ε��� ����
EXEC dbo.usp_RemoveAllIndexes
GO

-- �ε��� �����
CREATE NONCLUSTERED INDEX NCL_OrderDate_DueDate_ShipDate
	ON dbo.SalesOrderHeader(OrderDate, DueDate, ShipDate)
	WITH (ONLINE = ON)
GO


-- [�ҽ� 7-16] ���� ������ ��� ���� ���� Ȯ��

-- ������ I/O ���� ǥ��
SET STATISTICS IO ON
GO

-- ���� ����
SELECT SalesOrderID, Status, SalesOrderNumber, AccountNumber, 
	   CreditCardApprovalCode, TotalDue
	FROM dbo.SalesOrderHeader
	WHERE CONVERT(char(8), OrderDate, 112) = '20140602'
GO

-- ������ I/O ���� ǥ�� ���
SET STATISTICS IO ON
GO

/*
(912�� ���� ������ ����)
���̺� 'SalesOrderHeader'. �˻� �� 5, ���� �б� �� 24693, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/

-- [�ҽ� 7-17] ���� �������� ���� ��� ���� ���� Ȯ��

-- ������ I/O ���� ǥ��
SET STATISTICS IO ON
GO

-- ���� ����
SELECT SalesOrderID, Status, SalesOrderNumber, AccountNumber, CreditCardApprovalCode, TotalDue
	FROM dbo.SalesOrderHeader
	WHERE OrderDate = '20140602'
GO

-- ������ I/O ���� ǥ�� ���
SET STATISTICS IO OFF
GO

/*
(912�� ���� ������ ����)
���̺� 'SalesOrderHeader'. �˻� �� 1, ���� �б� �� 919, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/



--*
--* 7.4.2. ���� �񱳵Ǵ� ������ ���� ��ġ��Ű��
--*


-- [�ҽ� 7-18] �ε��� �����

USE IndexBasic
GO

-- ��� �ε��� ����
EXEC dbo.usp_RemoveAllIndexes
GO

-- �ε��� �����
CREATE NONCLUSTERED INDEX NCL_CreditCardApprovalCode
	ON dbo.SalesOrderHeader(CreditCardApprovalCode)
	WITH (ONLINE = ON)
GO


-- [�ҽ� 7-19] ������ ������ ��ġ���� ���� ��� ���� Ȯ��

-- ������ I/O ���� ǥ��
SET STATISTICS IO ON
GO

-- ���� ����
SELECT SalesOrderID, Status, SalesOrderNumber, OrderDate, AccountNumber, TotalDue 
	FROM dbo.SalesOrderHeader
	WHERE CreditCardApprovalCode = N'88031Vi9920'
GO

-- ������ I/O ���� ǥ�� ���
SET STATISTICS IO OFF
GO

/*
(17�� ���� ������ ����)
���̺� 'SalesOrderHeader'. �˻� �� 1, ���� �б� �� 3933, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/


-- [�ҽ� 7-20] ������ ������ �����ϴ� ��� ���� Ȯ��

-- ������ I/O ���� ǥ��
SET STATISTICS IO ON
GO

-- ���� ����
SELECT SalesOrderID, Status, SalesOrderNumber, OrderDate, AccountNumber, TotalDue 
	FROM dbo.SalesOrderHeader
	WHERE CreditCardApprovalCode = '88031Vi9920'
GO

-- ������ I/O ���� ǥ�� ���
SET STATISTICS IO OFF
GO

/*
(17�� ���� ������ ����)
���̺� 'SalesOrderHeader'. �˻� �� 1, ���� �б� �� 20, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/



--*
--* 7.4.3. ���ʿ��� ���� �����ϱ�
--*


-- [�ҽ� 7-21] �ε��� �����

USE IndexBasic
GO

-- ��� �ε��� ����
EXEC dbo.usp_RemoveAllIndexes
GO

-- �ε��� �����
CREATE NONCLUSTERED INDEX NCL_PurchaseOrderNumber
	ON dbo.SalesOrderHeader(PurchaseOrderNumber)
	WITH (ONLINE = ON)
GO


-- [�ҽ� 7-22] ���ʿ��� �Լ��� ������ ��� ���� Ȯ��

-- ������ I/O ���� ǥ��
SET STATISTICS IO ON
GO

-- ���� ����
SELECT SalesOrderID, Status, SalesOrderNumber, OrderDate, AccountNumber, TotalDue
	FROM dbo.SalesOrderHeader
	WHERE ISNULL(PurchaseOrderNumber, '') = 'PO3828168588'
GO

-- ������ I/O ���� ǥ�� ���
SET STATISTICS IO OFF
GO

/*
(17�� ���� ������ ����)
���̺� 'SalesOrderHeader'. �˻� �� 1, ���� �б� �� 2220, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/


-- [�ҽ� 7-23] ���ʿ��� �Լ��� ������ ��� ���� Ȯ��

-- ������ I/O ���� ǥ��
SET STATISTICS IO ON
GO

-- ���� ����
SELECT SalesOrderID, Status, SalesOrderNumber, OrderDate, AccountNumber, TotalDue
	FROM dbo.SalesOrderHeader
	WHERE PurchaseOrderNumber = 'PO3828168588'
GO

-- ������ I/O ���� ǥ�� ���
SET STATISTICS IO OFF
GO

/*
(17�� ���� ������ ����)
���̺� 'SalesOrderHeader'. �˻� �� 1, ���� �б� �� 20, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/



--*
--* 7.4.4. ù ��° �ε��� Ű �� ����ϱ�
--*


-- [�ҽ� 7-24] �ε��� �����

USE IndexBasic
GO

-- ��� �ε��� ����
EXEC dbo.usp_RemoveAllIndexes
GO

-- �ε��� �����
CREATE UNIQUE CLUSTERED INDEX CL_SalesOrderDetail
	ON dbo.SalesOrderDetail(SalesOrderID, SalesOrderDetailID)
	WITH (ONLINE = ON)
GO


-- [�ҽ� 7-25] ù ��° �ε��� Ű ���� ������ ��� ���� Ȯ��

-- ������ I/O ���� ǥ��
SET STATISTICS IO ON
GO

-- ���� ����
SELECT SalesOrderID, SalesOrderDetailID, ProductID, OrderQty, LineTotal
	FROM dbo.SalesOrderDetail
	WHERE SalesOrderDetailID = 887788
GO

-- ������ I/O ���� ǥ�� ���
SET STATISTICS IO OFF
GO

/*
(1�� ���� ������ ����)
���̺� 'SalesOrderDetail'. �˻� �� 5, ���� �б� �� 44833, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/


-- [�ҽ� 7-26] ù ��° �ε��� Ű ���� ������ ��� ���� Ȯ��

-- ������ I/O ���� ǥ��
SET STATISTICS IO ON
GO

-- ���� ����
SELECT SalesOrderID, SalesOrderDetailID, ProductID, OrderQty, LineTotal
	FROM dbo.SalesOrderDetail
	WHERE SalesOrderID = 333724 AND SalesOrderDetailID = 887788
GO

-- ������ I/O ���� ǥ�� ���
SET STATISTICS IO OFF
GO

/*
(1�� ���� ������ ����)
���̺� 'SalesOrderDetail'. �˻� �� 0, ���� �б� �� 3, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/



--*
--* 7.4.5. �ʿ��� ���� SELECT ���� �����ϱ�
--*


-- [�ҽ� 7-27] �ε��� �����

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

CREATE NONCLUSTERED INDEX NCL_OrderDate_DueDate_ShipDate
	ON dbo.SalesOrderHeader(OrderDate, DueDate, ShipDate)
	WITH (ONLINE = ON)
GO


-- [�ҽ� 7-28] Status ���� ������ ��� ���� Ȯ��

-- ������ I/O ���� ǥ��
SET STATISTICS IO ON
GO

-- ���� ����
SELECT SalesOrderID, OrderDate, DueDate, ShipDate, Status
	FROM dbo.SalesOrderHeader
	WHERE OrderDate BETWEEN '2014-06-02' AND '2014-06-05'
GO

-- ������ I/O ���� ǥ�� ���
SET STATISTICS IO OFF
GO

/*
(3827�� ���� ������ ����)
���̺� 'SalesOrderHeader'. �˻� �� 1, ���� �б� �� 11743, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
���̺� 'Worktable'. �˻� �� 0, ���� �б� �� 0, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/


-- [�ҽ� 7-29] Status ���� ������ ��� ���� Ȯ��

-- ������ I/O ���� ǥ��
SET STATISTICS IO ON
GO

-- ���� ����
SELECT SalesOrderID, OrderDate, DueDate, ShipDate 
	FROM dbo.SalesOrderHeader
	WHERE OrderDate BETWEEN '2014-06-02' AND '2014-06-05'
GO

-- ������ I/O ���� ǥ�� ���
SET STATISTICS IO OFF
GO

/*
(3827�� ���� ������ ����)
���̺� 'SalesOrderHeader'. �˻� �� 1, ���� �б� �� 14, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/