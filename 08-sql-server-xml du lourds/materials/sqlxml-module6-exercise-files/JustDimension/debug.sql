create database demo
go

use demo
go

CREATE TABLE Tiles ( 
Id INT PRIMARY KEY,
Length LDim,
Width LDim

)

INSERT INTO Tiles VALUES (1, '12.001 in', '0 in') 
INSERT INTO Tiles VALUES (10, '1.1 ft', '-1 in') 

SELECT CAST(Length AS VARCHAR(20)) AS Length,
CAST(Width AS VARCHAR(20)) AS Width, Length.Inches AS Inches,
CAST(Length as BINARY(5)),
ID FROM Tiles
ORDER BY Length


SELECT CAST(Length AS VARCHAR(20)) AS Length,
CAST(Width AS VARCHAR(20)) AS Width, Length.Inches AS Inches,
CAST(Length as BINARY(5)),
ID FROM Tiles
ORDER BY CAST(Length as BINARY(5))


DECLARE @d1 LDIM
DECLARE @d2 LDIM
SET @d1 = '1.1 ft'
SET @d2 = '12.001 in'
IF @d1 > @d2
PRINT '1.1 ft > 12.001 in'
ELSE
PRINT '1.1 ft < 12.001 in'
PRINT CAST(@d1 as VARCHAR(MAX))
PRINT CAST(@d2 as VARCHAR(MAX))




DROP TABLE Tiles
