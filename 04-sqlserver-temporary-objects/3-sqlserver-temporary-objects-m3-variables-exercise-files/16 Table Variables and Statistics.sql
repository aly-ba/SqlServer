-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

-- SQL Server doesn't maintain column statistics for table variables

-- Let's compare two scenarios and estimates
-- Include the actual plan 

-- Scenario 1
DECLARE @charge TABLE
(
 [charge_no] INT PRIMARY KEY CLUSTERED
                 IDENTITY(1, 1),
 [member_no] INT NOT NULL,
 [provider_no] INT NOT NULL,
 [category_no] INT NOT NULL,
 [charge_dt] [datetime] NOT NULL,
 [charge_amt] [money] NOT NULL,
 [statement_no] INT NOT NULL,
 [charge_code] CHAR(2) NOT NULL
);

INSERT  @charge
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


-- Estimated rows?
SELECT  [charge_no]
FROM    @charge
WHERE   [member_no] = 8842;
GO



-- Scenario 2
DECLARE @charge TABLE
(
 [charge_no] INT PRIMARY KEY CLUSTERED
                 IDENTITY(1, 1),
 [member_no] INT NOT NULL,
 [provider_no] INT NOT NULL,
 [category_no] INT NOT NULL,
 [charge_dt] [datetime] NOT NULL,
 [charge_amt] [money] NOT NULL,
 [statement_no] INT NOT NULL,
 [charge_code] CHAR(2) NOT NULL
);

INSERT  @charge
        ([member_no],
         [provider_no],
         [category_no],
         [charge_dt],
         [charge_amt],
         [statement_no],
         [charge_code])
        SELECT  8842, -- hard-coding member_no
                [provider_no],
                [category_no],
                [charge_dt],
                [charge_amt],
                [statement_no],
                [charge_code]
        FROM    [dbo].[charge];


-- Include the actual plan 
-- Estimated rows?
-- Table cardinality?
SELECT  [charge_no]
FROM    @charge
WHERE   [member_no] = 8842;
GO


-- What if we RECOMPILE the SELECT statement?

DECLARE @charge TABLE
(
 [charge_no] INT PRIMARY KEY CLUSTERED
                 IDENTITY(1, 1),
 [member_no] INT NOT NULL,
 [provider_no] INT NOT NULL,
 [category_no] INT NOT NULL,
 [charge_dt] [datetime] NOT NULL,
 [charge_amt] [money] NOT NULL,
 [statement_no] INT NOT NULL,
 [charge_code] CHAR(2) NOT NULL
);

INSERT  @charge
        ([member_no],
         [provider_no],
         [category_no],
         [charge_dt],
         [charge_amt],
         [statement_no],
         [charge_code])
        SELECT  8842, -- hard-coding member_no
                [provider_no],
                [category_no],
                [charge_dt],
                [charge_amt],
                [statement_no],
                [charge_code]
        FROM    [dbo].[charge];


-- Include the actual plan 
-- Estimated rows?
-- Table cardinality?
SELECT  [charge_no]
FROM    @charge
WHERE   [member_no] = 8842
OPTION (RECOMPILE);
GO
