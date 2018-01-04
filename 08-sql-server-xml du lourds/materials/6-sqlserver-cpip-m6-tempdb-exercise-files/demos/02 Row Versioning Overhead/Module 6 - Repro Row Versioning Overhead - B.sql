USE master;
GO


ALTER DATABASE [Credit]
SET READ_COMMITTED_SNAPSHOT ON;
GO

USE Credit;
GO

SET NOCOUNT ON;
GO


WHILE 1 = 1 
    BEGIN

        SELECT  [charge].[charge_no],
                [charge].[charge_dt]
        FROM    [dbo].[charge];

    END 
GO