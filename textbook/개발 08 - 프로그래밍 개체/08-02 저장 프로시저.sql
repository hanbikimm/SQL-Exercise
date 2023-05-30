--*
--* 8.2. ���� ���ν���(Stored Procedures)
--*



USE HRDB2
GO



--*
--* 8.2.2. ���� ���ν��� �����
--*


-- [�ҽ� 8-16] ���� ���ν��� ������ �����ϱ�

CREATE PROC dbo.usp_GetEmployee
	@DeptID char(3),
	@FromDate date,
	@ToDate date
AS
BEGIN
	SET NOCOUNT ON
	SELECT EmpID, EmpName, DeptID, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE DeptID = @DeptID AND HireDate BETWEEN @FromDate AND @ToDate
END
GO

-- ���� ���ν��� ȣ��
EXEC dbo.usp_GetEmployee  
		@DeptID = 'SYS', 
		@FromDate = '2013-01-01', 
		@ToDate = '2014-12-31'
GO


-- [�ҽ� 8-17] ���� ���ν��� ����

ALTER PROC dbo.usp_GetEmployee
	@DeptID char(3),
	@FromDate date,
	@ToDate date
AS
BEGIN
	SET NOCOUNT ON
	SELECT EmpID, EmpName, Gender, DeptID, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE DeptID = @DeptID AND HireDate BETWEEN @FromDate AND @ToDate
END
GO


-- [�ҽ� 8-18] ���� ���ν��� ����

/*
DROP PROCEDURE dbo.usp_GetEmployee
GO
*/



--*
--* 8.2.3. �Է� �Ű� ������ ��� �Ű� ����
--*


-- [�ҽ� 8-19] �Ű� ���� �⺻�� ����

ALTER PROC dbo.usp_GetEmployee
	@DeptID char(3) = NULL,
	@FromDate date = '1900-01-01',
	@ToDate date = '9999-12-31'
AS
BEGIN
	SET NOCOUNT ON;
	SELECT EmpID, EmpName, Gender, DeptID, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE DeptID = @DeptID AND HireDate BETWEEN @FromDate AND @ToDate
END
GO


-- [�ҽ� 8-20] �Ű� ���� �����ϰ� ���ν��� ����

EXEC dbo.usp_GetEmployee @DeptID = 'SYS' --> ��� �����ý��� ���� ����
GO

EXEC dbo.usp_GetEmployee 'SYS', DEFAULT, '2014-12-31' --> 2008����� �Ի��� �����ý��� ����
GO


-- [�ҽ� 8-21] �Ű� ���� ��ȿ�� �˻�

ALTER PROC dbo.usp_GetEmployee
	@DeptID char(3) = NULL,
	@FromDate date = '1900-01-01',
	@ToDate date = '9999-12-31'
AS
	SET NOCOUNT ON
	-- �μ� �ڵ尡 NULL ���̸� ���� �޽��� ǥ�� �� ����
	IF @DeptID IS NULL
		BEGIN
			RAISERROR('����: �μ��ڵ带 ���� �����ؾ� �մϴ�.', 16, 1)
			RETURN
		END
	-- �������� ��츸 ó��
	SELECT EmpID, EmpName, Gender, DeptID, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE DeptID = @DeptID AND HireDate BETWEEN @FromDate AND @ToDate
GO


-- [�ҽ� 8-22] ��� �Ű� ������ ���� ��

ALTER PROC dbo.usp_GetEmployee
	@DeptID char(3) = NULL,
	@FromDate date = '1900-01-01',
	@ToDate date = '9999-12-31',
	@RowNum int OUTPUT -- ��� �Ű�����
AS
	SET NOCOUNT ON
	-- �μ� �ڵ尡 NULL ���̸� ���� �޽��� ǥ�� �� ����
	IF @DeptID IS NULL
		BEGIN
			RAISERROR('����: �μ��ڵ带 ���� �����ؾ� �մϴ�.', 16, 1)
			RETURN -1  -- ó�� ���� �뺸
		END
	-- �������� ��츸 ó��
	SELECT EmpID, EmpName, Gender, DeptID, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE DeptID = @DeptID AND HireDate BETWEEN @FromDate AND @ToDate
	SET @RowNum = @@ROWCOUNT
	RETURN 0  -- ���� ó�� �Ϸ� �뺸
GO


-- [�ҽ� 8-23] ��� �Ű� ������ ���� �� �ޱ�

-- ���� ����
DECLARE @Return int  -- ���� ���� ���� ����
DECLARE @Rows int  -- ��� �Ű����� ���� ���� ����

-- ���� ���ν��� ����
EXEC @Return = dbo.usp_GetEmployee
	@DeptID = 'SYS', 
	@FromDate = '2014-01-01', 
	@ToDate = '2014-12-31',
	@RowNum = @Rows OUTPUT

-- ���� ���� ��� �Ű������� ���� �� Ȯ��
SELECT @Return AS 'Return', @Rows AS 'RowCount'
GO


-- [�ҽ� 8-24] ���� ���ν��� ���� ��� ���̺� ���

-- ����� ������ ���̺� �����
CREATE TABLE #Employee (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(4),
	Gender char(1),
	DeptID char(3),
	HireDate date,
	Phone char(13),
	EMail varchar(50)
)

-- ���� ����
DECLARE @Return int
DECLARE @Rows int

-- ���� ���ν��� ���� ��� ���̺� ���
INSERT INTO #Employee EXEC @Return = dbo.usp_GetEmployee
	@DeptID = 'SYS', 
	@FromDate = '2014-01-01', 
	@ToDate = '2014-12-31',
	@RowNum = @Rows OUTPUT

-- ��ϵ� ���̺� Ȯ��
SELECT EmpID, EmpName, Phone, EMail	
	FROM #Employee
GO



--*
--* 8.2.4. ���� �ڵ鸵
--*


-- [�ҽ� 8-25] ���� �ڵ鸵

CREATE PROC dbo.usp_InsertDepartment
	@DeptID char(3),
	@DeptName nvarchar(10),
	@UnitID char(1),
	@StartDate date
AS	
	BEGIN TRY
		INSERT INTO dbo.Department VALUES(@DeptID, @DeptName, @UnitID, @StartDate)
	END TRY
	BEGIN CATCH
		SELECT	
			ERROR_LINE() AS [ErrorLine], 
			ERROR_MESSAGE() AS [ErrorMessage],
			ERROR_NUMBER() AS [ErrorNumber],
			ERROR_PROCEDURE() AS [ErrorProcedure],
			ERROR_SEVERITY() AS [ErrorServerity],
			ERROR_STATE() AS [ErrorState]
	END CATCH
GO

EXEC dbo.usp_InsertDepartment 'SYS', N'�����ý���', 'A', '2016-01-01'
GO


-- [�ҽ� 8-26] �ް� ��Ȳ ��ȸ�ϴ� ���� ���ν��� �����

CREATE PROC dbo.usp_GetVacation
	@EmpID char(5),
	@FromDate date,
	@ToDate date
AS
	SET NOCOUNT ON
	SELECT v.EmpID, e.EmpName, e.Gender, e.DeptID, e.HireDate, 
		   v.BeginDate, v.EndDate, v.Reason
		FROM dbo.Vacation AS v
		INNER JOIN dbo.Employee AS e ON v.EmpID = e.EmpID
		WHERE v.EmpID = @EmpID AND v.BeginDate BETWEEN @FromDate AND @ToDate
GO

-- ȣ��
EXEC dbo.usp_GetVacation 
	@EmpID = 'S0001', 
	@FromDate = '2015-01-01', 
	@ToDate = '2015-12-31'
GO


-- [�ҽ� 8-27] �ް� ������ ����ϴ� ���� ���ν��� �����

CREATE PROC dbo.usp_InsertVacation
	@EmpID char(5),
	@BeginDate date,
	@EndDate date,
	@Reason nvarchar(50)
AS
	SET NOCOUNT ON
	INSERT INTO dbo.Vacation(EmpID, BeginDate, EndDate, Reason)
		VALUES(@EmpID, @BeginDate, @EndDate, @Reason)
GO

-- ȣ��
EXEC dbo.usp_InsertVacation
	@EmpID = 'S0001',
	@BeginDate = '2016-10-10',
	@EndDate = '2016-10-12',
	@Reason = N'���� ����'
GO

-- Ȯ��
EXEC dbo.usp_GetVacation
	@EmpID = 'S0001', 
	@FromDate = '2016-10-01',
	@ToDate = '2016-10-31'
GO



--*
--* 8.2.5. ���� ��ȹ ����� ��������
--*

 
-- [�ҽ� 8-28] ��� �ε��� ����

USE IndexBasic
GO

-- ��� �ε��� ����
EXEC dbo.usp_RemoveAllIndexes
GO


-- [�ҽ� 8-29] �ε��� �����

CREATE NONCLUSTERED INDEX NCL_OrderDate 
	ON dbo.SalesOrderHeader(OrderDate)
GO


-- [�ҽ� 8-30] 2�ϰ��� �ֹ� ��Ȳ ��ȸ

SET STATISTICS IO ON
GO
SELECT SalesOrderID, OrderDate, DueDate, ShipDate, TotalDue 
	FROM dbo.SalesOrderHeader
	WHERE OrderDate BETWEEN '2015-07-01' AND '2015-07-02'
GO
SET STATISTICS IO OFF
GO
/*
(2695�� ���� ������ ����)
���̺� 'SalesOrderHeader'. �˻� �� 1, ���� �б� �� 2704, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
���̺� 'Worktable'. �˻� �� 0, ���� �б� �� 0, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/


-- [�ҽ� 8-31] 1�Ⱓ�� �ֹ� ��Ȳ ��ȸ

SET STATISTICS IO ON
GO
SELECT SalesOrderID, OrderDate, DueDate, ShipDate, TotalDue 
	FROM dbo.SalesOrderHeader
	WHERE OrderDate BETWEEN '2015-01-01' AND '2015-12-31'
GO
SET STATISTICS IO OFF
GO
/*
(478046�� ���� ������ ����)
���̺� 'SalesOrderHeader'. �˻� �� 1, ���� �б� �� 24688, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/


-- [�ҽ� 8-32] ���� ���ν����� �����

CREATE PROC dbo.usp_GetOrderHeader
	@FromDate date,
	@ToDate date
AS
	SELECT SalesOrderID, OrderDate, DueDate, ShipDate, TotalDue 
		FROM dbo.SalesOrderHeader
		WHERE OrderDate BETWEEN @FromDate AND @ToDate
GO


-- [�ҽ� 8-33] 2�ϰ��� �ֹ� ��Ȳ ��ȸ

SET STATISTICS IO ON
GO
EXEC dbo.usp_GetOrderHeader '2015-07-01', '2015-07-02'
GO
SET STATISTICS IO OFF
GO
/*
(2695�� ���� ������ ����)
���̺� 'SalesOrderHeader'. �˻� �� 1, ���� �б� �� 2704, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
���̺� 'Worktable'. �˻� �� 0, ���� �б� �� 0, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/


-- [�ҽ� 8-34] 1�Ⱓ�� �ֹ� ��Ȳ ��ȸ

SET STATISTICS IO ON
GO
EXEC dbo.usp_GetOrderHeader '2015-01-01', '2015-12-31'
GO
SET STATISTICS IO OFF
GO
/*
(478046�� ���� ������ ����)
���̺� 'SalesOrderHeader'. �˻� �� 1, ���� �б� �� 479058, ������ �б� �� 0, �̸� �б� �� 4, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
���̺� 'Worktable'. �˻� �� 0, ���� �б� �� 0, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/


-- [�ҽ� 8-35] RECOMPILE �ɼ��� ����ؼ� 1�Ⱓ�� �ֹ� ��Ȳ ��ȸ

SET STATISTICS IO ON
GO
EXEC dbo.usp_GetOrderHeader '2015-01-01', '2015-12-31' WITH RECOMPILE
GO
SET STATISTICS IO OFF
GO
/*
(478046�� ���� ������ ����)
���̺� 'SalesOrderHeader'. �˻� �� 1, ���� �б� �� 24688, ������ �б� �� 0, �̸� �б� �� 0, LOB ���� �б� �� 0, LOB ������ �б� �� 0, LOB �̸� �б� �� 0.
*/


-- [�ҽ� 8-36] sp_recompile �ý��� ���� ���ν��� ���

EXEC sp_recompile 'dbo.usp_GetOrderHeader'
GO


-- [�ҽ� 8-37] RECOMPILE�� ������ ����

ALTER PROC dbo.usp_GetOrderHeader
	@FromDate date,
	@ToDate date
	WITH RECOMPILE
AS
	SELECT SalesOrderID, OrderDate, DueDate, ShipDate, TotalDue 
		FROM dbo.SalesOrderHeader
		WHERE OrderDate BETWEEN @FromDate AND @ToDate
GO



--*
--* 8.2.6. ���� ������(Dynamic Queries)
--*


-- [�ҽ� 8-38] ���� ������ ���

CREATE PROC dbo.usp_GetEmployee_New
	@DeptID char(3) = '',
	@Retired char(1) = ''
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
	EXECUTE(@str)		
END
GO


-- [�ҽ� 8-39] ���� ���ν��� ȣ��

-- �� ���� ���� ��ȸ
EXEC dbo.usp_GetEmployee_New @DeptID = '', @Retired = ''
GO

-- �ٹ����� ���� ���� ��ȸ
EXEC dbo.usp_GetEmployee_New @DeptID = '', @Retired = 'N'
GO

-- �ٹ����� ������ ���� ����
EXEC dbo.usp_GetEmployee_New @DeptID = 'MKT', @Retired = 'N'
GO

-- ����� ������ ���� ����
EXEC dbo.usp_GetEmployee_New @DeptID = 'MKT', @Retired = 'Y'
GO