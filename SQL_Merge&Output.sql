USE STD_DB

-- CTE 프로시저에서 이상한 점: 
-- 1. 같은 테이블을 UNION ALL 하는게 아니라, 다른 테이블을 한다...? CTE테이블과 TB_CMM_COMMENT 2개를 UNION
-- 2. 같은 컬럼인데 들어가는 데이터 형식이 다르다...?

-- Merge문에 DELETE 조건 주기
DECLARE @TST_SEQ INT = 38

Merge [dbo].[TB_TEST4] AS T2
    Using (
        select    *
        from    [dbo].[TB_TEST1]
        WHERE    TST_SEQ = @TST_SEQ
    ) AS T1
    ON (T2.T_SEQ = T1.TST_SEQ)
    WHEN Matched Then
        Update SET
            T2.T_ID        = T1.Delete_YN + '_' + T2.T_ID
            ,T2.T_EMAIL    = T1.Delete_YN + '_' + T2.T_Email
    WHEN Not Matched BY SOURCE
	-- DELETE 조건
	AND T2.T_SEQ IN (1) THEN
        DELETE;
        

SELECT * FROM TB_TEST1
SELECT * FROM TB_TEST4

-- OUTPUT문: TB_TEST4의 컬럼명이 맞아야 함
INSERT INTO TB_TEST1
   		OUTPUT inserted.TST_SEQ, inserted.Use_YN+'_ID' as T_ID, inserted.Using_YN+'_Email' as T_Email
   		INTO [dbo].[TB_TEST4] (T_SEQ, T_ID, T_Email)
    VALUES ('K', 'Y', 'U')

