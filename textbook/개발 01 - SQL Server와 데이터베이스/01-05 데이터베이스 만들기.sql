--*
--* 1.5. �����ͺ��̽� ����� 
--*


--*
--* 1.5.4. CREATE DATABASE ������ �����
--*


-- [�ҽ� 1-1] �̸��� �ְ� �����ͺ��̽� �����

USE master
GO

-- �����ͺ��̽� �����
CREATE DATABASE FirstDB02
GO


-- [�ҽ� 1-2] �䱸���׿� �´� �����ͺ��̽� �����

USE master
GO

CREATE DATABASE SeconDB02
ON PRIMARY ( 
	NAME = N'SeconDB02', 
	FILENAME = N'D:\SQLData\SeconDB02.mdf', 
	SIZE = 1024MB, 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 256MB 
)
LOG ON ( 
	NAME = 'SeconDB02_log', 
	FILENAME = 'E:\SQLLog\SeconDB02_log.ldf', 
	SIZE = 256MB, 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 128MB 
)
GO