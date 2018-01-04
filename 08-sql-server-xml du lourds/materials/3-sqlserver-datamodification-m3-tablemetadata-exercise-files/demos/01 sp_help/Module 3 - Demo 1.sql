-- Module 3, Demo 1
-- Using sp_help

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

-- No input parameter sp_help
EXEC [dbo].[sp_help];

-- Evaluate the [Person].[Address] table
EXEC [dbo].[sp_help] N'[Person].[Address]';