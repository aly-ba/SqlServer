

USE tempdb
GO

DECLARE @xmlvar XML
SELECT @xmlvar










CREATE TABLE xmltab (xmlcol XML)
GO

INSERT xmltab VALUES('<person/>')
INSERT xmltab VALUES('<person></person>')
INSERT xmltab VALUES('<person name="bob" />')
INSERT xmltab VALUES('<person name=''mary'' />')
GO

SELECT * FROM xmltab
GO

-- character data sections
INSERT xmltab VALUES('<person><![CDATA[ Three is > two ]]></person>')

-- not retained by SQL Server, but entitized
SELECT * FROM xmltab
GO

-- varchar data type to be converted
-- must agree with encoding, if you specify one
INSERT xmltab VALUES('<?xml version="1.0" encoding="UTF-16" ?><person/>')
INSERT xmltab VALUES('<?xml version="1.0" encoding="UTF-8" ?><person/>')

-- These are all valid XML 
-- According to XQuery 1.0 data model

-- document
INSERT xmltab VALUES('<doc/')
-- fragment
INSERT xmltab VALUES('<doc/><doc/>')
-- Text only (atomic value)
INSERT xmltab VALUES('Text only')
-- empty string
INSERT xmltab VALUES('') 
-- SQL NULL
INSERT xmltab VALUES(NULL) 
-- Top-level attribute not allowed
DECLARE @x xml
SET @x = '<person name="bob"/>'
INSERT xmltab VALUES(@x.query('/person/@name'))

-- Namespaces
-- doc in no namespace
INSERT xmltab VALUES('<doc/>') 
-- doc from a namespace for doctors
INSERT xmltab VALUES('<doc xmlns="http://www.doctors.com" />')
-- doc from a namespace for documents
INSERT xmltab VALUES('<doc xmlns="http://www.documents.com" />')
-- namespace prefix, same as the previous document
INSERT xmltab VALUES('<dd:doc xmlns:dd="http://www.documents.com" />')
-- namespace prefix, same as the previous two documents
INSERT xmltab VALUES('<rr:doc xmlns:rr="http://www.documents.com" />')

-- which type of doc is this?
INSERT xmltab VALUES('
 <yy:doc xmlns:rr="http://www.documents.com" 
         xmlns:yy="http://www.doctors.com" />')
