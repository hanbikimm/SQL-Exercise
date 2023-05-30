--*
--* 9.4. Ʈ����� �ݸ� ����(Transaction Isolation Levels)
--*



USE HRDB2
GO


--*
--* 9.4.1. READ UNCOMMITTED �ݸ� ����
--*


-- [����1]
BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET Salary = 9000
		WHERE EmpID = 'S0001'
	WAITFOR DELAY '00:01:00'
ROLLBACK TRANSACTION
GO


-- [����2]
SET TRANSACTION ISOLATION LEVEL 
    READ UNCOMMITTED
GO

SELECT *
   FROM dbo.Employee
   WHERE EmpID = 'S0001'
GO



--*
--* 9.4.2. READ COMMITTED (�⺻��) �ݸ� ����
--*


-- [����1]
BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET Salary = 8500
		WHERE EmpID = 'S0002'
	WAITFOR DELAY '00:01:00'
ROLLBACK TRANSACTION
GO

-- [����2]
SET TRANSACTION ISOLATION LEVEL 
    READ COMMITTED
GO

SELECT *
   FROM dbo.Employee
   WHERE EmpID = 'S0002'
GO



--*
--* 9.4.3. REPEATABLE READ �ݸ� ����
--*


-- [����1]
SET TRANSACTION ISOLATION LEVEL 
   REPEATABLE READ
GO

BEGIN TRANSACTION
-- �ݺ� �ؼ� �б�
   SELECT *
      FROM dbo.Employee
      WHERE DeptID = 'SYS'
	WAITFOR DELAY '00:01:00'
COMMIT TRANSACTION
GO

-- [����2]
DELETE dbo.Employee
   WHERE EmpID = 'S0009'  -- X
GO

INSERT INTO dbo.Employee 
	VALUES('S0021', N'��ó��', 'nana', 'M', '2016-05-01', NULL, 'SYS', '010-7711-3311', 'nana@dbnuri.com', 4000)
GO



--*
--* 9.4.4. SERIALIZABLE �ݸ� ����
--*


-- [����1]
SET TRANSACTION ISOLATION LEVEL 
   SERIALIZABLE
GO

BEGIN TRANSACTION
-- �ݺ� �ؼ� �б�
   SELECT *
      FROM dbo.Employee
      WHERE DeptID = 'SYS'
	WAITFOR DELAY '00:01:00'
COMMIT TRANSACTION
GO


-- [����2]
DELETE dbo.Employee
   WHERE EmpID = 'S0009'   
GO

INSERT INTO dbo.Employee 
	VALUES('S0022', N'������', 'mana', 'F', '2016-05-01', NULL, 'SYS', '010-1819-2829', 'ohmana@dbnuri.com', 3000)
GO



--*
--* 9.4.5. READ COMMITTED SNAPSHOT �ݸ� ����
--*


USE Master
GO

ALTER DATABASE HRDB2
   SET READ_COMMITTED_SNAPSHOT ON
GO

USE HRDB2
GO

-- [����1]
BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET Salary = 7000
		WHERE EmpID = 'S0003'
	WAITFOR DELAY '00:01:00'
ROLLBACK TRANSACTION
GO


-- [����2]
SELECT *
   FROM dbo.Employee
   WHERE EmpID = 'S0003'
GO


-- �ɼ� �� Ȱ��ȭ

USE Master
GO

ALTER DATABASE HRDB2
   SET READ_COMMITTED_SNAPSHOT OFF
GO



--*
--* 9.4.6. SNAPSHOT �ݸ� ����
--*


USE Master
GO

ALTER DATABASE HRDB2
   SET ALLOW_SNAPSHOT_ISOLATION ON
GO

USE HRDB2
GO

-- [����1]
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
GO

BEGIN TRANSACTION
-- �ݺ� �ؼ� �б�
    SELECT *
        FROM dbo.Employee
        WHERE DeptID = 'SYS'
    WAITFOR DELAY '00:01:00'
	    UPDATE dbo.Employee
			SET Salary = 6000
			WHERE EmpID = 'S0009'
COMMIT TRANSACTION
GO
/*
�޽��� 3960, ���� 16, ���� 2, �� 1
������Ʈ �浹�� ���� ������ �ݸ� Ʈ������� �ߴܵǾ����ϴ�. ������ �ݸ��� ����Ͽ� �����ͺ��̽� 'HRDB'�� ���̺� 'dbo.Employee'�� ���� �Ǵ� ���������� �׼����Ͽ� �ٸ� Ʈ����ǿ� ���� �����ǰų� ������ ���� ������Ʈ, ���� �Ǵ� ������ �� �����ϴ�. Ʈ������� �ٽ� �õ��ϰų� UPDATE/DELETE ���� ���� �ݸ� ������ �����Ͻʽÿ�.
*/


-- [����2]
DELETE dbo.Employee
   WHERE EmpID = 'S0009' 
GO


-- �ɼ� ��Ȱ��ȭ

USE Master
GO

ALTER DATABASE HRDB2
   SET ALLOW_SNAPSHOT_ISOLATION OFF
GO