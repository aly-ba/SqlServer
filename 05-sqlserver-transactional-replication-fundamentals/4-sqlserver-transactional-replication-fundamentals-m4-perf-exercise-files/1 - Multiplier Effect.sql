-- You can get the 2008 Credit sample database used in these demos 
-- from http://bit.ly/10fKpbS 


-- Stop the log reader and distribution agents first

:CONNECT SQL2K12-SVR1
USE [Credit];

UPDATE  dbo.[charge]
SET     [charge_amt] = [charge_amt] * .97
WHERE   [provider_no] = 386; 
GO

:CONNECT SQL2K12-SVR1
USE [Credit];
EXEC sp_replcmds;
GO

-- Start the log reader agent job

:CONNECT SQL2K12-SVR2
USE [distribution];
EXEC sp_browsereplcmds '0x00000023000012280001'
GO
