-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO


-- Let's compare TRUNCATE options between temporary tables and table variables
CREATE TABLE #charge
(
 [charge_no] INT NOT NULL,
 [member_no] INT NOT NULL,
 [provider_no] INT NOT NULL,
 [category_no] INT NOT NULL,
 [charge_dt] [datetime] NOT NULL,
 [charge_amt] [money] NOT NULL,
 [statement_no] INT NOT NULL,
 [charge_code] CHAR(2) NOT NULL);

CREATE TABLE #charge_v2
(
 [charge_no] INT NOT NULL,
 [member_no] INT NOT NULL,
 [provider_no] INT NOT NULL,
 [category_no] INT NOT NULL,
 [charge_dt] [datetime] NOT NULL,
 [charge_amt] [money] NOT NULL,
 [statement_no] INT NOT NULL,
 [charge_code] CHAR(2) NOT NULL);

INSERT  #charge
        ([charge_no],
		 [member_no],
         [provider_no],
         [category_no],
         [charge_dt],
         [charge_amt],
         [statement_no],
         [charge_code])
        SELECT  [charge_no],
				[member_no],
                [provider_no],
                [category_no],
                [charge_dt],
                [charge_amt],
                [statement_no],
                [charge_code]
        FROM    [dbo].[charge];

INSERT  #charge_v2
        ([charge_no],
		 [member_no],
         [provider_no],
         [category_no],
         [charge_dt],
         [charge_amt],
         [statement_no],
         [charge_code])
        SELECT  [charge_no],
				[member_no],
                [provider_no],
                [category_no],
                [charge_dt],
                [charge_amt],
                [statement_no],
                [charge_code]
        FROM    [dbo].[charge];
GO


-- Enable "Include Client Statistics"
DELETE #charge;
GO

TRUNCATE TABLE #charge_v2;
GO

-- But can we leverage this for table variables?
DECLARE @charge TABLE 
(
 [charge_no] INT NOT NULL,
 [member_no] INT NOT NULL,
 [provider_no] INT NOT NULL,
 [category_no] INT NOT NULL,
 [charge_dt] [datetime] NOT NULL,
 [charge_amt] [money] NOT NULL,
 [statement_no] INT NOT NULL,
 [charge_code] CHAR(2) NOT NULL);

DECLARE @charge_v2 TABLE 
(
 [charge_no] INT NOT NULL,
 [member_no] INT NOT NULL,
 [provider_no] INT NOT NULL,
 [category_no] INT NOT NULL,
 [charge_dt] [datetime] NOT NULL,
 [charge_amt] [money] NOT NULL,
 [statement_no] INT NOT NULL,
 [charge_code] CHAR(2) NOT NULL);

INSERT  @charge
        ([charge_no],
		 [member_no],
         [provider_no],
         [category_no],
         [charge_dt],
         [charge_amt],
         [statement_no],
         [charge_code])
        SELECT  [charge_no],
				[member_no],
                [provider_no],
                [category_no],
                [charge_dt],
                [charge_amt],
                [statement_no],
                [charge_code]
        FROM    [dbo].[charge];

INSERT  @charge_v2
        ([charge_no],
		 [member_no],
         [provider_no],
         [category_no],
         [charge_dt],
         [charge_amt],
         [statement_no],
         [charge_code])
        SELECT  [charge_no],
				[member_no],
                [provider_no],
                [category_no],
                [charge_dt],
                [charge_amt],
                [statement_no],
                [charge_code]
        FROM    [dbo].[charge];

DELETE @charge;

TRUNCATE TABLE @charge_v2;
GO





-- Cleanup
DROP TABLE #charge;
DROP TABLE #charge_v2;
GO