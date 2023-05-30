--*
--* 6.3. ���̺� ���·� ��ȯ�ϴ� OPENXML �Լ�
--*


USE HRDB2
GO


--*
--* 6.3.2. OPENXML �Լ� ��� ��
--*


-- [�ҽ� 6-18] OPENXML ��� ��

DECLARE @DocHandle int
DECLARE @XmlDoc xml

SET @XmlDoc = N'
<root>
  <Employee>
    <EmpID>S0002</EmpID>
    <EmpName>������</EmpName>
    <Gender>M</Gender>
    <EMail>jimae@dbnuri.com</EMail>
  </Employee>
  <Employee>
    <EmpID>S0012</EmpID>
    <EmpName>���ϱ�</EmpName>
    <Gender>M</Gender>
    <EMail>ilkook@dbnuri.com</EMail>
  </Employee>
</root>'

EXEC sp_xml_preparedocument @DocHandle OUTPUT, @XmlDoc

SELECT *
	FROM OPENXML (@DocHandle, '/root/Employee', 2) WITH dbo.Employee

EXEC sp_xml_removedocument @DocHandle
GO