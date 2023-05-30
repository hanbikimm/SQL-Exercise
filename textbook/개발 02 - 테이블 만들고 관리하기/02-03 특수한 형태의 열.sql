--*
--* 2.3. Ư���� ������ ��
--*


USE HRDB2
GO


--*
--* 2.3.1. ���� ��(Computed Columns)
--*


-- [�ҽ� 2-29] ���� ��

-- Vacation ���̺��� �̹� ������ ����
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE dbo.Vacation
GO

-- Vacation ���̺� �����
CREATE TABLE dbo.Vacation (
	VacationID int,
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) NULL,
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1) -- ��� �� ��
)
GO

-- Duration ���� �����ϰ� ������ �Է�
INSERT INTO dbo.Vacation(VacationID, EmpID, BeginDate, EndDate, Reason)
	VALUES(1, 'S0001', '2012-03-05', '2012-03-07', N'���λ���')
GO

-- ��� �� ��� Ȯ��
SELECT * FROM dbo.Vacation
GO


-- [�ҽ� 2-30] ���� �� ���� �̸� ����

-- Vacation ���̺��� �̹� ������ ����
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE dbo.Vacation
GO

-- Vacation ���̺� �����
CREATE TABLE dbo.Vacation (
	VacationID int,
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) NULL,
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1) PERSISTED -- �̸� ����Ͽ� ����
	)
GO



--*
--* 2.3.2. IDENTITY �Ӽ�
--*


-- [�ҽ� 2-31] �ڵ����� �����Ǵ� ��


-- ���̺��� �̹� ������ ����
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL  
	DROP TABLE dbo.Vacation
GO

-- ���̺� �����
CREATE TABLE dbo.Vacation (
	VacationID int IDENTITY(1, 1),
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) NULL,
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1)
)
GO

-- ������ �߰�
INSERT INTO dbo.Vacation(EmpID, BeginDate, EndDate, Reason)
	VALUES('S0001', '2013-12-24', '2013-12-26', N'ũ�������� ��� ���� ����')
INSERT INTO dbo.Vacation(EmpID, BeginDate, EndDate, Reason)
	VALUES('S0003', '2014-01-01', '2014-01-07', N'�ų� ���� ��� ����')
GO

-- Ȯ��
SELECT * FROM dbo.Vacation
GO


-- [�ҽ� 2-32] �ٽ� ä������ �ʴ� �߰� ��

-- ���� �� �����
DELETE FROM dbo.Vacation WHERE VacationID = 2
GO

-- ���ο� �� �Է�
INSERT INTO dbo.Vacation(EmpID, BeginDate, EndDate, Reason)
	VALUES('S0001', '2014-05-04', '2014-05-04', N'��̳� �̺�Ʈ �غ�')
GO

-- Ȯ��
SELECT * FROM dbo.Vacation
GO


-- [�ҽ� 2-33] ������ �߰� �� ä���

-- ������ �� �Է� ���� ����
SET IDENTITY_INSERT dbo.Vacation ON
GO

-- ������ �߰� �� �Է�
INSERT INTO dbo.Vacation(VacationID, EmpID, BeginDate, EndDate, Reason)
	VALUES(2, 'S0003', '2014-01-01', '2014-01-07', N'�ų� ���� ��� ����')
GO

-- ������ �� �Է� ���� ���(��!)
SET IDENTITY_INSERT dbo.Vacation OFF
GO

-- Ȯ��
SELECT * FROM dbo.Vacation
   	ORDER BY VacationID
GO


-- [�ҽ� 2-34] ���� IDENTITY ���� Ȯ��

DBCC CHECKIDENT ('dbo.Vacation', NORESEED) 
GO  
/*
ID ���� Ȯ��: ���� ID ���� '3'�̸�, ���� �� ���� '3'�Դϴ�.
DBCC ������ �Ϸ�Ǿ����ϴ�. DBCC���� ���� �޽����� ����ϸ� �ý��� �����ڿ��� �����Ͻʽÿ�.
*/


-- [�ҽ� 2-35] ������ �� ����� IDENTITY ���� Ȯ��

DELETE FROM dbo.Vacation WHERE VacationID = 3
GO

DBCC CHECKIDENT ('dbo.Vacation', NORESEED) 
GO 
/*
ID ���� Ȯ��: ���� ID ���� '3'�̸�, ���� �� ���� '2'�Դϴ�.
DBCC ������ �Ϸ�Ǿ����ϴ�. DBCC���� ���� �޽����� ����ϸ� �ý��� �����ڿ��� �����Ͻʽÿ�.
*/


-- [�ҽ� 2-36] IDENTITY ���� ID�� 2�� ����

DBCC CHECKIDENT ('dbo.Vacation', RESEED, 2);  
GO  
/*
 ID ���� Ȯ��: ���� ID ���� '3'�Դϴ�.
DBCC ������ �Ϸ�Ǿ����ϴ�. DBCC���� ���� �޽����� ����ϸ� �ý��� �����ڿ��� �����Ͻʽÿ�.
*/

DBCC CHECKIDENT ('dbo.Vacation', NORESEED) 
GO 
/*
ID ���� Ȯ��: ���� ID ���� '2'�̸�, ���� �� ���� '2'�Դϴ�.
DBCC ������ �Ϸ�Ǿ����ϴ�. DBCC���� ���� �޽����� ����ϸ� �ý��� �����ڿ��� �����Ͻʽÿ�.
*/


-- [�ҽ� 2-37] IDENTITY �Ӽ� ���� ���� ���̺� �����

-- dbo.Member01 ���̺� �����
CREATE TABLE dbo.Member01 (
	MemID int IDENTITY(1, 1),
	MemName varchar(20)
)
GO

-- dbo.Member02 ���̺� �����
CREATE TABLE dbo.Member02 (
	MemID int IDENTITY(100, 10),
	MemName varchar(20)
)
GO

-- Ʈ���� �����
CREATE TRIGGER dbo.trg_Member01
	ON dbo.Member01
	AFTER INSERT
AS
BEGIN
	INSERT INTO dbo.Member02(MemName)
		SELECT MemName FROM Inserted
END


-- [�ҽ� 2-38] ������ �߰� �� ���� �Լ� ��� Ȯ��

INSERT INTO dbo.Member01(MemName)
	VALUES('Hong')
GO

SELECT @@IDENTITY -- ���: 100
GO
   
SELECT SCOPE_IDENTITY() -- ���: 1
GO 
  
SELECT IDENT_CURRENT('dbo.Member01')  -- ���: 1  
SELECT IDENT_CURRENT('dbo.Member02')  -- ���: 100
GO
