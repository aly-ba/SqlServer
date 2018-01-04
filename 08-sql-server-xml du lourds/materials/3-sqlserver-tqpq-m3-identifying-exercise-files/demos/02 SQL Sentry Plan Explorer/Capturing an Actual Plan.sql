USE [Credit];
GO

-- Display Actual Graphical Showplan
SELECT  [member_no],
        [lastname],
        [firstname],
        [region_no],
        [region_name]
FROM    [dbo].[charge_wide]
WHERE   [member_no] = 9939;

-- Flip to Plan Explorer from Graphical Showplan
-- Save the .sqlplan, open from Plan Explorer