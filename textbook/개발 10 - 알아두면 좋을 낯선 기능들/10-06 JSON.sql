--*
--* 10.6. JSON(JavaScript Object Notation)
--*



USE HRDB2
GO


--* 
--* 10.6.1. JSON ������ ���·� ��� ���
--*


-- [�ҽ� 10-39] FOR JSON AUTO ��� ��

SELECT e.EmpID, e.EmpName, e.Gender, d.DeptName, e.RetireDate
	FROM dbo.Employee AS e
	INNER JOIN dbo.Department AS d
	ON e.DeptID = d.DeptID
	WHERE EmpID BETWEEN 'S0005' AND 'S0006'
	FOR JSON AUTO
GO

-- ���
/*
[  
   {  
      "EmpID":"S0005",
      "EmpName":"�����",
      "Gender":"M",
      "RetireDate":"2015-01-31",
      "d":[  
         {  
            "DeptName":"����"
         }
      ]
   },
   {  
      "EmpID":"S0006",
      "EmpName":"��ġ��",
      "Gender":"M",
      "d":[  
         {  
            "DeptName":"�λ�"
         }
      ]
   }
]
*/


-- [�ҽ� 10-40] FOR JSON PATH ��� ��

SELECT e.EmpID, e.EmpName, e.Gender, d.DeptName, e.RetireDate
	FROM dbo.Employee AS e
	INNER JOIN dbo.Department AS d
	ON e.DeptID = d.DeptID
	WHERE EmpID BETWEEN 'S0005' AND 'S0006'
	FOR JSON PATH 
GO


-- ���
/*
[  
   {  
      "EmpID":"S0005",
      "EmpName":"�����",
      "Gender":"M",
      "DeptName":"����",
      "RetireDate":"2015-01-31"
   },
   {  
      "EmpID":"S0006",
      "EmpName":"��ġ��",
      "Gender":"M",
      "DeptName":"�λ�"
   }
]
*/


-- [�ҽ� 10-41] FOR JSON PATH, ROOT ��� ��

SELECT e.EmpID, e.EmpName, e.Gender, d.DeptName, e.RetireDate
	FROM dbo.Employee AS e
	INNER JOIN dbo.Department AS d
	ON e.DeptID = d.DeptID
	WHERE EmpID BETWEEN 'S0005' AND 'S0006'
	FOR JSON PATH, ROOT('Employee')
GO

/*
{  
   "Employee":[  
      {  
         "EmpID":"S0005",
         "EmpName":"�����",
         "Gender":"M",
         "DeptName":"����",
         "RetireDate":"2015-01-31"
      },
      {  
         "EmpID":"S0006",
         "EmpName":"��ġ��",
         "Gender":"M",
         "DeptName":"�λ�"
      }
   ]
}
*/

-- [�ҽ� 10-42] INCLUDE_NULL_VALUES ��� ��

SELECT e.EmpID, e.EmpName, e.Gender, d.DeptName, e.RetireDate
	FROM dbo.Employee AS e
	INNER JOIN dbo.Department AS d
	ON e.DeptID = d.DeptID
	WHERE EmpID BETWEEN 'S0005'  AND 'S0006'
    FOR JSON PATH, ROOT('Employee'), INCLUDE_NULL_VALUES
GO

-- ���
/*
{  
   "Employee":[  
      {  
         "EmpID":"S0005",
         "EmpName":"�����",
         "Gender":"M",
         "DeptName":"����",
         "RetireDate":"2015-01-31"
      },
      {  
         "EmpID":"S0006",
         "EmpName":"��ġ��",
         "Gender":"M",
         "DeptName":"�λ�",
         "RetireDate":null
      }
   ]
}
*/



--*
--* 10.6.2. OPENJSON�� ����� JSON �����͸� ���̺� ���·� ��ȯ
--*


-- [�ҽ� 10-43] OPENJSON ��� ��

DECLARE @json NVARCHAR(MAX) = N'
{  
   "Employee":[  
      {  
         "EmpID":"S0005",
         "EmpName":"�����",
         "Gender":"M",
         "DeptName":"����",
         "RetireDate":"2015-01-31"
      },
      {  
         "EmpID":"S0006",
         "EmpName":"��ġ��",
         "Gender":"M",
         "DeptName":"�λ�"
      }
   ]
}'
SELECT *
	FROM OPENJSON(@json,'$.Employee')
	WITH(
		EmpID char(5),
		EmpName nvarchar(4),
		Gender char(1),
		DeptName nvarchar(10) ,
		RetireDate date
	)
GO



--*
--* 10.6.3. ��Ÿ ��ɵ�
--*


-- [�ҽ� 10-44] ISJSON �Լ� ��� ��

DECLARE @json NVARCHAR(MAX) = N'
{  
   "Employee":[  
      {  
         "EmpID":"S0005",
         "EmpName":"�����",
         "Gender":"M",
         "DeptName":"����",
         "RetireDate":"2015-01-31"
      },
      {  
         "EmpID":"S0006",
         "EmpName":"��ġ��",
         "Gender":"M",
         "DeptName":"�λ�"
      }
   ]
}'
 
IF ISJSON(@json) > 0
	PRINT N'JSON �¾ƿ�!'
ELSE
	PRINT N'JSON�� �ƴѰ� ���ƿ�!'
GO

-- ���
/*
JSON �¾ƿ�!
*/


-- [�ҽ� 10-45] JSON_VALUE �Լ� ��� ��

DECLARE @json NVARCHAR(MAX) = N'
{  
   "Employee":[  
      {  
         "EmpID":"S0005",
         "EmpName":"�����",
         "Gender":"M",
         "DeptName":"����",
         "RetireDate":"2015-01-31"
      },
      {  
         "EmpID":"S0006",
         "EmpName":"��ġ��",
         "Gender":"M",
         "DeptName":"�λ�"
      }
   ]
}'
SELECT JSON_VALUE(@json, '$.Employee[0].EmpName') 

-- ���
/*
�����
*/


-- [�ҽ� 10-46] JSON_QUERY ��� ��

DECLARE @json NVARCHAR(MAX) = N'
{  
   "Employee":[  
      {  
         "EmpID":"S0005",
         "EmpName":"�����",
         "Gender":"M",
         "DeptName":"����",
         "RetireDate":"2015-01-31"
      },
      {  
         "EmpID":"S0006",
         "EmpName":"��ġ��",
         "Gender":"M",
         "DeptName":"�λ�"
      }
   ]
}'
SELECT JSON_QUERY(@json, 'strict $.Employee[1]')
GO

-- ���
/*
{  
   "EmpID":"S0006",
   "EmpName":"��ġ��",
   "Gender":"M",
   "DeptName":"�λ�"
}
*/