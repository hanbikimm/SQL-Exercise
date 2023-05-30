--*
--* 6.4. XQuery�� XML ������ �ٷ��
--*


USE HEDB2
GO


--*
--* 6.4.1. XQuery��?
--*


-- [�ҽ� 6-19] ���� ���̺� �����

IF OBJECT_ID('dbo.xmlEmployee', 'U') IS NOT NULL
	DROP TABLE dbo.xmlEmployee
GO

CREATE TABLE dbo.xmlEmployee (
	Seq int IDENTITY PRIMARY KEY,
	EmpInfo xml
)
GO

INSERT INTO dbo.xmlEmployee VALUES ('
	<Employees>
		<Employee EmpID="S0001">
			<EmpName>
				<FirstName>�浿</FirstName>
				<LastName>ȫ</LastName>
			</EmpName>
			<Contact>
				<Phone>010-1234-1234</Phone>
				<Fax>02-3456-7800</Fax>
				<Email>hong@dbnuri.com</Email>
			</Contact>
		</Employee>
	</Employees>
	')
INSERT INTO dbo.xmlEmployee VALUES ('
	<Employees>
		<Employee EmpID="S0002">
			<EmpName>
				<FirstName>����</FirstName>
				<LastName>��</LastName>
			</EmpName>
			<Contact>
				<Phone>010-2234-3312</Phone>
				<Fax>02-3411-7823</Fax>
				<Email>jimae@dbnuri.com</Email>
			</Contact>
		</Employee>
	</Employees>
	')
GO
INSERT INTO dbo.xmlEmployee VALUES ('
	<Employees>
		<Employee EmpID="S0003">
			<EmpName>
				<FirstName>�쵿</FirstName>
				<LastName>��</LastName>
			</EmpName>
			<Contact>
				<Phone>010-6543-9876</Phone>
				<Fax>02-2390-4590</Fax>
				<Email>hodong@dbnuri.com</Email>
			</Contact>
		</Employee>
	</Employees>
	')
GO



--*
--* 6.4.2. query �޼ҵ�
--*


-- [�ҽ� 6-20] query �޼ҵ� ��� �� #1

SELECT EmpInfo.query('/Employees/Employee/Contact')
	FROM dbo.xmlEmployee 
	WHERE Seq = 1
GO
/*
<Contact>
  <Phone>010-1234-1234</Phone>
  <Fax>02-3456-7800</Fax>
  <Email>hong@dbnuri.com</Email>
</Contact>
*/


-- [�ҽ� 6-21] query �޼ҵ� ��� �� #2

SELECT EmpInfo.query('/Employees/Employee/EmpName')
	FROM dbo.xmlEmployee
	WHERE Seq = 1
GO
/*
<EmpName>
  <FirstName>�浿</FirstName>
  <LastName>ȫ</LastName>
</EmpName>
*/



--*
--* 6.4.3. value �޼ҵ�
--*


-- [�ҽ� 6-22] value �޼ҵ� ��� �� #1

SELECT EmpInfo.value('(/Employees/Employee/@EmpID)[1]', 'char(5)') AS 'EmpID'
	FROM dbo.xmlEmployee
GO
/*
EmpID
--------------------
S0001
S0002
S0003
*/


-- [�ҽ� 6-23] value �޼ҵ� ��� �� #2

SELECT EmpInfo.value('(/Employees/Employee/Contact/Email)[1]', 'varchar(50)') AS 'EMail'
	FROM dbo.xmlEmployee
GO
/*
EMail
-------------------------
hong@dbnuri.com
jimae@dbnuri.com
hodong@dbnuri.com
*/



--*
--* 6.4.4. exist �޼ҵ�
--*


-- [�ҽ� 6-24] exist �޼ҵ� ��� �� #1

SELECT EmpInfo
	FROM dbo.xmlEmployee
	WHERE EmpInfo.exist('/Employees/Employee[@EmpID="S0001"]') = 1
GO
/*
<Employees>
  <Employee EmpID="S0001">
    <EmpName>
      <FirstName>�浿</FirstName>
      <LastName>ȫ</LastName>
    </EmpName>
    <Contact>
      <Phone>010-1234-1234</Phone>
      <Fax>02-3456-7800</Fax>
      <Email>hong@dbnuri.com</Email>
    </Contact>
  </Employee>
</Employees>
*/


-- [�ҽ� 6-25] exist �޼ҵ� ��� �� #2

SELECT EmpInfo.query('/Employees/Employee/Contact')
	FROM dbo.xmlEmployee
	WHERE EmpInfo.exist('/Employees/Employee/Contact[Phone="010-6543-9876"]') = 1
GO
/*
<Contact>
  <Phone>010-6543-9876</Phone>
  <Fax>02-2390-4590</Fax>
  <Email>hodong@dbnuri.com</Email>
</Contact>
*/



--*
--* 6.4.5. modify �޼ҵ�
--*


-- [�ҽ� 6-26] modify �޼ҵ��� replace �� ��� ��

-- Repalce
UPDATE dbo.xmlEmployee
	SET EmpInfo.modify('
		replace value of (/Employees/Employee/Contact/Email/text())[1]
		with "gildong@dbnuri.com"
	')
	WHERE Seq = 1
GO

SELECT EmpInfo.query('/Employees/Employee/Contact')
	FROM dbo.xmlEmployee
	WHERE Seq = 1
GO

-- ���
/*
<Contact>
  <Phone>010-1234-1234</Phone>
  <Fax>02-3456-7800</Fax>
  <Email>gildong@dbnuri.com</Email>
</Contact>
*/


-- [�ҽ� 6-27] modify �޼ҵ��� insert �� ��� ��

-- Insert
UPDATE dbo.xmlEmployee
	SET Empinfo.modify('
		insert <Twitter>@gildong</Twitter>
		after (/Employees/Employee/Contact/Email)[1]
	')
	WHERE Seq = 1
GO

SELECT EmpInfo.query('/Employees/Employee/Contact')
	FROM dbo.xmlEmployee
	WHERE Seq = 1
GO

-- ���
/*
<Contact>
  <Phone>010-1234-1234</Phone>
  <Fax>02-3456-7800</Fax>
  <Email>gildong@dbnuri.com</Email>
  <Twitter>@gildong</Twitter>
</Contact>
*/


-- [�ҽ� 6-28] modify �޼ҵ��� delete �� ��� ��

-- Delete
UPDATE dbo.xmlEmployee
	SET EmpInfo.modify('
		delete /Employees/Employee/Contact/Email[1]
	')
	WHERE Seq = 1
GO

SELECT EmpInfo.query('/Employees/Employee/Contact')
	FROM dbo.xmlEmployee
	WHERE Seq = 1
GO

-- ���
/*
<Contact>
  <Phone>010-1234-1234</Phone>
  <Fax>02-3456-7800</Fax>
  <Twitter>@gildong</Twitter>
</Contact>
*/



--*
--* 6.4.6. nodes �޼ҵ�
--*


-- [�ҽ� 6-29] node �޼ҵ� ��� ��

SELECT nCol.value('@EmpID', 'char(5)') AS EmpID,
		  nCol.value('(EmpName/FirstName)[1]', 'nchar(2)') AS FirstName,
		  nCol.value('(EmpName/LastName)[1]', 'nchar(1)') AS LastName,
		  nCol.value('(Contact/Phone)[1]', 'varchar(20)') AS Phone,
		  nCol.value('(Contact/Fax)[1]', 'varchar(20)') AS Fax,
		  nCol.value('(Contact/Email)[1]', 'varchar(60)') AS Email
	FROM dbo.xmlEmployee
	CROSS APPLY EmpInfo.nodes('/Employees/Employee') AS nTable(nCol)
	ORDER BY Seq
GO