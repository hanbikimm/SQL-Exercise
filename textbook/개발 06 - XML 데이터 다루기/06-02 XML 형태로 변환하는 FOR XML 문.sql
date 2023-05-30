--*
--* 06-02 XML ���·� ��ȯ�ϴ� FOR XML ��
--*


USE HRDB2
GO


--*
--* 6.2.2. FOR XML RAW ��
--*


-- [�ҽ� 6-8] FOR XML RAW ��� ��


SELECT EmpID, EmpName
	FROM dbo.Employee
	WHERE DeptID = 'GEN'
	FOR XML RAW
GO

-- ���
/*
<row EmpID="S0002" EmpName="������" />
<row EmpID="S0012" EmpName="���ϱ�" />
*/


-- [�ҽ� 6-9] FOR XML RAW, ELEMENTS ��� ��

SELECT EmpID, EmpName, Gender, EMail
	FROM dbo.Employee  
	WHERE DeptID = 'GEN'
	ORDER BY EmpName
	FOR XML RAW, ELEMENTS
GO

-- ���
/*
<row>
  <EmpID>S0002</EmpID>
  <EmpName>������</EmpName>
  <Gender>M</Gender>
  <EMail>jimae@dbnuri.com</EMail>
</row>
<row>
  <EmpID>S0012</EmpID>
  <EmpName>���ϱ�</EmpName>
  <Gender>M</Gender>
  <EMail>ilkook@dbnuri.com</EMail>
</row>
*/


-- [�ҽ� 6-10] FOR XML RAW(��...��), ROOT(��...��) ��� ��

SELECT EmpID, EmpName, Gender, EMail
	FROM dbo.Employee  
	WHERE DeptID = 'GEN'
	ORDER BY EmpName
	FOR XML RAW('���'), ROOT('�����')
GO

-- ���
/*
<�����>
  <��� EmpID="S0002" EmpName="������" Gender="M" EMail="jimae@dbnuri.com" />
  <��� EmpID="S0012" EmpName="���ϱ�" Gender="M" EMail="ilkook@dbnuri.com" />
</�����>
*/


-- [�ҽ� 6-11] FOR XML RAW(��...��), ROOT(��...��), ELEMENTS ��� ��

SELECT EmpID, EmpName, Gender, EMail
	FROM dbo.Employee  
	WHERE DeptID = 'GEN'
	ORDER BY EmpName
	FOR XML RAW('���'), ROOT('�����'), ELEMENTS
GO

-- ���
/*
<�����>
  <���>
    <EmpID>S0002</EmpID>
    <EmpName>������</EmpName>
    <Gender>M</Gender>
    <EMail>jimae@dbnuri.com</EMail>
  </���>
  <���>
    <EmpID>S0012</EmpID>
    <EmpName>���ϱ�</EmpName>
    <Gender>M</Gender>
    <EMail>ilkook@dbnuri.com</EMail>
  </���>
</�����
*/



--*
--* 6.2.3. FOR XML AUTO ��
--*


-- [�ҽ� 6-12] FOR XML AUTO ��� ��

SELECT EmpID, EmpName, Gender, EMail
	FROM dbo.Employee  
	WHERE DeptID = 'GEN'
	ORDER BY EmpName
	FOR XML AUTO
GO

-- ���
/*
<dbo.Employee EmpID="S0002" EmpName="������" Gender="M" EMail="jimae@dbnuri.com" />
<dbo.Employee EmpID="S0012" EmpName="���ϱ�" Gender="M" EMail="ilkook@dbnuri.com" />
*/


-- [�ҽ� 6-13] FOR XML AUTO, ELEMENTS ��� ��

SELECT EmpID, EmpName, Gender, EMail
	FROM dbo.Employee  
	WHERE DeptID = 'GEN'
	ORDER BY EmpName
	FOR XML AUTO, ELEMENTS
GO

-- ���
/*
<dbo.Employee>
  <EmpID>S0002</EmpID>
  <EmpName>������</EmpName>
  <Gender>M</Gender>
  <EMail>jimae@dbnuri.com</EMail>
</dbo.Employee>
<dbo.Employee>
  <EmpID>S0012</EmpID>
  <EmpName>���ϱ�</EmpName>
  <Gender>M</Gender>
  <EMail>ilkook@dbnuri.com</EMail>
</dbo.Employee>
*/


-- [�ҽ� 6-14] FOR XML AUTO, ELEMENTS, ROOT(��...��) ��� ��

SELECT EmpID, EmpName, Gender, EMail
	FROM dbo.Employee  
	WHERE DeptID = 'GEN'
	ORDER BY EmpName
	FOR XML AUTO, ELEMENTS, ROOT('�����')
GO

-- ���
/*
<�����>
  <dbo.Employee>
    <EmpID>S0002</EmpID>
    <EmpName>������</EmpName>
    <Gender>M</Gender>
    <EMail>jimae@dbnuri.com</EMail>
  </dbo.Employee>
  <dbo.Employee>
    <EmpID>S0012</EmpID>
    <EmpName>���ϱ�</EmpName>
    <Gender>M</Gender>
    <EMail>ilkook@dbnuri.com</EMail>
  </dbo.Employee>
</�����>
*/



--*
--* 6.2.4. FOR XML EXPLICIT ��
--*


-- [�ҽ� 6-15] FOR XML EXPLICIT ��� ��

SELECT 1 AS Tag,
		NULL AS Parent,
		EmpID AS [���!1!�����ȣ],
		EmpName AS [���!1!����̸�!Element]
	FROM dbo.Employee
	WHERE DeptID = 'GEN'
	FOR XML EXPLICIT
GO

-- ���
/*
<��� �����ȣ="S0002">
  <����̸�>������</����̸�>
</���>
<��� �����ȣ="S0012">
  <����̸�>���ϱ�</����̸�>
</���>
*/



--*
--* 6.2.5. FOR XML PATH ��
--*


-- [�ҽ� 6-16] FOR XML PATH ��� ��

SELECT EmpName "@����̸�",
		'N/A' "����ó/��ȭ��ȣ",
		EMail "����ó/�̸���"
	FROM dbo.Employee
	WHERE DeptID = 'GEN'
	FOR XML PATH
GO

-- ���
/*
<row ����̸�="������">
  <����ó>
    <��ȭ��ȣ>N/A</��ȭ��ȣ>
    <�̸���>jimae@dbnuri.com</�̸���>
  </����ó>
</row>
<row ����̸�="���ϱ�">
  <����ó>
    <��ȭ��ȣ>N/A</��ȭ��ȣ>
    <�̸���>ilkook@dbnuri.com</�̸���>
  </����ó>
</row>
*/


-- [�ҽ� 6-17] ��� �̸� ���� ��

SELECT EmpName "@����̸�",
		'N/A' "����ó/��ȭ��ȣ",
		EMail "����ó/�̸���"
	FROM dbo.Employee
	WHERE DeptID = 'GEN'
	FOR XML PATH('���')
GO

-- ���
/*
<��� ����̸�="������">
  <����ó>
    <��ȭ��ȣ>N/A</��ȭ��ȣ>
    <�̸���>jimae@dbnuri.com</�̸���>
  </����ó>
</���>
<��� ����̸�="���ϱ�">
  <����ó>
    <��ȭ��ȣ>N/A</��ȭ��ȣ>
    <�̸���>ilkook@dbnuri.com</�̸���>
  </����ó>
</���>*/