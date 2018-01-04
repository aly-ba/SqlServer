use veronicas
go

DELETE FROM [veronicas].[SALES].[Flowers]
      WHERE FlowerID in (505, 506, 507, 508, 509, 510, 511)
GO

INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (505
           ,'caminando')
GO

INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (506
           ,'caminaste')
GO
INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (507
           ,'camina')
GO

INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (508
           ,'camino')
GO

INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (509
           ,'caminares')
GO

INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (510
           ,'caminares')
GO


INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (511
           ,'caminaríamos')
GO




select FlowerID, description from SALES.Flowers
where contains (Description, 'FORMSOF(INFLECTIONAL, caminar)', LANGUAGE N'spanish')



