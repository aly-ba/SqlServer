-- Module 7, Demo 7
-- Explicit Transactions

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- Data modification for missing row
BEGIN TRANSACTION

UPDATE  [Sales].[SpecialOffer]
SET     [Description] = 'Mountain Tire 2-for-1' ,
        [ModifiedDate] = GETDATE()
WHERE   [SpecialOfferID] = 17;

IF @@ROWCOUNT = 0 
    BEGIN
        ROLLBACK TRANSACTION
        RAISERROR ('Row no longer exists',
            16, -- Severity
             1 -- State
            );
    END
ELSE 
    BEGIN
        COMMIT TRANSACTION
    END
GO

-- Data modification for row that exists
BEGIN TRANSACTION

UPDATE  [Sales].[SpecialOffer]
SET     [Description] = 'Mountain Tire 2-for-1' ,
        [ModifiedDate] = GETDATE()
WHERE   [SpecialOfferID] = 16;

IF @@ROWCOUNT = 0 
    BEGIN
        ROLLBACK TRANSACTION
        RAISERROR ('Row no longer exists',
            16, -- Severity
             1 -- State
            );
    END
ELSE 
    BEGIN
        COMMIT TRANSACTION
    END
GO


