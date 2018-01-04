USE Credit;
GO

-- Index Scan + Predicate (NOT a seek predicate)
SELECT  [provider].[provider_no]
FROM    [dbo].[provider]
WHERE   [provider].[provider_name] = 'Prov. Famous Ne';

-- Now let's add an index on provider_name
CREATE NONCLUSTERED
INDEX provider_provider_name
ON [dbo].[provider](provider_name);
GO

-- Index Seek + Seek Predicate
SELECT  [provider].[provider_no]
FROM    [dbo].[provider]
WHERE   [provider].[provider_name] = 'Prov. Famous Ne';

-- Index Seek Predicate + Filter
-- Does it push down the filter?
SELECT  [provider].[region_no],
        COUNT(*)
FROM    [dbo].[provider]
WHERE   [provider].[region_no] IN (5, 6, 7)
GROUP BY [provider].[region_no]
HAVING  COUNT(*) > 30;
GO