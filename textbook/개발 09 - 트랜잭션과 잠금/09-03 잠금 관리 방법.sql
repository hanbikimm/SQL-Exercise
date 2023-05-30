--*
--* 9.3. ��� ���� ���
--*



USE HRDB2
GO



--*
--* 9.3.1. ��� Ÿ�� �ƿ� ����
--*


-- [�ҽ� 9-7] 1�а� ���ӵǴ� ���� �۾� ����

-- [����1] ó�� ����
BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET EmpName = N'ȫ����'
		WHERE EmpID = 'S0001'
	WAITFOR DELAY '00:01:00' -- 1�а� ó�� ����
COMMIT TRANSACTION
GO


-- [�ҽ� 9-8] SET LOCK_TIMEOUT ���� ����� ��� Ÿ�Ӿƿ� ����

-- [����2] ó�� ����
SET LOCK_TIMEOUT 5000 -- 5��
GO

SELECT * 
	FROM dbo.Employee
GO
/*
�޽��� 1222, ���� 16, ���� 51, �� 2
��� ��û ���� �ð��� �ʰ��Ǿ����ϴ�.
*/
 
SET LOCK_TIMEOUT -1  -- �⺻ ��
GO



--*
--* 9.3.2. ���� ����(Deadlocks)
--*


-- [�ҽ� 9-9] ȫ�浿 ���� ���� ��װ� ������ ���� ���� ã�� Ʈ�����

-- [����1] 
BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET EmpName = N'ȫ����'
		WHERE EmpID = 'S0001'
	WAITFOR DELAY '00:00:30' -- 30�ʰ� ó�� ����
	SELECT EmpName, EMail
		FROM dbo.Employee
		WHERE EmpID = 'S0002'
COMMIT TRANSACTION
GO


-- [�ҽ� 9-10] ������ ���� ���� ��װ� ȫ�浿 ���� ���� ã�� Ʈ�����

-- [����2] 
BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET EmpName = N'���ָ�'
		WHERE EmpID = 'S0002'
	WAITFOR DELAY '00:00:30' -- 30�ʰ� ó�� ����
	SELECT EmpName, EMail
		FROM dbo.Employee
		WHERE EmpID = 'S0001'
COMMIT TRANSACTION
GO
/*
�޽��� 1205, ���� 13, ���� 51, �� 6
Ʈ�����(���μ��� ID 56)�� ��� ���ҽ����� �ٸ� ���μ������� ���� ���°� �߻��Ͽ� ������ �����Ǿ����ϴ�. Ʈ������� �ٽ� �����Ͻʽÿ�.
*/


-- [�ҽ� 9-11] Ʈ����� �߿䵵�� ���� ���� ����

SET DEADLOCK_PRIORITY 10
GO


-- [�ҽ� 9-12] Ʈ����� �߿䵵�� HIGH�� ����

SET DEADLOCK_PRIORITY HIGH
GO

 

--*
--* 9.3.3. ��ݰ� ���õ� ���̺� ��Ʈ
--*


-- [�ҽ� 9-13] 30�ʰ� ���ӵǴ� ���� �۾� ����

-- [����1]
BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET EmpName = N'ȫ�淡'
		WHERE EmpID = 'S0001'
	WAITFOR DELAY '00:00:30' -- 30�ʰ� ó�� ����
COMMIT TRANSACTION
GO


-- [�ҽ� 9-14] NOLOCK ��Ʈ ���

-- [����2]
SELECT EmpID, EmpName, Gender, HireDate, Phone, EMail 
	FROM dbo.Employee WITH (NOLOCK)
	WHERE DeptID = 'SYS'
GO


-- [�ҽ� 9-15] 30�ʰ� ���ӵǴ� ���� �۾� ����

-- [����1]
BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET EmpName = N'ȫ���'
		WHERE EmpID = 'S0001'
	WAITFOR DELAY '00:00:30' -- 30�ʰ� ó�� ����
COMMIT TRANSACTION
GO


-- [�ҽ� 9-16] READPAST ��Ʈ ���

-- [����2]
SELECT EmpID, EmpName, Gender, HireDate, Phone, EMail 
	FROM dbo.Employee WITH (READPAST)
	WHERE DeptID = 'SYS'
GO