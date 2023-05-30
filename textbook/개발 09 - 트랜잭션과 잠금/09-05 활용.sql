--*
--* 9.5. Ȱ��
--*



--*
--* 9.5.1. ���� ��� ���� Ȯ��
--*


-- [�ҽ� 9-17] ���� ��� ���� Ȯ��

SELECT session_id AS [����ID],
	   wait_type AS [�������],
	   blocking_session_id AS [���ܼ���ID],
	   wait_time / 1000 AS [���ð�(��)],
	   st.text AS [������]
	FROM sys.dm_exec_requests AS er
	CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS st
	CROSS APPLY sys.dm_exec_query_plan(er.plan_handle) AS qp
	WHERE er.session_id > 50 AND er.wait_time > 1000 -- 1�� �̻� ����
GO



--*
--* 9.5.2. ���� ���� ����͸�
--*


-- [�ҽ� 9-18] 1222 ���� �÷��� Ȱ��ȭ

DBCC TRACEON(1222, -1)
GO


-- [�ҽ� 9-19] 1222 ���� �÷��� ��Ȱ��ȭ

DBCC TRACEOFF(1222, -1)
GO

