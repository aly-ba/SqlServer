use veronicas
go

DELETE FROM [veronicas].[SALES].[Flowers]
      WHERE FlowerID in (512, 513, 514, 515, 516, 517, 518, 519)
GO
INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (512
           ,'oiría')
GO
  
INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (513
           ,'oiríamos')
GO
INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (514
           ,'oyes')
GO


INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (515
           ,'oye')
GO

INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (516
           ,'oímos')
GO

INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (517
           ,'oyen')
GO


INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (518
           ,'oís')
GO

INSERT INTO [veronicas].[SALES].[Flowers]
           ([FlowerID]
           ,[Description])
     VALUES
           (519
           ,'oír')
GO

select FlowerID, description from SALES.Flowers
where contains (Description, 'FORMSOF(INFLECTIONAL, oyes)', LANGUAGE N'spanish')