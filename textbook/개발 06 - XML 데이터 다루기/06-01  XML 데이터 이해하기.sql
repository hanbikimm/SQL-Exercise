--*
--* 6.1. XML ������ �����ϱ�
--*


USE HRDB2
GO


--*
--* 6.1.2. ���ڷ� ����ϴ� XML ������
--*


-- [�ҽ� 6-1] ���ڿ��μ��� XML ������

IF OBJECT_ID('dbo.strEmployee', 'U') IS NOT NULL
	DROP TABLE dbo.strEmployee
GO

CREATE TABLE dbo.strEmployee (
	Seq int IDENTITY PRIMARY KEY,
	EmpInfo nvarchar(1000)
)
GO

INSERT INTO dbo.strEmployee VALUES ('
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
GO

SELECT * FROM dbo.strEmployee
GO



--*
--* 6.1.3. XML ������ ���� ����
--*


-- [�ҽ� 6-2] XML ������ ���Ŀ� ����Ǵ� XML ������

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
GO

SELECT * FROM dbo.xmlEmployee
GO


-- [�ҽ� 6-3] ���ڿ� ������ ������ XML ������ �������� ��ȯ

ALTER TABLE dbo.strEmployee
	ALTER COLUMN EmpInfo xml
GO



--*
--* 6.1.4. XML ��Ű�� �÷������� ���Ἲ Ȯ��
--*


-- [�ҽ� 6-4] XML ��Ű�� �÷��� �����

CREATE XML SCHEMA COLLECTION EmpSchema AS '
<schema xmlns="http://www.w3.org/2001/XMLSchema">
  <element name="Employees">
    <complexType>
      <sequence>
        <element name="Employee" minOccurs="0">
          <complexType>
            <sequence>
              <element name="EmpName" minOccurs="1" maxOccurs="1" />
              <element name="Contact" minOccurs="1" maxOccurs="1" />
            </sequence>
            <attribute name="EmpID" type="string" use="required" />
          </complexType>
        </element>
      </sequence>
    </complexType>
  </element>
</schema>'
GO


-- [�ҽ� 6-5] XML ������ ������ ���� XML ��Ű�� �÷��� ����

IF OBJECT_ID('dbo.xmlEmployee', 'U') IS NOT NULL
	DROP TABLE dbo.xmlEmployee
GO

CREATE TABLE dbo.xmlEmployee (
	Seq int IDENTITY PRIMARY KEY,
	EmpInfo xml (EmpSchema) -- XML ��Ű�� �÷��� ����
)
GO


-- [�ҽ� 6-6] ��Ű�� �÷��ǿ� ���� ���� XML ������ �Է�

INSERT INTO dbo.xmlEmployee VALUES ('
	<Employees>
		<Employee EmpID="S0003">
			<EmpName>
				<FirstName>�쵿</FirstName>
				<LastName>��</LastName>
			</EmpName>
		</Employee>
	</Employees>
	')
GO


-- �޽��� 6908, ���� 16, ���� 1, �� 115
-- XML ��ȿ�� �˻�: ������ �߸��Ǿ����ϴ�. 
-- �ʿ��� ���: 'Contact'. ��ġ: /*:Employees[1]/*:Employee[1]


-- [�ҽ� 6-7] ��Ű�� �÷��ǿ� �´� XML ������ �Է�

INSERT INTO dbo.xmlEmployee  VALUES ('
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