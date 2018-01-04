USE Credit;
GO

-- Start by creating the procedure
CREATE PROCEDURE dbo.compile_happy
AS 
SET ANSI_NULLS OFF;

SELECT TOP 1
        *
FROM    dbo.category
OPTION  (RECOMPILE);

CREATE TABLE #T1 (col01 INT NOT NULL);

ALTER TABLE #T1
ADD col02 INT NOT NULL;

INSERT  #T1
VALUES  (1, 1);

SELECT  col01,
        col02
FROM    #T1;

INSERT  #T1
VALUES  (2, 2);

DROP TABLE #T1;

GO


-- 1) Open Extended Events and watch for recompile events
-- 1) Open Perfmon and watch compilations/recompilations        
-- 2) Launch workload

-- Deferred compile - object didn't exist at compile time                                                                                           