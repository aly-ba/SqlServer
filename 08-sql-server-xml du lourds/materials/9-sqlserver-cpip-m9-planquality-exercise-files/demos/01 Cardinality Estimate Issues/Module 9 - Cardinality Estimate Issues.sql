USE [Credit];
GO

UPDATE  [dbo].[member]
SET     [city] = 'Minneapolis',
        [state_prov] = 'MN'
WHERE   [member_no] % 10 = 0;

UPDATE  [dbo].[member]
SET     [city] = 'New York',
        [state_prov] = 'NY'
WHERE   [member_no] % 10 = 1;

UPDATE  [dbo].[member]
SET     [city] = 'Chicago',
        [state_prov] = 'IL'
WHERE   [member_no] % 10 = 2;

UPDATE  [dbo].[member]
SET     [city] = 'Houston',
        [state_prov] = 'TX'
WHERE   [member_no] % 10 = 3;

UPDATE  [dbo].[member]
SET     [city] = 'Philadelphia',
        [state_prov] = 'PA'
WHERE   [member_no] % 10 = 4;

UPDATE  [dbo].[member]
SET     [city] = 'Phoenix',
        [state_prov] = 'AZ'
WHERE   [member_no] % 10 = 5;

UPDATE  [dbo].[member]
SET     [city] = 'San Antonio',
        [state_prov] = 'TX'
WHERE   [member_no] % 10 = 6;

UPDATE  [dbo].[member]
SET     [city] = 'San Diego',
        [state_prov] = 'CA'
WHERE   [member_no] % 10 = 7;

UPDATE  [dbo].[member]
SET     [city] = 'Dallas',
        [state_prov] = 'TX'
WHERE   [member_no] % 10 = 8;
GO

-- Estimation with just Minneapolis?
SELECT  [lastname],
        [firstname]
FROM    [dbo].[member]
WHERE   [city] = 'Minneapolis';
GO

-- Minneapolis and Minnesota?
SELECT  [lastname],
        [firstname]
FROM    [dbo].[member]
WHERE   [city] = 'Minneapolis' AND
        [state_prov] = 'MN'
OPTION  (RECOMPILE);
GO

-- Create multi-column stats
CREATE STATISTICS [member_city_state_prov]
ON [dbo].[member]([city],[state_prov]);
GO

-- Now what is the estimate?
SELECT  [lastname],
        [firstname]
FROM    [dbo].[member]
WHERE   [city] = 'Minneapolis' AND
        [state_prov] = 'MN'
OPTION  (RECOMPILE);
GO

-- Remove stats
DROP STATISTICS  [dbo].[member].[member_city_state_prov];
GO

-- Now what is the estimate?
SELECT  [lastname],
        [firstname]
FROM    [dbo].[member]
WHERE   [city] = 'Minneapolis' AND
        [state_prov] = 'MN'
OPTION  (RECOMPILE);
GO

-- Indexes work as well
CREATE INDEX [member_city_state_prov]
ON [dbo].[member]([city],[state_prov]);
GO

-- Now what is the estimate?
SELECT  [lastname],
        [firstname]
FROM    [dbo].[member]
WHERE   [city] = 'Minneapolis' AND
        [state_prov] = 'MN'
OPTION  (RECOMPILE);
GO


-- Cleanup
DROP INDEX  [dbo].[member].[member_city_state_prov];
GO
