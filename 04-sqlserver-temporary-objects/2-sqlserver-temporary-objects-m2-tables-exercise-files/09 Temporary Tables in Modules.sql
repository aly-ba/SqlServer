-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

CREATE PROCEDURE [dbo].[CreateTempCategory]
AS -- Temporary table created in a procedure
CREATE TABLE #category
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);
GO

EXECUTE [dbo].[CreateTempCategory];
GO

-- Does this work?
INSERT  #category
        ([category_no],
         [category_desc],
         [category_code])
        SELECT  [category_no],
                [category_desc],
                [category_code]
        FROM    [dbo].[category];
GO
 


-- Instead you might typically use temp tables in procedures for
-- intermediate data set processing, for example, to avoid holding
-- resources on the permanent table
CREATE PROCEDURE [dbo].[CreateTempCategory_v2]
AS -- Temporary table created in a procedure

CREATE TABLE #category
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);

INSERT  #category
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
FROM    #category;
GO


EXEC [dbo].[CreateTempCategory_v2];
GO



-- You can also perform cross-procedure temporary table operations
CREATE PROCEDURE [dbo].[CreateAndPopulateCategory]
AS

CREATE TABLE #category
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);

-- Separating out population into separate module
EXECUTE [dbo].[PopulateCategory];
GO


CREATE PROCEDURE [dbo].[PopulateCategory]
AS

INSERT  #category
        ([category_no],
         [category_desc],
         [category_code])
        SELECT  [category_no],
                [category_desc],
                [category_code]
        FROM    [dbo].[category];

SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    #category;
GO

EXEC [dbo].[CreateAndPopulateCategory];
GO




-- What about views?
CREATE VIEW [dbo].[TempCategory]
AS

CREATE TABLE #category
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);

INSERT  #category
        ([category_no],
         [category_desc],
         [category_code])
        SELECT  [category_no],
                [category_desc],
                [category_code]
        FROM    [dbo].[category];

SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    #category;
GO


-- Temp tables in triggers?
CREATE TRIGGER [dbo].[trg_i_charge_demo] ON [dbo].[charge]
    AFTER INSERT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    SET NOCOUNT ON;

	CREATE TABLE #charge_inserted_tmp
	([charge_no] INT);

	INSERT [#charge_inserted_tmp]
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

-- Temporary tables in functions?
-- Here is an example of a scalar function attempt...
CREATE FUNCTION [dbo].[accounting_day_adjust] (@charge_dt DATETIME)
RETURNS INT
AS 
BEGIN

    DECLARE @charge_dt_day INT;

    CREATE TABLE #AccountingDay
    (
     account_day DATETIME2 NOT NULL
    );

	 -- Placeholder processing here
	
    RETURN(@charge_dt_day)
END
GO


-- Cleanup
DROP PROCEDURE [dbo].[CreateTempCategory];
DROP PROCEDURE [dbo].[CreateTempCategory_v2];
DROP PROCEDURE [dbo].[CreateAndPopulateCategory];
DROP PROCEDURE [dbo].[PopulateCategory];
DROP TRIGGER [dbo].[trg_i_charge_demo];
GO

