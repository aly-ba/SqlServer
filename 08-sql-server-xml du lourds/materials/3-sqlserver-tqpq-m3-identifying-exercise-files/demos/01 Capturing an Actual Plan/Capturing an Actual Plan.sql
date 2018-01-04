USE [Credit];
GO

-- Display Estimated Graphical Showplan
SELECT  [member_no],
        [lastname],
        [firstname],
        [region_no],
        [region_name]
FROM    [dbo].[charge_wide]
WHERE   [member_no] = 9939;

-- Display Actual Graphical Showplan
SELECT  [member_no],
        [lastname],
        [firstname],
        [region_no],
        [region_name]
FROM    [dbo].[charge_wide]
WHERE   [member_no] = 9939;

-- Flip to XML plan from Graphical (turn off actual)

-- XML Showplan Estimated
SET SHOWPLAN_XML ON;
GO

SELECT  [member_no],
        [lastname],
        [firstname],
        [region_no],
        [region_name]
FROM    [dbo].[charge_wide]
WHERE   [member_no] = 9939;
GO

SET SHOWPLAN_XML OFF;
GO

-- XML Showplan Actual
SET STATISTICS XML ON;
GO

SELECT  [member_no],
        [lastname],
        [firstname],
        [region_no],
        [region_name]
FROM    [dbo].[charge_wide]
WHERE   [member_no] = 9939;
GO

SET STATISTICS XML OFF;
GO
