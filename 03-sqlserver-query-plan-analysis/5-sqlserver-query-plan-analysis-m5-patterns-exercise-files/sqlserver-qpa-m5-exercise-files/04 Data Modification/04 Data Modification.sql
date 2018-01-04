USE Credit;
GO

-- Narrow plan updating provider_no...

-- provider_no dependencies:
--		NCI charge_provider_link
--		CLI ChargePK
--		Foreign Key reference to provider table
-- What does the Update operator tell us?
-- What do the properties tell us?
UPDATE dbo.charge
SET provider_no = 500
WHERE charge_no = 18;
GO

-- Show narrow plan in plan explorer

-- Wide plan
UPDATE dbo.charge
SET provider_no = 500
WHERE charge_no 
	BETWEEN 1 AND 10000;
GO

-- Cleanup

ALTER DATABASE Credit SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
