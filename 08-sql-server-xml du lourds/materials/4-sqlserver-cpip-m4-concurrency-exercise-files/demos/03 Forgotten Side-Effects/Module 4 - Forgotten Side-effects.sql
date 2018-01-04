USE [Credit]
GO

-- Create our demo
CREATE TABLE [dbo].[charge_demo]
(
 [charge_no] [dbo].[numeric_id] NOT NULL
                                PRIMARY KEY CLUSTERED,
 [member_no] [dbo].[numeric_id] NOT NULL,
 [provider_no] [dbo].[numeric_id] NOT NULL,
 [category_no] [dbo].[numeric_id] NOT NULL,
 [charge_dt] [datetime] NOT NULL,
 [charge_amt] [money] NOT NULL,
 [statement_no] [dbo].[numeric_id] NOT NULL,
 [charge_code] [dbo].[status_code] NOT NULL,
 [insert_dt] [datetime] NULL
);
GO

-- Create our trigger to modify insert_dt
CREATE TRIGGER [trg_i_charge_demo] ON [dbo].[charge_demo]
    AFTER INSERT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    SET NOCOUNT ON;

    UPDATE  [dbo].[charge_demo]
    SET     [insert_dt] = GETDATE()
    FROM    [dbo].[charge_demo] AS [c]
    INNER JOIN inserted AS [i]
            ON [c].[charge_no] = [i].[charge_no];

END
GO

-- What is the I/O overhead?
SET STATISTICS IO ON;
SET NOCOUNT ON;
GO

INSERT  [dbo].[charge_demo]
        (charge_no,
         member_no,
         provider_no,
         category_no,
         charge_dt,
         charge_amt,
         statement_no,
         charge_code)
        SELECT TOP 300000
                charge_no,
                member_no,
                provider_no,
                category_no,
                charge_dt,
                charge_amt,
                statement_no,
                charge_code
        FROM    [dbo].[charge]
        ORDER BY charge_no;
GO

-- Now let's drop the trigger
DROP TRIGGER [dbo].[trg_i_charge_demo];
GO

-- Create a default constraint on insert_dt
ALTER TABLE [dbo].[charge_demo]
ADD CONSTRAINT [def_insert_dt]
DEFAULT (GETDATE())
FOR [insert_dt];
GO

-- Clear table
TRUNCATE TABLE [dbo].[charge_demo];
GO

INSERT  [dbo].[charge_demo]
        (charge_no,
         member_no,
         provider_no,
         category_no,
         charge_dt,
         charge_amt,
         statement_no,
         charge_code)
        SELECT TOP 300000
                charge_no,
                member_no,
                provider_no,
                category_no,
                charge_dt,
                charge_amt,
                statement_no,
                charge_code
        FROM    [dbo].[charge]
        ORDER BY charge_no;
GO

SELECT  insert_dt
FROM    [dbo].[charge_demo]

DROP TABLE [dbo].[charge_demo];
GO

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
SET NOCOUNT ON;
GO
