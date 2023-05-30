--*
--* 10.5. ���� ���̺�(File Tables)
--*



--*
--* 10.5.1. �����ͺ��̽� �Ӽ� ����
--*


-- [�ҽ� 10-35] �����ͺ��̽� �Ӽ� ����

USE master
GO

ALTER DATABASE HRDB2
	SET FILESTREAM( 
		NON_TRANSACTED_ACCESS = FULL, 
		DIRECTORY_NAME = N'MyFileStream'
	) 
GO



--*
--* 10.5.2. ���� ���̺� �����
--*


-- [�ҽ� 10-36] ���� ���̺� �����

USE HRDB2
GO

CREATE TABLE dbo.New_Photos 
	AS FILETABLE
	WITH (
		FILETABLE_DIRECTORY = 'MyFileTable'
	)
GO



--*
--* 10.5.3. ���� ���̺� ��� Ȯ��
--*


-- [�ҽ� 10-37] ���� ���̺� ���� Ȯ��

SELECT name, file_type, creation_time, last_write_time, last_access_time
	FROM dbo.New_Photos 
GO


-- [�ҽ� 10-38] ���������� ���� �̸� �����ϱ�

UPDATE dbo.New_Photos 
	SET name = 'hong.jpg'
	WHERE name = 's0001.jpg'
GO