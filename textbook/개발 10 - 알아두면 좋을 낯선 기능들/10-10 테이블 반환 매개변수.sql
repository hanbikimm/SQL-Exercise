--*
--* 10.10. ���̺� ��ȯ �Ű�����(Table-Valued Parameters)
--*



--*
--* 10.10.1. ����� ���� ���̺� ���� �����
--*


-- [�ҽ� 10-61] ����� ���� ���̺� ���� �����

USE HRDB2
GO

CREATE TYPE Tbl_EmpList AS TABLE ( 
	EmpID char(5),
	EmpName nvarchar(4)
)
GO


-- [�ҽ� 10-62] ���̺� ���� ��� ��

-- ���� ����
DECLARE @EmpList AS Tbl_EmpList

-- ������ �߰�
INSERT INTO @EmpList VALUES('S0001', N'ȫ�浿')
INSERT INTO @EmpList VALUES('S0002', N'������')

-- ������ ����
UPDATE @EmpList
	 SET EmpName = N'ȫ����'
	 WHERE EmpID = 'S0001'

-- Ȯ��
SELECT * FROM @EmpList
GO



--*
--* 10.10.2. ���̺� ��ȯ �Ű� ������ ����ϴ� ���� ���ν��� �����
--*


-- [�ҽ� 10-63] ���̺� ��ȯ �Ű� ������ ����ϴ� ���� ���ν��� �����

CREATE PROC dbo.usp_VacationList
	@TVP AS Tbl_EmpList READONLY
AS 
BEGIN
	SET NOCOUNT ON
	SELECT e.EmpID, e.EmpName, v.BeginDate, v.EndDate, v.Duration, v.Reason
		FROM @TVP AS e
		INNER JOIN dbo.Vacation AS v ON e.EmpID = v.EmpID
		ORDER BY v.BeginDate DESC
END
GO



--*
--* 10.10.3. ��� ��
--*


-- [�ҽ� 10-64] ����� ���� ���̺� ���� ��� ��

-- ���̺� ���� ���� ����
DECLARE @EmpList AS Tbl_EmpList

-- ���̺� ������ ������ �߰�(����� ����)
INSERT INTO @EmpList
    SELECT EmpID, EmpName
		FROM dbo.Employee
		WHERE RetireDate IS NOT NULL

-- ���� ���ν��� �Ű������� ����(����ڵ��� �ް� ���� ��ȸ)
EXEC dbo.usp_VacationList @EmpList
GO



--*
--* 10.10.4. �������
--*


-- [�ҽ� 10-65] ����� ���� ���̺� ���� ����� ���� ����

-- ����� ���� ���̺� ���� ���� �Ұ���
ALTER TYPE Tbl_EmpList AS TABLE ( 
	EmpID char(5)
)
GO
/*
�޽��� 102, ���� 15, ���� 1, �� 59
'TYPE' ��ó�� ������ �߸��Ǿ����ϴ�.
*/

-- ������� ����� ���� ���̺� ���� ���� �Ұ���
DROP TYPE Tbl_EmpList
GO
/*
�޽��� 3732, ���� 16, ���� 1, �� 51
'Tbl_EmpList' ������ ��ü 'usp_VacationList'���� �����ϰ� �����Ƿ� ������ �� �����ϴ�. 
�� ������ �����ϴ� �ٸ� ��ü�� ���� �� �ֽ��ϴ�.
*/

