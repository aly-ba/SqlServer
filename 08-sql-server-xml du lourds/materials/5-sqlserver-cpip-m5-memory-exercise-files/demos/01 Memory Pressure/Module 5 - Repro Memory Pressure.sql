-- Set max server memory to a lower value
EXEC [sys].[sp_configure] 'max server memory (MB)', 500
RECONFIGURE;
GO


USE [Credit];
GO

WHILE 1 = 1 
    BEGIN
	
        SELECT  [member].[member_no],
                [member].[lastname],
                [payment].[payment_no],
                [payment].[payment_dt],
                [payment].[payment_amt]
        FROM    [dbo].[payment]
        INNER HASH JOIN [dbo].[member]
                ON [member].[member_no] = [payment].[member_no]
        OPTION  (FORCE ORDER);

        SELECT  [c1].[charge_no],
                [c1].[category_no],
                [c1].[charge_dt],
                [c1].[member_no],
                [c1].[charge_amt]
        FROM    [dbo].[charge] c1
        WHERE   [c1].[charge_amt] > (SELECT AVG([c2].[charge_amt])
                                 FROM   [dbo].[charge] c2
                                 WHERE  [c2].[charge_dt] < [c1].[charge_dt]) AND
                [c1].[member_no] = 9620 AND
                [c1].[category_no] IN (2, 3)
        OPTION  (MAXDOP 1, RECOMPILE)

        UPDATE  [dbo].[payment]
        SET     [payment].[payment_amt] = 4193.00
        WHERE   [payment].[member_no] = 104;

        UPDATE  [dbo].[member]
        SET     [member].[lastname] = 'Zuckerton'
        WHERE   [member].[member_no] = 104;
    END
GO