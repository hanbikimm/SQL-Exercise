--*
--* 8.5. Ŀ��(Cursors)
--*



--*
--* 8.5.1. Ŀ���� ���� ����
--*


-- [�ҽ� 8-77] Ŀ���� ����ϴ� �������� �⺻ ����

USE HRDB2
GO

-- �ʿ��� ���� ����
DECLARE @EmpName nvarchar(4)
DECLARE @EmpID char(5)
DECLARE @EMail varchar(50)

-- Ŀ�� ����
DECLARE Emp_Cursor CURSOR FOR
	SELECT EmpName, EmpID, EMail
		FROM dbo.Employee
		WHERE DeptID = 'SYS'
		ORDER BY EmpName

-- Ŀ�� ����
OPEN Emp_Cursor

-- Ŀ�� ���
-- Ŀ������ �о�� ������ ����
FETCH NEXT FROM Emp_Cursor
	INTO @EmpName, @EmpID, @EMail
-- ������ ���� �ݺ��켭 �б�
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @EmpName AS [EmpName], @EmpID AS [EmpID], @EMail AS [EMail]
	FETCH NEXT FROM Emp_Cursor
		INTO @EmpName, @EmpID, @EMail
END

-- Ŀ�� �ݱ� �� ����
CLOSE Emp_Cursor
DEALLOCATE Emp_Cursor
GO



--*
--* 8.5.2. Ŀ�� ����ϱ�
--*


-- [�ҽ� 8-78] Ŀ���� ������ ������ ����

SELECT EmpName, EMail
	FROM dbo.Employee
	WHERE Gender = 'F' AND RetireDate IS NULL
	ORDER BY EmpName
GO


-- [�ҽ� 8-79] Ŀ�� ���� ... DEALLOCATE��


DECLARE Cur_Emp01 CURSOR STATIC FOR
	SELECT EmpName, EMail
		FROM dbo.Employee
		WHERE Gender = 'F' AND RetireDate IS NULL
		ORDER BY EmpName

OPEN Cur_Emp01

FETCH NEXT FROM Cur_Emp01
FETCH PRIOR FROM Cur_Emp01
FETCH ABSOLUTE 2 FROM Cur_Emp01
FETCH RELATIVE 2 FROM Cur_Emp01

CLOSE Cur_Emp01
DEALLOCATE Cur_Emp01
GO