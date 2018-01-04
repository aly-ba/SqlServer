-- Module 7, Demo 8
-- Error Handling 

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- Data modification for missing row
BEGIN TRY

    SET XACT_ABORT ON;

    BEGIN TRANSACTION
    
    UPDATE  [Sales].[SpecialOffer]
    SET     [Description] = 'Mountain Tire 2-for-1',
		    [ModifiedDate] = GETDATE()
    WHERE   [SpecialOfferID] = 17;

    IF @@ROWCOUNT = 0 
        BEGIN
            RAISERROR ('Row no longer exists',
				16, -- Severity
				 1 -- State
				);
        END
	
    COMMIT TRANSACTION

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0 
	BEGIN
        ROLLBACK TRANSACTION
    END      

    SELECT  ERROR_MESSAGE() AS [ErrorMessage];
    
END CATCH
GO

-- Data modification for existing row
BEGIN TRY

    SET XACT_ABORT ON;

    BEGIN TRANSACTION
    
    UPDATE  [Sales].[SpecialOffer]
    SET     [Description] = 'Mountain Tire 2-for-1',
			[ModifiedDate] = GETDATE()
    WHERE   [SpecialOfferID] = 16;

    IF @@ROWCOUNT = 0 
        BEGIN
            RAISERROR ('Row no longer exists',
				16, -- Severity
				 1 -- State
				);
        END
	
    COMMIT TRANSACTION

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0 
	BEGIN
        ROLLBACK TRANSACTION
    END      

    SELECT  ERROR_MESSAGE() AS [ErrorMessage];
    
END CATCH
GO
