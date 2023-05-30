--*
--* 2.2. �پ��� ������ ����
--*



--*
--* 2.2.1. ������ ���Ŀ� ���� ����
--*


-- [�ҽ� 2-17] ������ ������ ����

DECLARE @num int
SET @num = 45000
SET @num = @num + 55000
SELECT @num
GO

-- ����: 2008���� ������ ����
DECLARE @num int = 45000
SET @num += 55000
SELECT @num
GO


-- [�ҽ� 2-18] ��� �����÷� ���� �߻�

DECLARE @num int
SET @num = 45000
SET @num = @num * 55000
SELECT @num
GO



--*
--* 2.2.2. �ý��� ������ ����
--*


-- [�ҽ� 2-19] ���� ������ ����

DECLARE @num01 int
SET @num01 = 5000000000 -- 50��
GO
/*
�޽��� 8115, ���� 16, ���� 2, �� 32
expression��(��) ������ ���� int(��)�� ��ȯ�ϴ� �� ��� �����÷� ������ �߻��߽��ϴ�.
*/

DECLARE @num02 bigint
SET @num02 = 5000000000 -- 50��
GO


-- [�ҽ� 2-20] �Ǽ� ������ ����

DECLARE @num decimal(10, 3)
SET @num = 1234567.67890
SELECT @num -- 1234567.679
GO

DECLARE @num decimal(10, 3)
SET @num = 12345678.67890
SELECT @num  
GO
/*
�޽��� 8115, ���� 16, ���� 8, �� 52
numeric��(��) ������ ���� numeric(��)�� ��ȯ�ϴ� �� ��� �����÷� ������ �߻��߽��ϴ�.
*/

DECLARE @num01 decimal(10, 8)
SET @num01 = 1/3.0
SELECT @num01  
GO



--*
--* 2.2.4. ��¥�� �ð� ������ ����
--*


-- [�ҽ� 2-21] �پ��� ��¥�� �ð� ������ ����

-- ���� ����
DECLARE @dt01 datetime
DECLARE @dt02 smalldatetime
DECLARE @dt03 date
DECLARE @dt04 time
DECLARE @dt05 datetime2
DECLARE @dt06 datetimeoffset

-- ������ ��¥�� �ð� ���� �Լ� �� ����
SET @dt01 = GETDATE()
SET @dt02 = GETDATE()
SET @dt03 = SYSDATETIME()
SET @dt04 = SYSDATETIME()
SET @dt05 = SYSDATETIME()
SET @dt06 = SYSDATETIMEOFFSET()

-- ������ �� ǥ��
SELECT @dt01 AS [datetime] 
SELECT @dt02 AS [smalldatetime]
SELECT @dt03 AS [date] 
SELECT @dt04 AS [time] 
SELECT @dt05 AS [datetime2]
SELECT @dt06 AS [datetimeoffset]
GO


-- [�ҽ� 2-22] �ڸ��� ����

-- �ڸ��� �����Ͽ� ���� ����
DECLARE @dt01 time(2)
DECLARE @dt02 datetime2(3)
DECLARE @dt03 datetimeoffset(4)

-- ������ ��¥�� �ð� ���� �Լ� �� ����
SET @dt01 = SYSDATETIME()
SET @dt02 = SYSDATETIME()
SET @dt03 = SYSDATETIMEOFFSET()

-- ������ �� ǥ��
SELECT @dt01 AS [time] 
SELECT @dt02 AS [datetime2] 
SELECT @dt03 AS [datetimeoffset]
GO



--*
--* 2.2.5. ���� ������ ����
--*


-- [�ҽ� 2-23] ���� ���̿� ���� ����

-- ���� ����
DECLARE @str01 char(20) -- ���� ����
DECLARE @str02 varchar(20) -- ���� ����

-- ������ �� ����
SET @str01 = 'Gildong!'
SET @str02 = 'Gildong!'

-- ������ ���ڿ� ������ ��� Ȯ��
SELECT @str01 + 'Do you know Jiemae?' AS [Result]
SELECT @str02 + 'Do you know Jiemae?' AS [Result]
GO


-- [�ҽ� 2-24] �����ڵ� ���ڿ�

-- ���� ����
DECLARE @str01 varchar(20) 
DECLARE @str02 nvarchar(20) -- �����ڵ�

-- ������ �� ����
SET @str01 = 'ȫ�浿�� �����Ÿ� ���� ���Ѵ�.'
SET @str02 = N'ȫ�浿�� �����Ÿ� ���� ���Ѵ�.'

-- ���� �� Ȯ��
SELECT @str01 AS [Result]
SELECT @str02 AS [Result]
GO



--*
--* 2.2.6. ��Ÿ Ư���� ������ ����
--*


-- [�ҽ� 2-25] ���̺� ����

-- ���̺� ���� ����
DECLARE @tbl table (
	EmpID char(5),
	EmpName nvarchar(10),
	EMail varchar(60)
)

-- ������ �߰�
INSERT INTO @tbl VALUES('S0001', N'ȫ�浿', 'hong@dbnuri.com')
INSERT INTO @tbl VALUES('S0002', N'������', 'jimae@dbnuri.com')
INSERT INTO @tbl VALUES('S0003', N'���쵿', 'woodong@dbnuri.com')

-- ������ ����
UPDATE @tbl SET EmpName = N'ȫ���'
	WHERE EmpID = 'S0001'

-- Ȯ��
SELECT * FROM @tbl
GO


-- [�ҽ� 2-26] uniqueidentifier ������ ���� ���

USE HRDB2
GO

-- ���̺� �����
CREATE TABLE dbo.Member (
	EmpID char(5),
	EmpName nvarchar(10),
	EMail varchar(60),
	UniqueID uniqueidentifier 
)

-- ������ �߰�
INSERT INTO dbo.Member VALUES('S0001', N'ȫ�浿', 'hong@dbnuri.com', NEWID())
INSERT INTO dbo.Member VALUES('S0002', N'������', 'jimae@dbnuri.com', NEWID())
INSERT INTO dbo.Member VALUES('S0003', N'���쵿', 'woodong@dbnuri.com', NEWID())

-- Ȯ��
SELECT * FROM dbo.Member
GO


-- [�ҽ� 2-27] timestamp ������ ���� ���

USE HRDB2
GO

-- ���̺� ����
DROP TABLE dbo.Member
GO

-- ���̺� �����
CREATE TABLE dbo.Member (
	EmpID char(5),
	EmpName nvarchar(10),
	EMail varchar(60),
	tstamp timestamp 
)

-- ������ �߰�
INSERT INTO dbo.Member(EmpID, EmpName, EMail) VALUES('S0001', N'ȫ�浿', 'hong@dbnuri.com')
INSERT INTO dbo.Member(EmpID, EmpName, EMail) VALUES('S0002', N'������', 'jimae@dbnuri.com')
INSERT INTO dbo.Member(EmpID, EmpName, EMail) VALUES('S0003', N'���쵿', 'woodong@dbnuri.com')

-- Ȯ��
SELECT * FROM dbo.Member
GO


-- [�ҽ� 2-28] ������ ���� �� timestamp �� Ȯ��

-- ������ ����
UPDATE dbo.Member
	SET EMail = 'gildong@dbnuri.com'
	WHERE EmpID = 'S0001'
GO

-- Ȯ��
SELECT * FROM dbo.Member
GO