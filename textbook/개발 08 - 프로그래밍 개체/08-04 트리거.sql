--*
--* 8.4. Ʈ����(Triggers)
--*


USE HRDB2
GO


--*
--* 8.4.2. DML Ʈ���� �����
--*


-- [�ҽ� 8-49] �߸��� Ʈ����

CREATE TRIGGER dbo.trg_Employee_S0009
	ON dbo.Employee
	AFTER DELETE
AS
	DECLARE @EmpID char(5)
	SELECT @EmpID = EmpID FROM Deleted
	IF @EmpID = 'S0009'
	BEGIN
		RAISERROR('�ֻ�� ������ ���Ե� ���� �۾��� ����� �� �����ϴ�', 16, 1)
		ROLLBACK TRANSACTION
	END
GO


-- [�ҽ� 8-50] ������ ���� �õ�

DELETE dbo.Employee
	WHERE EmpID = 'S0009'
GO
/*
�޽��� 50000, ���� 16, ���� 1, ���ν��� trg_Employee_S0004, �� 9 [��ġ ���� �� 35]
�ֻ�� ������ ���Ե� ���� �۾��� ����� �� �����ϴ�
�޽��� 3609, ���� 16, ���� 1, �� 36
Ʈ���Ű� �߻��Ͽ� Ʈ������� ����Ǿ����ϴ�. �ϰ� ó���� �ߴܵǾ����ϴ�.
*/


-- [�ҽ� 8-51] ������ ���� �õ�

DELETE dbo.Employee	
	WHERE EmpID IN ('S0004', 'S0009', 'S0014')
GO


-- [�ҽ� 8-52] ���� Ȯ��

SELECT * FROM dbo.Employee
	WHERE EmpID = 'S0009'
GO


-- [�ҽ� 8-53] ������ ����

INSERT INTO dbo.Employee VALUES('S0004', N'����', 'samsam', 'F', '2012-08-01', NULL, 'MKT', '010-3212-3212', 'samsoon@dbnuri.com',	7000)
INSERT INTO dbo.Employee VALUES('S0009', N'�ֻ��', 'samoya', 'F', '2013-10-01', NULL, 'SYS', '010-8899-9988', 'samo@dbnuri.com', 5800)
INSERT INTO dbo.Employee VALUES('S0014', N'���ְ�', 'first', 'M', '2014-04-01', NULL, 'MKT', '010-2345-9886', 'one@dbnuri.com', 5000)
GO


-- [�ҽ� 8-54] Ʈ���� ����

ALTER TRIGGER dbo.trg_Employee_S0009
	ON dbo.Employee
	AFTER DELETE
AS
	IF EXISTS (SELECT * FROM Deleted WHERE EmpID = 'S0009')
	BEGIN
		RAISERROR('�ֻ�� ������ ���Ե� ���� �۾��� ����� �� �����ϴ�', 16, 1)
		ROLLBACK TRANSACTION
	END
GO


-- [�ҽ� 8-55] ������ ���� �õ�

DELETE dbo.Employee	
	WHERE EmpID IN ('S0004', 'S0009', 'S0014')
GO
/*
�޽��� 50000, ���� 16, ���� 1, ���ν��� trg_Employee_S0009, �� 7 [��ġ ���� �� 84]
�ֻ�� ������ ���Ե� ���� �۾��� ���� �� �� �����ϴ�
�޽��� 3609, ���� 16, ���� 1, �� 85
Ʈ���Ű� �߻��Ͽ� Ʈ������� ����Ǿ����ϴ�. �ϰ� ó���� �ߴܵǾ����ϴ�.
*/


-- [�ҽ� 8-56] Ʈ���� ����

DROP TRIGGER dbo.trg_Employee_S0009
GO


-- [�ҽ� 8-57] ���� �̷� ���̺� �����

IF OBJECT_ID('dbo.EmployeeHistory', 'U') IS NOT NULL
	DROP TABLE dbo.EmployeeHistory
GO

CREATE TABLE dbo.EmployeeHistory (
	Seq int IDENTITY PRIMARY KEY,
	TranType char(1),
	TranDate datetime,
	EmpID char(5),
	EmpName nvarchar(4),
	EngName varchar(20),
	Gender char(1),
	HireDate date,
	RetireDate date,
	DeptID char(3),
	Phone char(13),
	EMail varchar(50),
	Salary int
)
GO


-- [�ҽ� 8-58] INSERT Ʈ����

CREATE TRIGGER dbo.trg_Employee_Insert
	ON dbo.Employee
	AFTER INSERT
AS
	SET NOCOUNT ON
	INSERT INTO dbo.EmployeeHistory
		SELECT 'I', GETDATE(), * FROM Inserted
GO


-- [�ҽ� 8-59] DELETE Ʈ����

CREATE TRIGGER dbo.trg_Employee_Delete
	ON dbo.Employee
	AFTER DELETE
AS
	SET NOCOUNT ON
	INSERT INTO dbo.EmployeeHistory
		SELECT 'D', GETDATE(), * FROM Deleted
GO


-- [�ҽ� 8-60] UPDATE Ʈ����

CREATE TRIGGER dbo.trg_Employee_Update
	ON dbo.Employee
	AFTER UPDATE
AS
	SET NOCOUNT ON
	INSERT INTO dbo.EmployeeHistory
		SELECT 'B', GETDATE(), * FROM Deleted
	INSERT INTO dbo.EmployeeHistory
		SELECT 'A', GETDATE(), * FROM Inserted
GO


-- [�ҽ� 8-61] ������ ���� ó��

-- Insert�� ����
INSERT INTO dbo.Employee 
	VALUES('S0021', N'��ó��', 'nana', 'M', '2016-05-01', NULL, 'MKT', '010-7711-3311', 'nana@dbnuri.com', 4000)
GO

-- Update�� ����
UPDATE dbo.Employee
	SET EmpName = N'��ó��'
	WHERE EmpID = 'S0021'
GO
 
-- Delete�� ����
DELETE dbo.Employee
	WHERE EmpID = 'S0021'
GO


-- [�ҽ� 8-62] ���� ��� Ȯ��

SELECT * FROM dbo.EmployeeHistory
GO


-- [�ҽ� 8-63] Ʈ���� ����

DROP TRIGGER dbo.trg_Employee_Insert
DROP TRIGGER dbo.trg_Employee_Update
DROP TRIGGER dbo.trg_Employee_Delete
GO


-- [�ҽ� 8-64] ������ ������

INSERT INTO dbo.Employee 
	VALUES('S0021', N'��ó��', 'nana', 'M', '2016-05-01', NULL, 'NKT', '010-7711-3311', 'nana@dbnuri.com', 4000)
GO
/*
�޽��� 547, ���� 16, ���� 0, �� 206
INSERT ���� FOREIGN KEY ���� ���� "FK__Employee__DeptID__2A4B4B5E"��(��) �浹�߽��ϴ�. �����ͺ��̽� "HRDB2", ���̺� "dbo.Department", column 'DeptID'���� �浹�� �߻��߽��ϴ�.
���� ����Ǿ����ϴ�.
*/


-- [�ҽ� 8-65] INSTEAD OF Ʈ���� �����

CREATE TRIGGER dbo.trg_Employee_Instead
	ON dbo.Employee
	INSTEAD OF INSERT
AS
	SET NOCOUNT ON
	INSERT INTO dbo.Employee
		SELECT EmpID, EmpName, EngName, Gender, HireDate, RetireDate,
			   CASE DeptID WHEN 'NKT' THEN 'MKT' ELSE DeptID END, Phone, EMail, Salary
			FROM Inserted
GO


-- [�ҽ� 8-66] Ʈ���� ���� Ȯ��

INSERT INTO dbo.Employee 
	VALUES('S0021', N'��ó��', 'nana', 'M', '2016-05-01', NULL, 'NKT', '010-7711-3311', 'nana@dbnuri.com', 4000)
GO

SELECT * FROM dbo.Employee WHERE EmpID = 'S0021'
GO


-- [�ҽ� 8-67] Ʈ���� ����

DROP TRIGGER dbo.trg_Employee_Instead
GO



--*
--* 8.4.3. DDL Ʈ���� �����
--*


-- [�ҽ� 8-68] �����ͺ��̽� ������ DDL Ʈ���� �����

USE HRDB2
GO

CREATE TRIGGER trg_Table01
	ON DATABASE 
	FOR DROP_TABLE, ALTER_TABLE 
AS 
	PRINT '���̺��� ���� �ϰų� ������ �� �����ϴ�!!!' 
	ROLLBACK TRANSACTION
GO


-- [�ҽ� 8-69] DDL Ʈ���ſ� ���� DROP TABLE �� ���� �ѹ�

DROP TABLE dbo.Vacation
GO
/*
���̺��� ���� �ϰų� ������ �� �����ϴ�!!!
�޽��� 3609, ���� 16, ���� 2, �� 272
Ʈ���Ű� �߻��Ͽ� Ʈ������� ����Ǿ����ϴ�. �ϰ� ó���� �ߴܵǾ����ϴ�.
*/


-- [�ҽ� 8-70] FOREIGN KEY ������ �켱������ üũ��

DROP TABLE dbo.Employee
GO
/*
�޽��� 3726, ���� 16, ���� 1, �� 283
��ü 'dbo.Employee'��(��) FOREIGN KEY ���� ���ǿ��� �����ϹǷ� ������ �� �����ϴ�.
*/


-- [�ҽ� 8-71] DDL Ʈ���ſ� ���� ALTER TABLE �� ���� �ѹ�

ALTER TABLE dbo.Employee
	ADD Facebook varchar(20) NULL
GO
/*
���̺��� ���� �ϰų� ������ �� �����ϴ�!!!
�޽��� 3609, ���� 16, ���� 2, �� 293
Ʈ���Ű� �߻��Ͽ� Ʈ������� ����Ǿ����ϴ�. �ϰ� ó���� �ߴܵǾ����ϴ�.
*/


-- [�ҽ� 8-72] ���� ������ Ʈ���� �����

CREATE TRIGGER trg_Login01
	ON ALL SERVER -- ���� ������ Ʈ�������� ����
	FOR CREATE_LOGIN 
AS 
	SET NOCOUNT ON
	SELECT EVENTDATA()
	PRINT '�������� ������� �α��� ������ ���� �� �����ϴ�!!!' 
	ROLLBACK TRANSACTION
GO


-- [�ҽ� 8-73] DDL Ʈ���ſ� ���� CREATE LOGIN �� ���� �ѹ�

CREATE LOGIN James
	WITH PASSWORD = 'Pa$$w0rd'
GO
/*
�������� ������� �α��� ������ ���� �� �����ϴ�!!!
�޽��� 3609, ���� 16, ���� 2, �� 321
Ʈ���Ű� �߻��Ͽ� Ʈ������� ����Ǿ����ϴ�. �ϰ� ó���� �ߴܵǾ����ϴ�.
*/


-- [�ҽ� 8-74] EVENTDATA �Լ��� XML ���·� �����ִ� ��

/*
<EVENT_INSTANCE>
  <EventType>CREATE_LOGIN</EventType>
  <PostTime>2016-11-04T09:52:52.877</PostTime>
  <SPID>53</SPID>
  <ServerName>JUHEE</ServerName>
  <LoginName>JUHEE\Administrator</LoginName>
  <ObjectName>James</ObjectName>
  <ObjectType>LOGIN</ObjectType>
  <DefaultLanguage>�ѱ���</DefaultLanguage>
  <DefaultDatabase>master</DefaultDatabase>
  <LoginType>SQL Login</LoginType>
  <SID>THJg9Bqb20CXc3XIOeGDrw==</SID>
  <TSQLCommand>
    <SetOptions ANSI_NULLS="ON" ANSI_NULL_DEFAULT="ON" ANSI_PADDING="ON" QUOTED_IDENTIFIER="ON" ENCRYPTED="FALSE" />
    <CommandText>CREATE LOGIN James
	WITH PASSWORD = '******'
</CommandText>
  </TSQLCommand>
</EVENT_INSTANCE>
*/


-- [�ҽ� 8-75] Ʈ���� ��Ȱ��ȭ �� Ȱ��ȭ

DISABLE TRIGGER trg_Login01
	ON ALL SERVER 
GO

CREATE LOGIN James
	WITH PASSWORD = 'Pa$$w0rd'
GO

ENABLE TRIGGER trg_Login01
	ON ALL SERVER 
GO


-- [�ҽ� 8-76] Ʈ���� ����

USE HRDB2
GO

DROP TRIGGER trg_Table01
	ON DATABASE 
GO

DROP TRIGGER trg_Login01
	ON ALL SERVER 
GO

DROP LOGIN James
GO