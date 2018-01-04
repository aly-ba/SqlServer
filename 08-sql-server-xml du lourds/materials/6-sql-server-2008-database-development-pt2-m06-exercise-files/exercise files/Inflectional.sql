use veronicas
go

DELETE FROM [veronicas].[SALES].[Flowers]
      WHERE FlowerID in (501, 502, 503, 504)
GO

INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (501
           ,'grows')
GO

INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (502
           ,'growing')
GO
INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (503
           ,'grew')
GO

INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (504
           ,'grow')
GO

select * from SALES.Flowers
where contains (Description, 'FORMSOF(INFLECTIONAL, grow)')



