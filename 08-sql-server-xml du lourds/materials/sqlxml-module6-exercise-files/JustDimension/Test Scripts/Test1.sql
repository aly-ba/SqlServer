DECLARE @d Ldim
SET @d = '2 ft'
DECLARE @x xml
SET @x = CAST(@d AS xml)
SELECT @x 
SET @d = CAST(@x as LDim)
SELECT CAST(@d as VARCHAR(MAX))


