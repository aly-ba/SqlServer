USE Credit;

DECLARE @charge_no INT = 1
WHILE @charge_no < 1001 
    BEGIN

        DECLARE @adhoc_text VARCHAR(MAX) = 'SELECT charge_no, member_no, provider_no, category_no, charge_dt, charge_amt, statement_no, charge_code, CHECKSUM(*), NEWID(), POWER(2, 10) FROM dbo.charge WHERE charge_no = ' +
            CAST (@charge_no AS VARCHAR(100))

        EXEC (@adhoc_text)

        SET @charge_no = @charge_no + 1

    END
 GO  

