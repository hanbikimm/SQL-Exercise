--*
--* 1.6. ���� �׷�(File Groups) Ȱ��
--*



--*
--* 1.6.3. ���� �׷� �����
--*


-- [�ҽ� 1-3] ���������� ���� �׷�� ���� �߰�

USE master
GO

-- UFG01 ���� �׷� �߰�
ALTER DATABASE FirstDB02
	ADD FILEGROUP UFG01
GO

-- UFG01 ���� �׷쿡 ���� �߰�
ALTER DATABASE FirstDB02
	ADD FILE ( 
		NAME = 'FirstDB02_02', 
		FILENAME = 'D:\SQLData\FirstDB02_02.ndf', 
		SIZE = 512MB, 
		FILEGROWTH = 128MB 
	) TO FILEGROUP UFG01
GO

-- UFG02 ���� �׷� 
ALTER DATABASE FirstDB02
	ADD FILEGROUP UFG02
GO

-- UFG02 ���� �׷쿡 ���� �߰�
ALTER DATABASE FirstDB02
	ADD FILE ( 
		NAME = 'FirstDB02_03', 
		FILENAME = 'D:\SQLData\FirstDB02_03.ndf', 
		SIZE = 512MB, 
		FILEGROWTH = 128MB 
	) TO FILEGROUP UFG02
GO


USE FirstDB02
GO

-- UFG01 ���� �׷��� �⺻ ���� �׷����� ����
ALTER DATABASE FirstDB02
	MODIFY FILEGROUP UFG01 DEFAULT
GO



--*
--* 1.6.4. ���� �׷쿡 ���̺� �����
--*


-- [�ҽ� 1-4] ���� �׷쿡 ���̺� �����

USE FirstDB02
GO

-- PRIMARY ���� �׷쿡 TA ���̺� �����
CREATE TABLE TA (
	col1 int,
	col2 int
) ON [PRIMARY]
GO

-- UFG01 ���� �׷쿡 TB ���̺� �����
CREATE TABLE TB (
	col1 int,
	col2 int
) ON UFG01
GO

-- UFG02 ���� �׷쿡 TC ���̺� �����
CREATE TABLE TC (
	col1 int,
	col2 int
) ON UFG02
GO

-- �⺻ ���� �׷쿡 TD ���̺� �����
CREATE TABLE TD (
	col1 int,
	col2 int
)
GO