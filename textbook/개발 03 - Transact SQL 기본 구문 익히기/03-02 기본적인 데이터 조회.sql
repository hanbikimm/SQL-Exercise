--*
--* 3.2. �⺻���� ������ ��ȸ
--*


USE HRDB2
GO


--*
--* 3.2.1. SELECT �� ����
--*


-- [�ҽ� 3-1] ��� ������ ��ȸ

SELECT * FROM dbo.Employee
GO


-- [�ҽ� 3-2] ��� ������ ��ȸ

SELECT * FROM dbo.Department
GO

SELECT * FROM dbo.Vacation
GO

SELECT * FROM dbo.Unit
GO


-- [�ҽ� 3-3] �Ϻ� ���� ��ȸ

SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
GO


-- [�ҽ� 3-4] �Ϻ� �ุ ��ȸ

SELECT *
	FROM dbo.Employee
	WHERE EmpID = 'S0005' 
GO


-- [�ҽ� 3-5] �Ϻ� ���� �Ϻ� ���� ��ȸ

SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE EmpID = 'S0005'
GO



--*
--* 3.2.2. �پ��� ������
--*


-- [�ҽ� 3-6] �� ������ ���

-- ��� ��ȣ�� 'S0005'�� ����
SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE EmpID = 'S0005' 
GO

-- �޿��� 8,000 �̻��� ����
SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE Salary >= 8000 
GO

-- 2013�� ������ �Ի��� ����
SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE HireDate < '2013-01-01' 
GO


-- [�ҽ� 3-7] ȫ�浿 2014�� �ް� ��Ȳ ��ȸ

SELECT BeginDate, EndDate, Reason, Duration
	FROM dbo.Vacation
	WHERE (EmpID = 'S0001') 
		AND (BeginDate >= '2014-01-01' AND BeginDate <= '2014-12-31')
GO
 

-- [�ҽ� 3-8] ���ڿ� ���� ��

-- �̸��� ȫ�浿�� ����
SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE EmpName = N'ȫ�浿' 
GO

-- �̸��� '��'���� �����ϴ� ����
SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE EmpName LIKE N'��%' 
GO

-- �̸��� '��'�� �� ����
SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE EmpName LIKE N'%��%' 
GO


-- [�ҽ� 3-9] 2015�⿡ �Ӹ��� ���� �ް��� �� ��� ��ȸ

SELECT EmpID, BeginDate, EndDate, Reason, Duration
	FROM dbo.Vacation
	WHERE (BeginDate BETWEEN '2015-01-01' AND '2015-12-31')
	      AND (Reason LIKE N'%����%' OR Reason LIKE N'%�Ӹ�%')
GO


-- [�ҽ� 3-10] ���� ���� ���� ��

SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE EMail LIKE '____@%'
GO


-- [�ҽ� 3-11] ���� ���� ���� ��

SELECT EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE Phone LIKE '___-[1-3]%'
GO


-- [�ҽ� 3-12] ���ڿ��� ���Ե� _ ��ȸ

-- ������ ����
UPDATE dbo.Employee
	SET EngName = 'sam_sam'
	WHERE EmpID = 'S0004'
GO

UPDATE dbo.Employee
	SET EngName = 'five_gamja'
	WHERE EmpID = 'S0011'
GO

-- ��ȸ
SELECT EmpID, EmpName, EngName, Phone, EMail
	FROM dbo.Employee
	WHERE EngName LIKE '%[_]%'
GO


-- [�ҽ� 3-13] �� ������ ���

-- 2015����� �Ի��� ���� ����
SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail
	FROM dbo.Employee
	WHERE HireDate >= '2015-01-01' AND Gender = 'M'
GO

-- �ѹ����̳� �λ��� ����
SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail
	FROM dbo.Employee
	WHERE DeptID = 'GEN' OR DeptID = 'HRD'
GO

-- �����ý����� �ƴ� ���� ����
SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail
	FROM dbo.Employee
	WHERE Gender = 'F' AND NOT DeptID = 'SYS'
GO



--*
--* 3.2.3. ���� ���ǰ� ����Ʈ ����
--*


-- [�ҽ� 3-14] BETWEEN ������

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31'
GO

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate >= '2014-01-01' AND HireDate <= '2014-12-31'
GO


-- [�ҽ� 3-15] IN ������

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE DeptID IN ('ACC', 'GEN', 'HRD')
GO

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE DeptID = 'ACC' OR DeptID = 'GEN' OR DeptID = 'HRD'
GO



--*
--* 3.2.4. NULL�� ��
--*


-- [�ҽ� 3-16] IS NULL ���

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
   FROM dbo.Employee
   WHERE Gender = 'F' AND RetireDate IS NULL
GO


-- [�ҽ� 3-17] IS NOT NULL ���

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
   FROM dbo.Employee
   WHERE Gender = 'F' AND RetireDate IS NULL AND Salary IS NOT NULL
GO


-- [�ҽ� 3-18] ��ȣ�� ���� ����

SELECT EmpID, EmpName, HireDate, DeptID, Phone, EMail, Salary
   FROM dbo.Employee
   WHERE (Gender = 'F') AND (RetireDate IS NULL) AND (Salary IS NOT NULL)
GO


-- [����] ��ȣ ���

SELECT 10 + 5 * 2 / 4 - 5 * 2 + 10 * 2 / 5  
SELECT 10 + ((5 * 2) / 4) - (5 * 2) + ((10 * 2) / 5)  
GO



--*
--* 3.2.5. �� ��Ī�� ���� ���� ���
--*


-- [�ҽ� 3-19] �� ��Ī ����

SELECT EmpID AS [���], EmpName AS [�̸�], Gender AS [����], HireDate AS [�Ի���], 
       RetireDate AS [�����], Phone AS [��ȭ��ȣ]
	FROM dbo.Employee
	WHERE RetireDate IS NOT NULL
GO


-- [�ҽ� 3-20] �ǵ����� ���� �� ��Ī

SELECT EmpID, EmpName, HireDate RetireDate, EMail, Phone
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO


-- [�ҽ� 3-21] ���� ������ ����

SELECT EmpName + '(' + EmpID + ')' AS [EmpName], Gender, HireDate, Phone, EMail 
	FROM dbo.Employee
	WHERE DeptID = 'MKT'
GO


-- [�ҽ� 3-22] ������ ���� ����

SELECT EmpName + '(' + Salary + ')' AS [EmpName], Gender, HireDate, Phone, EMail 
	FROM dbo.Employee
	WHERE DeptID = 'MKT'
GO
/*
�޽��� 245, ���� 16, ���� 1, �� 191
varchar �� ')'��(��) ������ ���� int(��)�� ��ȯ���� ���߽��ϴ�.
*/


-- [�ҽ� 3-23] ������ ���� ���� �ذ�

SELECT EmpName + '(' + CONVERT(varchar(10), Salary) + ')' AS [EmpName], Gender, HireDate, Phone, EMail 
	FROM dbo.Employee
	WHERE DeptID = 'MKT'
GO


-- [�ҽ� 3-24] ��¥�� ���ڷ� ��ȯ

SELECT EmpID, EmpName, CONVERT(char(10), HireDate, 102) AS 'HireDate', Gender,  
       Phone, EMail
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO


-- [�ҽ� 3-25] õ ���� �޸� �� ǥ��
SELECT EmpID, EmpName, Gender, Phone, EMail, FORMAT(Salary, '#,###,##0.') AS [Salary] 
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO


-- [����] �ڵ� �� ��ȯ

SELECT 11 + '9'
SELECT 11 + 'A'
GO



--*
--* 3.2.6. ��ȸ ��� ����
--*


-- [�ҽ� 3-26] ���� �̸����� �������� ����

SELECT EmpName, EmpID, Gender, HireDate, Phone, EMail
   FROM dbo.Employee
   WHERE DeptID = 'SYS'
   ORDER BY EmpName ASC
GO


-- [�ҽ� 3-27] ���� �̸����� �������� ����

SELECT EmpName, EmpID, Gender, HireDate, Phone, EMail
   FROM dbo.Employee
   WHERE DeptID = 'SYS'
   ORDER BY EmpName DESC
GO


-- [�ҽ� 3-28] �μ� �ڵ�� ��������, ��� ��ȣ�� �������� ����

SELECT DeptID, EmpID, EmpName, HireDate, Phone, EMail
   FROM dbo.Employee
   WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31'
   ORDER BY DeptID ASC, EmpID DESC
GO


-- [�ҽ� 3-29] �ߺ� ����

SELECT DISTINCT DeptID 
	FROM dbo.Employee
GO


-- [�ҽ� 3-30] 5�� �ุ ��ȸ

SET ROWCOUNT 0
GO

SELECT DeptID, EmpID, EmpName, HireDate, Phone, EMail
   FROM dbo.Employee
   ORDER BY DeptID ASC, EmpID DESC
GO