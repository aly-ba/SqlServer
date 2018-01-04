-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

CREATE PROCEDURE dbo.[CreateTempCategory]
AS -- Table variable created in a procedure

DECLARE @category TABLE
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);
GO

EXECUTE [dbo].[CreateTempCategory];

-- Does this work?
INSERT  @category
        ([category_no],
         [category_desc],
         [category_code])
        SELECT  [category_no],
                [category_desc],
                [category_code]
        FROM    [dbo].[category];
GO
 


-- Instead you could use table variables in procedures for
-- intermediate data set processing, for example, to avoid holding
-- resources on the permanent table
CREATE PROCEDURE dbo.[CreateTempCategory_v2]
AS -- Temporary table created in a procedure

DECLARE @category TABLE
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);

INSERT  @category
        ([category_no],
         [category_desc],
         [category_code])
        SELECT  [category_no],
                [category_desc],
                [category_code]
        FROM    [dbo].[category];

-- Other operations here

SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    @category;
GO


EXEC dbo.[CreateTempCategory_v2];
GO


-- What about views?
CREATE VIEW dbo.[TempCategory]
AS

DECLARE @category TABLE
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);

INSERT  @category
        ([category_no],
         [category_desc],
         [category_code])
        SELECT  [category_no],
                [category_desc],
                [category_code]
        FROM    [dbo].[category];

-- Other operations here

SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    @category;
GO


-- Table variables in triggers?
CREATE TRIGGER [trg_i_charge_demo] ON [dbo].[charge]
    AFTER INSERT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    SET NOCOUNT ON;

	DECLARE @charge_inserted_tmp TABLE
	([charge_no] INT);

	INSERT [@charge_inserted_tmp]
	        ([charge_no])
	SELECT [charge_no]
	FROM inserted;

	-- Placeholder
	-- Operations with #charge_inserted_tmp here

    UPDATE  [dbo].[charge]
    SET     [charge_dt] = GETDATE()
    FROM    [dbo].[charge] AS [c]
    INNER JOIN inserted AS [i]
            ON [c].[charge_no] = [i].[charge_no];

END
GO

-- Table variables in functions?
CREATE FUNCTION [dbo].[accounting_day_adjust] (@charge_dt DATETIME)
RETURNS INT
AS 
BEGIN

    DECLARE @charge_dt_day INT;

    DECLARE @AccountingDay TABLE
    (
     account_day DATETIME2 NOT NULL
    );

	 -- Placeholder processing here
	
    RETURN(@charge_dt_day);
END
GO


-- Cleanup
DROP PROCEDURE [dbo].[CreateTempCategory];
DROP PROCEDURE [dbo].[CreateTempCategory_v2];
DROP TRIGGER [dbo].[trg_i_charge_demo];
DROP FUNCTION [dbo].[accounting_day_adjust];
GO

