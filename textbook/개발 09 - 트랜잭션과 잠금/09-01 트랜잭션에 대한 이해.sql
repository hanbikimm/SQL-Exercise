--*
--* 9.1.  Ʈ����ǿ� ���� ����
--*



USE HRDB2
GO


--*
--* 9.1.3. �ڵ� Ŀ�� Ʈ�����(Auto Commit Transactions)
--*


-- [�ҽ� 9-1] �ڵ� Ŀ�� Ʈ�����


DELETE dbo.Employee
	WHERE EmpID = 'S0020'
ROLLBACK TRANSACTION
GO
/*
�޽��� 3903, ���� 16, ���� 1, �� 3
ROLLBACK TRANSACTION ��û�� �ش��ϴ� BEGIN TRANSACTION�� �����ϴ�.
*/



--*
--* 9.1.4. ����� Ʈ�����(Explicit Transactions)
--*


-- [�ҽ� 9-2] ����� Ʈ��������� �ϰ��� ó�� ����

BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET Salary = Salary - 1000
		WHERE EmpID = 'S0001'
	UPDATE dbo.Employee
		SET Salary = Salary + 1000
		WHERE EmpID = 'S0003'
COMMIT TRANSACTION


-- [�ҽ� 9-3] ROLLBACK TRANSACTION ������ Ʈ����� ���

BEGIN TRANSACTION
	DELETE dbo.Employee
		WHERE EmpID = 'S0018'
ROLLBACK TRANSACTION
GO

-- ���� ��ҵ� �̸���(S0018) ���� ���� ��ȸ ����
SELECT * 
	FROM dbo.Employee
	WHERE EmpID = 'S0018'
GO


-- [�ҽ� 9-4] SET XACT_ABORT ON ������� ����

BEGIN TRANSACTION
	INSERT INTO dbo.Vacation VALUES('S0001', '2016-10-05', '2016-10-06', N'�������')
	INSERT INTO dbo.Vacation VALUES('C0002', '2016-10-05', '2016-10-06', N'�������')
COMMIT TRANSACTION
/*
(1�� ���� ������ ����)
�޽��� 547, ���� 16, ���� 0, �� 54
INSERT ���� FOREIGN KEY ���� ���� "FK__Vacation__EmpID__2D27B809"��(��) �浹�߽��ϴ�. 
�����ͺ��̽� "HRDB2", ���̺� "dbo.Employee", column 'EmpID'���� �浹�� �߻��߽��ϴ�.
���� ����Ǿ����ϴ�
*/

SELECT * 
	FROM dbo.Vacation
	WHERE BeginDate = '2016-10-05'
GO


-- [�ҽ� 9-5] SET XACT_ABORT ON �����

SET XACT_ABORT ON
BEGIN TRANSACTION
	INSERT INTO dbo.Vacation VALUES('S0001', '2016-11-05', '2016-11-06', N'�������')
	INSERT INTO dbo.Vacation VALUES('C0002', '2016-11-05', '2016-11-06', N'�������')
COMMIT TRANSACTION
SET XACT_ABORT OFF
/*
(1�� ���� ������ ����)
�޽��� 547, ���� 16, ���� 0, �� 74
INSERT ���� FOREIGN KEY ���� ���� "FK__Vacation__EmpID__2D27B809"��(��) �浹�߽��ϴ�. 
�����ͺ��̽� "HRDB2", ���̺� "dbo.Employee", column 'EmpID'���� �浹�� �߻��߽��ϴ�.
*/

SELECT * 
	FROM dbo.Vacation
	WHERE BeginDate = '2016-11-05'
GO



--*
--* 9.1.5. ������ Ʈ�����(Implicit Transactions)
--*


-- [�ҽ� 9-6] ������ Ʈ����� ��� ��

-- ������ Ʈ����� Ȱ��ȭ
SET IMPLICIT_TRANSACTIONS ON
GO

-- �̸���(S0018) ���� ���� ����
DELETE dbo.Employee
	WHERE EmpID = 'S0018'
GO

-- ���� ��� ����
ROLLBACK TRANSACTION
GO

-- ������ Ʈ����� ��Ȱ��ȭ
SET IMPLICIT_TRANSACTIONS OFF
GO

-- ���� ��ҵ� �̸��� ���� ���� Ȯ��
SELECT * 
	FROM dbo.Employee
	WHERE EmpID = 'S0018'
GO

