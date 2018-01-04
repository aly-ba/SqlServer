-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

CREATE TABLE #charge
(
 [charge_no] INT PRIMARY KEY CLUSTERED
                 IDENTITY(1, 1),
 [member_no] INT NOT NULL,
 [provider_no] INT NOT NULL,
 [category_no] INT NOT NULL,
 [charge_dt] [datetime] NOT NULL,
 [charge_amt] [money] NOT NULL,
 [statement_no] INT NOT NULL
                    UNIQUE NONCLUSTERED,
 [charge_code] CHAR(2) NOT NULL
);
GO

INSERT  #charge
        ([member_no],
         [provider_no],
         [category_no],
         [charge_dt],
         [charge_amt],
         [statement_no],
         [charge_code])
VALUES  (8842,
         484,
         2,
         GETDATE(),
         3263.00,
         28842,
         'CD');
GO

-- Indexes?
EXEC [tempdb].[sys].[sp_helpindex] #charge;
GO

-- Stats associated with the indexes?
USE [tempdb];
GO

DBCC SHOW_STATISTICS(#charge, 'PK__#charge___F3F53617DF3ADC74');
GO

-- Include the actual plan
SELECT  [member_no]
FROM    #charge
WHERE   [charge_no] = 1;
GO


-- What about columns not included in index keys?
-- Any statistics?
EXEC [tempdb].[sys].[sp_helpstats] #charge;
GO

-- Let's see after this query (auto-update stats enabled)
SELECT  [charge_no]
FROM    #charge
WHERE   [member_no] = 8842;
GO

-- Any statistics now?
EXEC [tempdb].[sys].[sp_helpstats] #charge;
GO

USE [tempdb];
GO

DBCC SHOW_STATISTICS(#charge, '_WA_Sys_00000002_B7BD0BAE');
GO

-- The story is different for table variables, as you'll see in the next module


-- Cleanup
DROP TABLE #charge;
GO