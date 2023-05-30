--*
--* 2.1. ���̺� �����
--*



--*
--* 2.1.1. �н� �غ�
--*


-- [�ҽ� 2-1] HRDB2 �����ͺ��̽� �����

USE master
GO
 
CREATE DATABASE HRDB2
GO



--*
--* 2.1.4. CREATE TABLE ������ �����
--*


-- [�ҽ� 2-2] ���� ���̺� �����

USE HRDB2
GO

CREATE TABLE dbo.���� (
    �����ȣ char(5) NOT NULL,
    �̸� nchar(10) NOT NULL,
    ���� char(1) NOT NULL,
    �Ի��� date NOT NULL,
    ���ڿ��� varchar(60) NOT NULL,
	�μ��ڵ� char(3) NOT NULL
) 
GO



--*
--* 2.1.5. ���̺� ����
--*


-- [�ҽ� 2-3] �� �߰�

ALTER TABLE dbo.����
	ADD �޿� int NULL
GO


-- [�ҽ� 2-4] ���� ���̺� NOT NULL �Ӽ� �߰�
INSERT INTO dbo.���� VALUES('S0001', N'ȫ�浿', 'M', '2011-01-01', 'hong@dbnuri.com', 'SYS', 8500)
INSERT INTO dbo.���� VALUES('S0002', N'������', 'M', '2011-01-12', 'jimae@dbnuri.com', 'GEN', 8200)
GO

ALTER TABLE dbo.����
	ADD EngName varchar(20) NOT NULL
GO
/*
�޽��� 4901, ���� 16, ���� 1, �� 42
ALTER TABLE�� Null ���� �����ϰų� DEFAULT ���ǰ� ������ ���� �߰��� �� �ֽ��ϴ�. 
�Ǵ� �߰��Ǵ� ���� ID �Ǵ� Ÿ�ӽ����� ���̾�� �մϴ�. ���� ������ ��� �������� ���� ��� ���̺��� ��� �־�� �� ���� �߰��� �� �ֽ��ϴ�. �� 'EngName'��(��) �̷��� ������ �������� �����Ƿ� ��� ���� ���� ���̺� '����'�� �߰��� �� �����ϴ�.
*/


-- [�ҽ� 2-5] DEFAULT ����� IDENTITY �Ӽ� ���

-- DEFAULT ����
ALTER TABLE dbo.����
	ADD EngName varchar(20) DEFAULT('') NOT NULL
GO

-- IDENTITY �Ӽ�
ALTER TABLE dbo.����
	ADD CheckID int IDENTITY(1, 1) NOT NULL 
GO

SELECT * FROM dbo.����
GO


-- [�ҽ� 2-6] �� ����

ALTER TABLE dbo.����
	DROP COLUMN �޿�
GO


-- [�ҽ� 2-7] �� ����

ALTER TABLE dbo.����
    ALTER COLUMN �̸� nvarchar(20) NOT NULL
GO


-- [�ҽ� 2-8] �� �̸� ����

EXEC sp_rename 'dbo.����.���ڿ���', '�̸���',  'COLUMN'
GO
/*
����: ��ü �̸� �κ��� �����ϸ� ��ũ��Ʈ �� ���� ���ν����� �ջ��ų �� �ֽ��ϴ�.
*/


-- [�ҽ� 2-9] ���̺� �̸� ����

EXEC sp_rename 'dbo.����', '��������', 'OBJECT'
GO
/*
����: ��ü �̸� �κ��� �����ϸ� ��ũ��Ʈ �� ���� ���ν����� �ջ��ų �� �ֽ��ϴ�.
*/


-- [�ҽ� 2-10] ���̺� ����

DROP TABLE dbo.��������
GO



--*
--* 2.1.6. ������ ����(Collations)
--*



-- [�ҽ� 2-11] ���� ���̺� ����� 

USE HRDB2
GO

CREATE TABLE dbo.���� (
    �����ȣ char(5) NOT NULL,
    �̸� nchar(10) NOT NULL,
    ���� char(1) NOT NULL,
    �Ի��� date NOT NULL,
    ���ڿ��� varchar(60) NOT NULL,
    �μ��ڵ� char(3) NOT NULL
) 
GO


-- [�ҽ� 2-12] ������ ���� ���� Ȯ��

-- SQL Server ������ ���� Ȯ��
SELECT SERVERPROPERTY('collation')
GO
/*
Korean_Wansung_CI_AS
*/

-- HRDB2 �����ͺ��̽� ������ ���� Ȯ��(���1)
SELECT DATABASEPROPERTYEX('HRDB2','collation')
GO
/*
Korean_Wansung_CI_AS
*/

-- HRDB2 �����ͺ��̽� ������ ���� Ȯ��(���2)
SELECT collation_name
	FROM sys.databases
	WHERE name = 'HRDB2'
GO
/*
Korean_Wansung_CI_AS
*/


-- [�ҽ� 2-13] ���� ��� �����Ͽ� ���̺� �ٽ� �����

-- ���� ���̺� ����
DROP TABLE dbo.����
GO

-- ���̺� �����
CREATE TABLE dbo.���� (
    �����ȣ char(5) COLLATE Korean_Wansung_CI_AS NOT NULL,
    �̸� nchar(10) COLLATE Korean_Wansung_CI_AS NOT NULL,
    ���� char(1) COLLATE Korean_Wansung_CI_AS NOT NULL,
    �Ի��� date NOT NULL,
    ���ڿ��� varchar(60) COLLATE Korean_Wansung_CI_AS NOT NULL,
    �μ��ڵ� char(3) COLLATE Korean_Wansung_CI_AS NOT NULL
) 
GO


-- [�ҽ� 2-14] ������ �߰�

INSERT INTO dbo.���� VALUES('S0001', N'ȫ�浿', 'M', '2011-01-01', 'hong@dbnuri.com', 'SYS')
INSERT INTO dbo.���� VALUES('S0002', N'������', 'm', '2011-01-12', 'jimae@dbnuri.com', 'GEN')
INSERT INTO dbo.���� VALUES('S0004', N'����', 'F', '2012-08-01', 'samsoon@dbnuri.com', 'MKT')
GO


-- [�ҽ� 2-15] ��ҹ��� ���� ���� Ȯ��

SELECT �����ȣ, �̸�, ����, �Ի���, ���ڿ���, �μ��ڵ�
	FROM dbo.����
	WHERE ���� = 'M'
GO


-- [�ҽ� 2-16] ������ ���� ��Ʈ ���

SELECT �����ȣ, �̸�, ����, �Ի���, ���ڿ���, �μ��ڵ�
	FROM dbo.����
	WHERE ���� = 'M' COLLATE Korean_Wansung_CS_AS
GO