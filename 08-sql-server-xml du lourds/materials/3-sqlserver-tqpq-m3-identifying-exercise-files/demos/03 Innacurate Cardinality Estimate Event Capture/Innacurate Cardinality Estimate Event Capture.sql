CREATE EVENT SESSION [Track_CE_Issues] ON SERVER ADD EVENT sqlserver.
    inaccurate_cardinality_estimate ADD TARGET package0. ring_buffer WITH (STARTUP_STATE=
    ON);
GO

ALTER EVENT SESSION [Track_CE_Issues] ON SERVER STATE=START;
GO

-- Open "Watch Live Data" pane

-- Not in produciton, without good reason
DBCC FREEPROCCACHE;
GO

-- This event has "observer overhead" - so don't keep this running long!
USE [Credit];
GO

DECLARE @Column INT = 2,
    @Value INT = 10;

SELECT  [member].[member_no],
        [member].[street],
        [member].[city],
        [charge].[charge_no],
        [charge].[provider_no],
        [charge].[category_no],
        [charge].[charge_dt],
        [charge].[charge_amt],
        [charge].[charge_code]
FROM    [dbo].[charge]
INNER JOIN [dbo].[member]
        ON [member].[member_no] = [charge].[member_no]
WHERE   CHOOSE(@Column, [charge].[provider_no], [charge].[category_no]) = @Value;
GO


-- Don't forget to turn it off
ALTER EVENT SESSION [Track_CE_Issues] ON SERVER STATE=STOP;
GO
