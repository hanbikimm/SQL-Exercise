--*
--* 2.5. HRDB2 �����ͺ��̽�
--*


-- [�ҽ� 2-62] HRDB2 �����ͺ��̽� �����

-- 1) �����ͺ��̽� �����

USE master
GO

-- ���� HRDB2�� �ִٸ�, ���� ����� ���� ������ �� �����ͺ��̽��� �����Ѵ�.
IF DB_ID('HRDB2') IS NOT NULL
BEGIN
    ALTER DATABASE HRDB2
		SET SINGLE_USER 
		WITH ROLLBACK IMMEDIATE
	DROP DATABASE HRDB2
END
GO

-- �����ͺ��̽� �����
CREATE DATABASE HRDB2
GO


-- [�ҽ� 2-63] ���̺� �����

-- 2) ���̺� �����

USE HRDB2
GO

-- Unit ���̺� �����
CREATE TABLE dbo.Unit (
	UnitID char(1) PRIMARY KEY,
	UnitName nvarchar(10) NOT NULL
)
GO

-- Department ���̺� �����
CREATE TABLE dbo.Department (
	DeptID char(3) PRIMARY KEY,
	DeptName nvarchar(10) NOT NULL,
	UnitID char(1) REFERENCES dbo.Unit(UnitID) NULL,
	StartDate date NOT NULL
)
GO

-- Employee ���̺� �����
CREATE TABLE dbo.Employee (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(4) NOT NULL,
	EngName varchar(20) NULL,
	Gender char(1) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NULL,
	DeptID char(3) REFERENCES Department(DeptID) NOT NULL,
	Phone char(13) UNIQUE NOT NULL,
	EMail varchar(50) UNIQUE NOT NULL,
	Salary int NULL
)
GO

-- Vacation ���̺� �����
CREATE TABLE dbo.Vacation (
	VacationID int IDENTITY PRIMARY KEY,
	EmpID char(5) REFERENCES dbo.Employee(EmpID),
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'���λ���',
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1),
	CHECK (EndDate >= BeginDate)
)
GO


-- [�ҽ� 2-64] ������ �߰�

-- 3) ������ �߰�

SET NOCOUNT ON
GO

-- Unit ���̺�
INSERT INTO dbo.Unit VALUES('A', N'��1����')
INSERT INTO dbo.Unit VALUES('B', N'��2����')
INSERT INTO dbo.Unit VALUES('C', N'��3����')
GO

-- Department ���̺�
INSERT INTO dbo.Department VALUES('SYS', N'�����ý���', 'A', '2011-01-01')
INSERT INTO dbo.Department VALUES('MKT', N'����', 'C', '2011-05-01')
INSERT INTO dbo.Department VALUES('HRD', N'�λ�', 'B', '2011-05-01')
INSERT INTO dbo.Department VALUES('GEN', N'�ѹ�', 'B', '2012-03-01')
INSERT INTO dbo.Department VALUES('ACC', N'ȸ��', 'B', '2013-04-01')
INSERT INTO dbo.Department VALUES('ADV', N'ȫ��', 'C', '2013-06-01')
INSERT INTO dbo.Department VALUES('STG', N'������ȹ', NULL, '2016-06-01')
GO

-- Employee ���̺�
INSERT INTO dbo.Employee VALUES('S0001', N'ȫ�浿', 'hong', 'M', '2011-01-01', NULL, 'SYS', '010-1234-1234', 'hong@dbnuri.com', 8500)
INSERT INTO dbo.Employee VALUES('S0002', N'������', 'jiemae ', 'M', '2011-01-12', NULL, 'GEN', '010-1111-1222', 'jimae@dbnuri.com', 8200)
INSERT INTO dbo.Employee VALUES('S0003', N'���쵿', NULL, 'M', '2012-04-01', NULL, 'SYS', '010-1222-2221', 'woodong@dbnuri.com', 6500)
INSERT INTO dbo.Employee VALUES('S0004', N'����', 'samsam', 'F', '2012-08-01', NULL, 'MKT', '010-3212-3212', 'samsoon@dbnuri.com',	7000)
INSERT INTO dbo.Employee VALUES('S0005', N'�����', 'Three', 'M', '2013-01-01', '2015-01-31','MKT', '010-9876-5432','samsik@dbnuri.com', 6400)
INSERT INTO dbo.Employee VALUES('S0006', N'��ġ��', 'kimchi', 'M', '2013-03-01', NULL, 'HRD', '010-8765-8765', 'chikook@dbnuri.com',	6000)
INSERT INTO dbo.Employee VALUES('S0007', N'�Ȱ���', NULL, 'M', '2013-05-01', NULL, 'ACC', '010-6543-3456', 'ahn@dbnuri.com', 6000)
INSERT INTO dbo.Employee VALUES('S0008', N'�ڿ���', 'parks', 'F', '2013-08-01', '2014-09-30', 'HRD', '010-2345-5432', 'yeosa@dbnuri.com', 6300)
INSERT INTO dbo.Employee VALUES('S0009', N'�ֻ��', 'samoya', 'F', '2013-10-01', NULL, 'SYS', '010-8899-9988', 'samo@dbnuri.com', 5800)
INSERT INTO dbo.Employee VALUES('S0010', N'��ȿ��', NULL, 'F', '2014-01-01', NULL, 'MKT', '010-9988-9900', 'hyori@dbnuri.com', 5000)
INSERT INTO dbo.Employee VALUES('S0011', N'������', 'fivegamja', 'M', '2014-02-01', NULL, 'SYS', '010-6655-7788', 'gamja@dbnuri.com',4700)
INSERT INTO dbo.Employee VALUES('S0012', N'���ϱ�', 'ilgook', 'M', '2014-02-01', NULL, 'GEN', '010-8703-7123', 'ilkook@dbnuri.com', 6500)
INSERT INTO dbo.Employee VALUES('S0013', N'�ѱ���', 'korea', 'M', '2014-04-01', NULL, 'SYS', '010-6611-1266', 'hankook@dbnuri.com', 4500)
INSERT INTO dbo.Employee VALUES('S0014', N'���ְ�', 'first', 'M', '2014-04-01', NULL, 'MKT', '010-2345-9886', 'one@dbnuri.com', 5000)
INSERT INTO dbo.Employee VALUES('S0015', N'��ġ��', NULL, 'M', '2014-06-01', '2015-05-31','MKT', '010-8800-0010', 'chichi@dbnuri.com', 4700)
INSERT INTO dbo.Employee VALUES('S0016', N'�ѻ��', 'onelove', 'F', '2014-06-01', NULL, 'HRD', '010-3215-0987', 'love@dbnuri.com', 7200)
INSERT INTO dbo.Employee VALUES('S0017', N'������', 'nado', 'M', '2015-12-01', NULL, 'ACC', '010-3399-9933', 'yaya@dbnuri.com', 4000)
INSERT INTO dbo.Employee VALUES('S0018', N'�̸���', NULL, 'M', '2016-01-01', '2016-06-30','HRD', '010-5521-1252', 'comeon@dbnuri.com', 5300)
INSERT INTO dbo.Employee VALUES('S0019', N'���ְ�', NULL, 'M', '2016-01-01', NULL, 'SYS', '010-7777-2277', 'give@dbnuri.com', 6000)
INSERT INTO dbo.Employee VALUES('S0020', N'�����', 'gogo', 'F', '2016-04-01', NULL, 'STG', '010-9966-1230', 'haha@dbnuri.com', NULL)
GO

-- Vacation ���̺�
INSERT INTO dbo.Vacation VALUES('S0001','2011-01-12','2011-01-12',N'�������')
INSERT INTO dbo.Vacation VALUES('S0001','2011-03-21','2011-03-21',N'�۽��')
INSERT INTO dbo.Vacation VALUES('S0001','2011-06-13','2011-06-14',N'�۽��')
INSERT INTO dbo.Vacation VALUES('S0001','2011-07-07','2011-07-07',N'�߿� ��� �غ�')
INSERT INTO dbo.Vacation VALUES('S0002','2011-07-21','2011-07-25',N'���;')
INSERT INTO dbo.Vacation VALUES('S0001','2011-08-01','2011-08-01',N'ġ���� ���ؼ�')
INSERT INTO dbo.Vacation VALUES('S0001','2011-08-03','2011-08-08',N'���;')
INSERT INTO dbo.Vacation VALUES('S0002','2011-11-17','2011-11-17',N'����')
INSERT INTO dbo.Vacation VALUES('S0001','2011-12-01','2011-12-15',N'���')
INSERT INTO dbo.Vacation VALUES('S0002','2012-02-10','2012-02-13',N'����')
INSERT INTO dbo.Vacation VALUES('S0002','2012-04-19','2012-04-19',N'���;')
INSERT INTO dbo.Vacation VALUES('S0002','2012-06-15','2012-06-18',N'����Ʈ')
INSERT INTO dbo.Vacation VALUES('S0003','2012-09-17','2012-09-17',N'�޽��� �ʿ�')
INSERT INTO dbo.Vacation VALUES('S0003','2012-10-26','2012-10-26',N'�߿� ��� �غ�')
INSERT INTO dbo.Vacation VALUES('S0001','2012-10-26','2012-10-29',N'ġ���� ���ؼ�')
INSERT INTO dbo.Vacation VALUES('S0003','2013-01-18','2013-01-18',N'ġ���� ���ؼ�')
INSERT INTO dbo.Vacation VALUES('S0005','2013-03-25','2013-03-29',N'�̻�')
INSERT INTO dbo.Vacation VALUES('S0006','2013-04-08','2013-04-08',N'�ñ������� ������')
INSERT INTO dbo.Vacation VALUES('S0005','2013-04-08','2013-04-17',N'�޽��� �ʿ�')
INSERT INTO dbo.Vacation VALUES('S0002','2013-04-15','2013-04-15',N'�׳�')
INSERT INTO dbo.Vacation VALUES('S0007','2013-06-06','2013-06-06',N'���')
INSERT INTO dbo.Vacation VALUES('S0005','2013-06-06','2013-06-06',N'����')
INSERT INTO dbo.Vacation VALUES('S0002','2013-06-06','2013-06-06',N'�ñ������� ������')
INSERT INTO dbo.Vacation VALUES('S0002','2013-06-28','2013-07-02',N'����')
INSERT INTO dbo.Vacation VALUES('S0006','2013-06-28','2013-07-01',N'�׳�')
INSERT INTO dbo.Vacation VALUES('S0005','2013-06-28','2013-07-01',N'���̰� ���� ������')
INSERT INTO dbo.Vacation VALUES('S0007','2013-07-11','2013-07-11',N'���')
INSERT INTO dbo.Vacation VALUES('S0006','2013-07-15','2013-07-15',N'�׳�')
INSERT INTO dbo.Vacation VALUES('S0006','2013-07-16','2013-07-25',N'��������')
INSERT INTO dbo.Vacation VALUES('S0003','2013-07-18','2013-07-18',N'�������')
INSERT INTO dbo.Vacation VALUES('S0001','2013-07-18','2013-07-29',N'���λ���')
INSERT INTO dbo.Vacation VALUES('S0003','2013-09-12','2013-09-16',N'��Ż')
INSERT INTO dbo.Vacation VALUES('S0008','2013-09-12','2013-09-12',N'�������')
INSERT INTO dbo.Vacation VALUES('S0003','2013-10-08','2013-10-17',N'���� û��')
INSERT INTO dbo.Vacation VALUES('S0001','2013-11-19','2013-11-19',N'���ۼ�')
INSERT INTO dbo.Vacation VALUES('S0008','2013-12-27','2013-12-27',N'�׳�')
INSERT INTO dbo.Vacation VALUES('S0001','2014-01-20','2014-01-22',N'�׳�')
INSERT INTO dbo.Vacation VALUES('S0007','2014-01-20','2014-01-20',N'�Ӹ��� ��������')
INSERT INTO dbo.Vacation VALUES('S0001','2014-04-04','2014-04-07',N'�ǰ��ؼ�')
INSERT INTO dbo.Vacation VALUES('S0007','2014-04-04','2014-04-07',N'�̻�')
INSERT INTO dbo.Vacation VALUES('S0006','2014-04-04','2014-04-04',N'Ȩ����')
INSERT INTO dbo.Vacation VALUES('S0011','2014-04-04','2014-04-08',N'�Ӹ��� ��������')
INSERT INTO dbo.Vacation VALUES('S0008','2014-04-04','2014-04-08',N'�ʹ� �ܷο���')
INSERT INTO dbo.Vacation VALUES('S0013','2014-05-09','2014-05-09',N'���λ���')
INSERT INTO dbo.Vacation VALUES('S0001','2014-05-09','2014-05-12',N'���;')
INSERT INTO dbo.Vacation VALUES('S0012','2014-07-25','2014-07-25',N'�׳�')
INSERT INTO dbo.Vacation VALUES('S0013','2014-07-25','2014-07-25',N'���λ���')
INSERT INTO dbo.Vacation VALUES('S0016','2014-07-25','2014-07-25',N'�ǰ��ؼ�')
INSERT INTO dbo.Vacation VALUES('S0008','2014-07-25','2014-07-25',N'��������')
INSERT INTO dbo.Vacation VALUES('S0001','2014-08-06','2014-08-07',N'ġ���� ���ؼ�')
INSERT INTO dbo.Vacation VALUES('S0003','2014-08-28','2014-09-01',N'����')
INSERT INTO dbo.Vacation VALUES('S0012','2014-08-28','2014-08-28',N'�������')
INSERT INTO dbo.Vacation VALUES('S0002','2014-10-02','2014-10-03',N'�۽��')
INSERT INTO dbo.Vacation VALUES('S0001','2014-10-02','2014-10-02',N'�߿� ��� �غ�')
INSERT INTO dbo.Vacation VALUES('S0007','2014-10-02','2014-10-02',N'���')
INSERT INTO dbo.Vacation VALUES('S0016','2014-10-07','2014-10-07',N'���λ���')
INSERT INTO dbo.Vacation VALUES('S0001','2014-10-16','2014-10-17',N'��Ż')
INSERT INTO dbo.Vacation VALUES('S0011','2014-10-16','2014-10-20',N'�۽��')
INSERT INTO dbo.Vacation VALUES('S0007','2014-10-16','2014-10-20',N'ġ���� ���ؼ�')
INSERT INTO dbo.Vacation VALUES('S0013','2014-10-16','2014-10-16',N'�ñ������� ������')
INSERT INTO dbo.Vacation VALUES('S0005','2014-10-16','2014-10-17',N'�ʹ� �ܷο���')
INSERT INTO dbo.Vacation VALUES('S0016','2014-11-28','2014-11-28',N'���� û��')
INSERT INTO dbo.Vacation VALUES('S0005','2014-12-02','2014-12-02',N'�Ӹ��� ��������')
INSERT INTO dbo.Vacation VALUES('S0010','2014-12-26','2014-12-29',N'���̰� ���� ������')
INSERT INTO dbo.Vacation VALUES('S0001','2014-12-26','2014-12-26',N'���')
INSERT INTO dbo.Vacation VALUES('S0012','2014-12-26','2014-12-29',N'�߿� ��� �غ�')
INSERT INTO dbo.Vacation VALUES('S0001','2015-01-28','2015-01-28',N'�������')
INSERT INTO dbo.Vacation VALUES('S0010','2015-01-28','2015-01-28',N'�Ӹ��� ��������')
INSERT INTO dbo.Vacation VALUES('S0012','2015-03-10','2015-03-10',N'����')
INSERT INTO dbo.Vacation VALUES('S0001','2015-03-10','2015-03-11',N'�������')
INSERT INTO dbo.Vacation VALUES('S0012','2015-04-30','2015-04-30',N'����')
INSERT INTO dbo.Vacation VALUES('S0007','2015-04-30','2015-04-30',N'���� û��')
INSERT INTO dbo.Vacation VALUES('S0003','2015-05-08','2015-05-08',N'����Ʈ')
INSERT INTO dbo.Vacation VALUES('S0007','2015-05-08','2015-05-08',N'��Ż')
INSERT INTO dbo.Vacation VALUES('S0007','2015-07-14','2015-07-14',N'����')
INSERT INTO dbo.Vacation VALUES('S0003','2015-07-14','2015-07-20',N'���̰� ���� ������')
INSERT INTO dbo.Vacation VALUES('S0001','2015-08-06','2015-08-10',N'�̻�')
INSERT INTO dbo.Vacation VALUES('S0013','2015-08-12','2015-08-12',N'�߿� ��� �غ�')
INSERT INTO dbo.Vacation VALUES('S0011','2015-08-12','2015-08-12',N'�Ӹ��� ��������')
INSERT INTO dbo.Vacation VALUES('S0011','2015-11-03','2015-11-05',N'�۽��')
INSERT INTO dbo.Vacation VALUES('S0002','2015-11-03','2015-11-03',N'�ʹ� �ܷο���')
INSERT INTO dbo.Vacation VALUES('S0003','2015-11-18','2015-11-18',N'�޽��� �ʿ�')
INSERT INTO dbo.Vacation VALUES('S0010','2015-11-30','2015-12-01',N'���;')
INSERT INTO dbo.Vacation VALUES('S0007','2016-02-03','2016-02-03',N'����Ʈ')
INSERT INTO dbo.Vacation VALUES('S0011','2016-03-07','2016-03-11',N'�ñ������� ������')
INSERT INTO dbo.Vacation VALUES('S0016','2016-03-07','2016-03-07',N'�۽��')
INSERT INTO dbo.Vacation VALUES('S0002','2016-03-07','2016-03-09',N'��Ż')
INSERT INTO dbo.Vacation VALUES('S0017','2016-04-22','2016-04-22',N'�̻�')
INSERT INTO dbo.Vacation VALUES('S0002','2016-04-22','2016-04-26',N'���� û��')
INSERT INTO dbo.Vacation VALUES('S0006','2016-04-25','2016-05-04',N'���λ���')
INSERT INTO dbo.Vacation VALUES('S0001','2016-05-05','2016-05-06',N'Ȩ����')
INSERT INTO dbo.Vacation VALUES('S0002','2016-05-05','2016-05-06',N'���̰� ���� ������')
INSERT INTO dbo.Vacation VALUES('S0017','2016-05-20','2016-05-23',N'���� û��')
INSERT INTO dbo.Vacation VALUES('S0012','2016-05-30','2016-06-01',N'�׳�')
INSERT INTO dbo.Vacation VALUES('S0019','2016-05-30','2016-06-03',N'���� û��')
INSERT INTO dbo.Vacation VALUES('S0017','2016-06-03','2016-06-06',N'ġ���� ���ؼ�')
INSERT INTO dbo.Vacation VALUES('S0012','2016-06-03','2016-06-06',N'���� û��')
INSERT INTO dbo.Vacation VALUES('S0012','2016-07-18','2016-07-18',N'Ȩ����')
INSERT INTO dbo.Vacation VALUES('S0007','2016-08-10','2016-08-10',N'�۽��')
INSERT INTO dbo.Vacation VALUES('S0013','2016-08-10','2016-08-15',N'���ۼ�')
INSERT INTO dbo.Vacation VALUES('S0007','2016-08-17','2016-08-19',N'���� û��')
INSERT INTO dbo.Vacation VALUES('S0019','2016-09-08','2016-09-08',N'�ʹ� �ܷο���')

SET NOCOUNT OFF
GO