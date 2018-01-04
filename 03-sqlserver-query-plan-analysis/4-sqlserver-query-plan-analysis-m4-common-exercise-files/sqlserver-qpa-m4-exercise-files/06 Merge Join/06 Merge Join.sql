USE Credit;
GO

-- Looking at the indexes
-- member2.member2PK & member.member_ident
SELECT  [i].[name],
        [c].*
FROM    [sys].[indexes] i
INNER JOIN [sys].[index_columns] c
        ON [i].[index_id] = [c].[index_id] AND
           [i].[object_id] = [c].[object_id]
WHERE   [i].[object_id] IN (OBJECT_ID('member'), OBJECT_ID('member2')) AND
        [c].[column_id] = 1

-- Now let's join on member_no
-- Whats the join type and cost?
-- What indexes were used?
-- Many-to-many?
SELECT  [m1].[lastname],
        [m1].[firstname]
FROM    [dbo].[member] m1
INNER JOIN [dbo].[member2] m2
        ON [m1].[member_no] = [m2].[member_no];
