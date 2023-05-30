--*
--* 7.2. �پ��� �ε��� �����
--*


USE IndexBasic
GO


--*
--* 7.2.1. Ŭ�������� �ε��� 
--*


-- [�ҽ� 7-1] ���̺��� ��ĵ�ϴ� ������

SELECT SalesOrderID, OrderDate, DueDate, ShipDate, CustomerID, SalesPersonID
	FROM dbo.SalesOrderHeader
	WHERE SalesOrderID = 1234567 
GO


-- [�ҽ� 7-2] Ŭ�������� �ε����� ���� PRIMARY KEY �����

ALTER TABLE dbo.SalesOrderHeader 
	ADD PRIMARY KEY CLUSTERED (SalesOrderID)
GO


-- [�ҽ� 7-3] CREATE INDEX ������ Ŭ�������� �ε��� �����

CREATE UNIQUE CLUSTERED INDEX CL_SalesOrderID
	ON dbo.SalesOrderHeader (SalesOrderID)
GO



--*
--* 7.2.2. ��Ŭ�������� �ε���
--*


-- [�ҽ� 7-4] Ŭ�������� �ε��� ��ĵ

SELECT SalesOrderID, OrderDate, DueDate, ShipDate, CustomerID, SalesPersonID
	FROM dbo.SalesOrderHeader
	WHERE CustomerID = 23456
GO


-- [�ҽ� 7-5] CREATE INDEX ������ ��Ŭ�������� �ε��� �����

CREATE NONCLUSTERED INDEX NCL_CustomerID
	ON dbo.SalesOrderHeader(CustomerID)
GO



--*
--* 7.2.3. ���Ե� �ε���(Included Indexes)
--*


-- [�ҽ� 7-6] KEY LOOKUP�� ����ϰ� �߻��ϴ� ������

SELECT SalesOrderID, CustomerID, SalesPersonID
	FROM dbo.SalesOrderHeader
	WHERE CustomerID = 23456
GO


-- [�ҽ� 7-7] ���Ե� �ε��� �����

CREATE NONCLUSTERED INDEX NCL_CustomerID
	ON dbo.SalesOrderHeader(CustomerID)
	INCLUDE(SalesPersonID)
	WITH DROP_EXISTING
GO



--*
--* 7.2.4. ���͵� �ε���(Filtered Indexes)
--*


-- [�ҽ� 7-8] ���� ����Ǵ� ������

SELECT SalesOrderID, OrderDate, DueDate, ShipDate, CustomerID, SalesPersonID
	FROM dbo.SalesOrderHeader
	WHERE OrderDate = '2016-01-01' AND	CurrencyRateID IS NOT NULL
GO


-- [�ҽ� 7-9] ���͵� �ε��� �����

CREATE NONCLUSTERED INDEX NCL_OrderDate
	ON dbo.SalesOrderHeader(OrderDate)
	WHERE CurrencyRateID IS NOT NULL
GO