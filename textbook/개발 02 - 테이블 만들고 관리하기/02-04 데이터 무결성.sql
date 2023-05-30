--*
--* 2.4. ������ ���Ἲ
--*


USE HRDB2
GO



--*
--* 2.4.2. NULL�� NOT NULL
--*


-- [�ҽ� 2-39] �ʱ�ȭ ���� ���� ������ NULL

DECLARE @num01 int
SET @num01 = @num01 + 100
SELECT @num01 AS [num01]  -- NULL ǥ�õ�
GO


-- [�ҽ� 2-40] NULL ���� ���� ���� ���� NULL

-- ���̺��� �̹� ������ ����
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
	DROP TABLE dbo.Employee
GO

-- ���̺� �����
CREATE TABLE dbo.Employee (
	EmpID char(5) NOT NULL,
	EmpName nvarchar(10) NOT NULL,
	EngName varchar(20) NULL,
)
GO

-- ������ �߰�
INSERT INTO dbo.Employee(EmpID, EmpName, EngName) VALUES('S0001', N'ȫ�浿', 'Gildong') 
INSERT INTO dbo.Employee(EmpID, EmpName) VALUES('S0002',N'������') 
INSERT INTO dbo.Employee(EmpID, EmpName, EngName) VALUES('S0003',N'���쵿', 'NULL')  
GO

-- Ȯ��
SELECT * FROM dbo.Employee
GO


-- [�ҽ� 2-41] NULL ��ȸ

-- ���ڿ� NULL�� ã�� ����(NULL ��ȸ ����� �ƴ�)
SELECT * FROM dbo.Employee WHERE EngName = 'NULL'
GO

-- NULL�� ���� ������ ��ȸ
SELECT * FROM dbo.Employee WHERE EngName IS NULL
GO

-- NULL�� = �� ��ȸ���� �ʵ��� ��
SELECT * FROM dbo.Employee WHERE EngName = NULL
GO



--*
--* 1.4.3. ����(Constraints)
--*


-- [�ҽ� 2-42] PRIMARY KEY ������ ���� ���̺� �����

-- ���̺��� �̹� ������ ����
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
	DROP TABLE dbo.Employee
GO

-- PRIMARY KEY ������ ���� ���̺� �����
CREATE TABLE dbo.Employee (
	EmpID char(5) PRIMARY KEY, -- PRIMARY KEY ����
	EmpName nvarchar(10) NOT NULL,
	EngName varchar(20) NULL,
	Gender char(1) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NULL,
	DeptID char(3) NOT NULL,
	EMail varchar(60) NOT NULL,
	Salary int NULL 
)
GO


-- [�ҽ� 2-43] PRIMARY KEY ������ ���� Vacation ���̺� ������

-- ���̺��� �̹� ������ ����
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE dbo.Vacation
GO

-- PRIMARY KEY ������ ���� ���̺� �����
CREATE TABLE dbo.Vacation (
	VacationID int IDENTITY PRIMARY KEY, -- PRIMARY KEY ����
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) NULL,
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1)
)
GO


-- [�ҽ� 2-44] PRIMARY KEY ���� ����

-- PRIMARY KEY ���� �̸� Ȯ��
SELECT name
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID('dbo.Employee', 'U') AND type = 'PK'
GO

-- ���̺��� PRIMARY KEY ���� ����
ALTER TABLE dbo.Employee
	DROP CONSTRAINT PK__Employee__AF2DBA79DE7331B9
GO


-- [�ҽ� 2-45] ���� ���̺� PRIMARY KEY ���� �߰�

-- ���̺� PRIMARY KEY ���� �߰�
ALTER TABLE dbo.Employee
	ADD PRIMARY KEY (EmpID)
GO


-- [�ҽ� 2-46] UNIQUE ������ ���� ���̺� �����

-- ���̺��� �̹� ������ ����
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
	DROP TABLE dbo.Employee
GO

-- UNIQUE ������ ���� ���̺� �����
CREATE TABLE dbo.Employee (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(10) NOT NULL,
	EngName varchar(20) NULL,
	Gender char(1) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NULL,
	DeptID char(3) NOT NULL,
	EMail varchar(60) UNIQUE NOT NULL, -- UNIQUE ����
	Salary int NULL 
)
GO


-- [�ҽ� 2-47] UNIQUE ���� ����

-- UNIQUE ���� �̸� Ȯ��
SELECT name
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID('dbo.Employee', 'U') AND type = 'UQ'
GO

-- ���̺��� UNIQUE ���� ����
ALTER TABLE dbo.Employee
	DROP CONSTRAINT UQ__Employee__7614F5F6869308C7
GO


-- [�ҽ� 2-48] �⺻ ���̺� UNIQUE ���� �߰�

-- ���̺� UNIQUE ���� �߰�
ALTER TABLE dbo.Employee
	ADD UNIQUE(EMail) 
GO


-- [�ҽ� 2-49] DEFAULT ������ ���� ���̺� �����

-- ���̺��� �̹� ������ ����
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE dbo.Vacation
GO

-- DEFAULT ������ ���� ���̺� �����
CREATE TABLE dbo.Vacation (
	VacationID int IDENTITY PRIMARY KEY,
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'���λ���',  -- DEFAULT ����
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1)

)
GO


-- [�ҽ� 2-50] DEFAULT ���� ����

-- DEFAULT ���� �̸� Ȯ��
SELECT name 
	FROM sys.default_constraints
	WHERE parent_object_id = OBJECT_ID('dbo.Vacation', 'U') AND type = 'D'
GO

-- ���̺��� DEFAULT ���� ����
ALTER TABLE dbo.Vacation
	DROP CONSTRAINT DF__Vacation__Reason__398D8EEE
GO


-- [�ҽ� 2-51] ���� ���̺� DEFAULT ���� �߰�

-- ���̺� DEFAULT ���� �߰�
ALTER TABLE dbo.Vacation
	ADD DEFAULT N'���λ���' FOR Reason
GO


-- [�ҽ� 2-52] CHECK ������ ���� ���̺� �����

-- ���̺��� �̹� ������ ����
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE dbo.Vacation
GO

--  CHECK ������ ���� ���̺� �����
CREATE TABLE dbo.Vacation (
	VacationID int IDENTITY PRIMARY KEY,
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'���λ���',
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1),
	CHECK (EndDate >= BeginDate) -- CHECK ����
)
GO


-- [�ҽ� 2-53] CHECK ���� ����

-- CHECK ���� �̸� Ȯ��
SELECT name 
	FROM sys.check_constraints
	WHERE parent_object_id = OBJECT_ID('dbo.Vacation', 'U') AND type = 'C'
GO

-- ���̺��� CHECK ���� ����
ALTER TABLE dbo.Vacation
	DROP CONSTRAINT CK__Vacation__3E52440B
GO


-- [�ҽ� 2-54] ���� ���̺� CHECK ���� �߰�

-- ���̺� CHECK ���� �߰�
ALTER TABLE dbo.Vacation
	ADD CHECK (EndDate >= BeginDate)
GO


-- [�ҽ� 2-55] FOREIGN KEY ������ ���� ���̺� �����

-- ���̺��� �̹� ������ ����
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE dbo.Vacation
GO

-- FOREIGN KEY ������ ���� ���̺� �����
CREATE TABLE dbo.Vacation (
	VacationID int IDENTITY PRIMARY KEY,
	EmpID char(5) REFERENCES dbo.Employee(EmpID), -- FOREIGN KEY ����
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'���λ���',
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1),
	CHECK (EndDate >= BeginDate)
)
GO


-- [�ҽ� 2-56] FOREIGN KEY ���� ����

-- FOREIGN KEY ���� �̸� Ȯ��
SELECT name
	FROM sys.foreign_keys 
	WHERE parent_object_id = OBJECT_ID('dbo.Vacation', 'U') AND type = 'F'
GO

-- ���̺��� FOREIGN KEY ���� ����
ALTER TABLE dbo.Vacation
	DROP CONSTRAINT FK__Vacation__EmpID__4222D4EF
GO


-- [�ҽ� 2-57] ���� ���̺� FOREIGN KEY ���� �߰�

-- ���̺� FOREIGN KEY ���� �߰�
ALTER TABLE dbo.Vacation
	ADD FOREIGN KEY (EmpID) REFERENCES dbo.Employee(EmpID)
GO


-- [�ҽ� 2-58] �ܼ� FOREIGN KEY ���� ����

-- dbo.Vacation ���̺� ����
IF OBJECT_ID('dbo.Vacation', 'U') IS NOT NULL
	DROP TABLE dbo.Vacation
GO

-- dbo.Employee ���̺� ����
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
	DROP TABLE dbo.Employee
GO

-- dbo.Employee ���̺� �����
CREATE TABLE dbo.Employee (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(10) NOT NULL,
	EngName varchar(20) NULL,
)
GO

-- ������ �߰�
INSERT INTO dbo.Employee(EmpID, EmpName, EngName) VALUES('S0001', N'ȫ�浿', 'Gildong') 
INSERT INTO dbo.Employee(EmpID, EmpName) VALUES('S0002',N'������') 
INSERT INTO dbo.Employee(EmpID, EmpName, EngName) VALUES('S0003',N'���쵿', 'NULL')  
GO

-- dbo.Employee ���̺� �����
CREATE TABLE dbo.Vacation (
	VacationID int IDENTITY PRIMARY KEY,
	EmpID char(5) NOT NULL,
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'���λ���',
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1),
	CHECK (EndDate >= BeginDate)
)
GO

-- ������ �߰�
INSERT INTO dbo.Vacation VALUES('S0001','2011-01-12','2011-01-12',N'�������')
INSERT INTO dbo.Vacation VALUES('S0001','2011-03-21','2011-03-21',N'�۽��')
INSERT INTO dbo.Vacation VALUES('S0002','2012-02-10','2012-02-13',N'����')
INSERT INTO dbo.Vacation VALUES('S0003','2012-09-17','2012-09-17',N'�޽��� �ʿ�')
GO

-- FOREIGN KEY ���� �߰�(���� �̸��� ���)
ALTER TABLE dbo.Vacation
	ADD CONSTRAINT FK_Vacation_EmpID
	FOREIGN KEY (EmpID) REFERENCES dbo.Employee(EmpID)
GO

-- ���� ���� ����
DELETE dbo.Employee
	WHERE EmpID = 'S0003'
GO
/*
�޽��� 547, ���� 16, ���� 0, �� 323
DELETE ���� REFERENCE ���� ���� "FK_Vacation_EmpID"��(��) �浹�߽��ϴ�. 
�����ͺ��̽� "HRDB2", ���̺� "dbo.Vacation", column 'EmpID'���� �浹�� �߻��߽��ϴ�.
���� ����Ǿ����ϴ�.
*/


-- [�ҽ� 2-59] CASCADE �ɼ� ����

-- ���� FOREIGN KEY ���� ����
ALTER TABLE dbo.Vacation
	DROP CONSTRAINT FK_Vacation_EmpID 
GO

-- FOREIGN KEY ���� �߰�(CASCADE)
ALTER TABLE dbo.Vacation
	ADD CONSTRAINT FK_Vacation_EmpID 
	FOREIGN KEY (EmpID) REFERENCES dbo.Employee(EmpID)
	ON DELETE CASCADE    
	ON UPDATE CASCADE 
GO

-- ���� ���� ����
DELETE dbo.Employee
	WHERE EmpID = 'S0003'
GO

-- ���� ���� ����
UPDATE dbo.Employee
	SET EmpID = 'S0010'
	WHERE EmpID = 'S0001'
GO

-- Ȯ��
SELECT * FROM dbo.Vacation
GO


-- [�ҽ� 2-60] SET NULL �ɼ� ����

-- ���� FOREIGN KEY ���� ����
ALTER TABLE dbo.Vacation
	DROP CONSTRAINT FK_Vacation_EmpID 
GO

-- EmpID�� NULL �� ���
ALTER TABLE dbo.Vacation
	ALTER COLUMN EmpID char(5) NULL
GO

-- FOREIGN KEY ���� �߰�(SET NULL)
ALTER TABLE dbo.Vacation
	ADD CONSTRAINT FK_Vacation_EmpID 
	FOREIGN KEY (EmpID) REFERENCES dbo.Employee(EmpID)
	ON DELETE SET NULL    
	ON UPDATE SET NULL
GO

-- ���� ���� ����
DELETE dbo.Employee
	WHERE EmpID = 'S0002'
GO

-- Ȯ��
SELECT * FROM dbo.Vacation
GO


-- [�ҽ� 2-61] SET DEFAULT �ɼ� ����

-- dbo.Employee�� ������ �߰�
INSERT INTO dbo.Employee(EmpID, EmpName, EngName) VALUES('S0000',N'NULL', 'NULL')  
GO

-- EmpID ���� �⺻ �� ����
ALTER TABLE dbo.Vacation
	ADD CONSTRAINT DF_Vacation_EmpID 
	DEFAULT 'S0000' FOR EmpID 
GO

-- ���� FOREIGN KEY ���� ����
ALTER TABLE dbo.Vacation
	DROP CONSTRAINT FK_Vacation_EmpID 
GO

-- FOREIGN KEY ���� �߰�(SET DEFAULT)
ALTER TABLE dbo.Vacation
	ADD CONSTRAINT FK_Vacation_EmpID 
	FOREIGN KEY (EmpID) REFERENCES dbo.Employee(EmpID)
	ON DELETE SET DEFAULT    
    ON UPDATE SET DEFAULT  
GO

-- ���� ���� ����
DELETE dbo.Employee
	WHERE EmpID = 'S0010'
GO

-- Ȯ��
SELECT * FROM dbo.Vacation
GO