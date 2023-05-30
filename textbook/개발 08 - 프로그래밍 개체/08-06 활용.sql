--*
--* 8.6. Ȱ��
--*


USE HRDB2
GO


--*
--* 8.6.1. CREATE OR ALTER
--*


-- [�ҽ� 8-80] ������ ���

IF OBJECT_ID('dbo.usp_DeptEmployee', 'P') IS NOT NULL
	DROP PROC dbo.usp_DeptEmployee
GO

CREATE PROC dbo.usp_DeptEmployee
	@DeptID char(3)
AS
	SELECT EmpID, EmpName, Gender, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE RetireDate IS NULL AND DeptID = @DeptID
GO


-- [�ҽ� 8-81] CREATE OR ALTER �� ���

CREATE OR ALTER PROC dbo.usp_DeptEmployee
	@DeptID char(3)
AS
	SELECT EmpID, EmpName, Gender, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE RetireDate IS NULL AND DeptID = @DeptID
GO



--*
--* 8.6.2. �� ���� ��ħ(Refresh)
--*


-- [�ҽ� 8-82] �� �����

CREATE VIEW dbo.vw_FemaleEmployee
AS
SELECT * 
	FROM dbo.Employee
	WHERE Gender = 'F' AND RetireDate IS NULL
GO

SELECT * FROM dbo.vw_FemaleEmployee
GO


-- [�ҽ� 8-83] �� �߰�

ALTER TABLE dbo.Employee
	ADD Facebook varchar(60) NULL
GO


-- [�ҽ� 8-84] �Ϲ� ������ ��� Ȯ��

SELECT * 
	FROM dbo.Employee
	WHERE Gender = 'F' AND RetireDate IS NULL
GO


-- [�ҽ� 8-85] �� Ȯ��

SELECT * FROM dbo.vw_FemaleEmployee
GO

-- [�ҽ� 8-86] �� ����

ALTER TABLE dbo.Employee
	DROP COLUMN EngName
GO


-- [�ҽ� 8-87] �� Ȯ��

SELECT * FROM dbo.vw_FemaleEmployee
GO


-- [�ҽ� 8-88] �� ���� ��ħ

EXEC sp_refreshview 'dbo.vw_FemaleEmployee'
GO

SELECT * FROM dbo.vw_FemaleEmployee
GO



--*
--* 8.6.3. �ڵ����� ����Ǵ� ���� ���ν���
--*


-- [�ҽ� 8-89] �ڵ����� ������ ���� ���ν��� �����

USE master
GO

CREATE PROC dbo.usp_CopyEmployee
AS
BEGIN
	IF OBJECT_ID('HRDB2.dbo.Employee_bak', 'U') IS NOT NULL
		DROP TABLE HRDB2.dbo.Employee_bak
	SELECT *
		INTO HRDB2.dbo.Employee_bak
		FROM HRDB2.dbo.Employee
END
GO


-- [�ҽ� 8-90] �ڵ����� �����ϵ��� ����

USE master
GO

-- �ڵ� ���� �ɼ� ����
EXEC sp_procoption 
	@ProcName = 'dbo.usp_CopyEmployee', 
	@OptionName = 'startup',   
	@OptionValue = 'on'
GO

-- �ڵ� ���� ���� ���ν��� Ȯ��
SELECT name, type_desc, create_date, modify_date
	FROM sys.procedures 
	WHERE is_auto_executed = 1
GO

-- [�ҽ� 8-91] �ڵ����� �������� �ʵ��� ����

USE master
GO

EXEC sp_procoption 
	@ProcName = 'dbo.usp_CopyEmployee',  
	@OptionName = 'startup',	
	@OptionValue = 'off'
GO 



--*
--* 8.6.4. ���� ������, ������ �����
--*


-- [�ҽ� 8-92] �ڵ����� �������� �ʵ��� ����

IF OBJECT_ID('dbo.usp_GetEmployee_New', 'P') IS NOT NULL
	DROP PROC dbo.usp_GetEmployee_New
GO

CREATE PROC dbo.usp_GetEmployee_New
	@DeptID char(3) = '',
	@Retired char(1) = '',
	@Debug int = 0
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @str varchar(2000)
	SET @str = 'SELECT EmpID, EmpName, Gender, DeptID, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE 1 = 1 '
	IF ISNULL(@DeptID,'') <> ''
		SET @str = @str + ' AND DeptID = ''' + @DeptID + ''''
	IF @Retired = 'Y'
		SET @str = @str + ' AND RetireDate IS NOT NULL'
	IF @Retired = 'N'
		SET @str = @str + ' AND RetireDate IS NULL'
	IF @Debug = 1
		PRINT @str
	ELSE
		EXECUTE(@str)		
END
GO


-- [�ҽ� 8-93] ���� ���ν��� ���� ȣ��

EXEC dbo.usp_GetEmployee_New @DeptID = 'MKT', @Retired = 'Y', @Debug = 0
GO
-- �Ǵ�
EXEC dbo.usp_GetEmployee_New @DeptID = 'MKT', @Retired = 'Y'
GO


-- [�ҽ� 8-94] ����� ���� ���� ���ν��� ȣ��

EXEC dbo.usp_GetEmployee_New @DeptID = 'MKT', @Retired = 'Y', @Debug = 1
GO
/*
SELECT EmpID, EmpName, Gender, DeptID, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE 1 = 1  AND DeptID = 'MKT' AND RetireDate IS NOT NULL
*/