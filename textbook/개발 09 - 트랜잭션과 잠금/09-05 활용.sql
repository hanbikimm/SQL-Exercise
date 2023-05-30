--*
--* 9.5. 활용
--*



--*
--* 9.5.1. 현재 잠금 정보 확인
--*


-- [소스 9-17] 현재 잠금 정보 확인

SELECT session_id AS [세선ID],
	   wait_type AS [대기유형],
	   blocking_session_id AS [차단세션ID],
	   wait_time / 1000 AS [대기시간(초)],
	   st.text AS [쿼리문]
	FROM sys.dm_exec_requests AS er
	CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS st
	CROSS APPLY sys.dm_exec_query_plan(er.plan_handle) AS qp
	WHERE er.session_id > 50 AND er.wait_time > 1000 -- 1초 이상 차단
GO



--*
--* 9.5.2. 교착 상태 모니터링
--*


-- [소스 9-18] 1222 추적 플래그 활성화

DBCC TRACEON(1222, -1)
GO


-- [소스 9-19] 1222 추적 플래그 비활성화

DBCC TRACEOFF(1222, -1)
GO

