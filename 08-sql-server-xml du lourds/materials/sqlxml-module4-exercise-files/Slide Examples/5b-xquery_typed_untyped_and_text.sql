

/*
Untyped XML and XPath expressions with the text() node test. text() works 
just fine when using untyped XML, but fails against typed XML with simple content. 
*/


CREATE XML SCHEMA COLLECTION root AS
'<xs:schema
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   targetNamespace="urn:geo">
<xs:element name="Root" type="xs:string"/>
</xs:schema>
'
GO

-- UNTYPED
-- this works
DECLARE @x  xml
set @x = '<g:Root xmlns:g="urn:geo">asdf</g:Root>'
select @x.query('
 declare namespace g="urn:geo";
 /g:Root/text()')

-- TYPED
-- Msg 9312, Level 16, State 1, Line 4
-- XQuery [query()]: 'text()' is not supported on simple typed 
-- or 'http://www.w3.org/2001/XMLSchema#anyType' elements, 
-- found 'element(g{urn:geo}:Root,xs:string) *'.

DECLARE @x  xml(root)
-- same document
set @x = '<g:Root xmlns:g="urn:geo">asdf</g:Root>'
select @x.query('declare namespace g="urn:geo";
/g:Root[1]/text()')

-- But why? Isn't text() a node test that returns the value of a text() node. 
declare @x xml(root)
set @x = '<g:Root xmlns:g="urn:geo">asdf</g:Root>'
select @x.query('declare namespace g="urn:geo";
data(/g:Root[1])')


/*
Now that we know the rules, let's try them out:

Data(),text() and string() accessors

XQuery has a function fn:data() to extract scalar, typed values from nodes, 
a node test text() to return text nodes, and the function fn:string() 
that returns the string value of a node. Their usages are sometimes confusing. 
Guidelines for their proper use in SQL Server 2005 are as follows. 
Consider the XML instance <age>12</age>. 

Untyped XML: The path expression /age/text() returns the text node "12". 
The function fn:data(/age) returns the string value "12" and so does fn:string(/age).

Typed XML: The expression /age/text() returns static error 
for any simple typed <age> element. On the other hand, 
fn:data(/age) returns integer 12, while fn:string(/age) yields the string "12".
*/

-- Try this:

DECLARE @x xml
SET @x = '<age>12</age>'
-- works as expected
SELECT @x.query('data(/age)')
GO

DECLARE @x xml
SET @x = '<age>12</age>'
-- fails
-- Msg 2211, Level 16, State 1, Line 6
-- XQuery [query()]: Singleton (or empty sequence) required, found operand of type 'element(age,xdt:untypedAny) *'
SELECT @x.query('string(/age)')
GO

/*
It turns out that XQuery functions are strongly typed also. Here's the definition of fn:string and fn:data:

fn:string($arg as item()?) as xs:string

fn:data($arg as item()*) as xdt:anyAtomicType*

The "item()*" means that data takes a sequence of 0-n items. "item()?" means that string only takes a sequence of 0-1 item. Let's fix it then.
*/

DECLARE @x xml
SET @x = '<age>12</age>'
SELECT @x.query('string(/age[1])')
GO

-- Let's try this with typed XML.

-- start with a schema collection

CREATE XML SCHEMA COLLECTION ages AS
'<xs:schema
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   targetNamespace="urn:ages">
<xs:element name="age" type="xs:int"/>
</xs:schema>
'
GO

DECLARE @x xml(ages)
SET @x = '<age xmlns="urn:ages">12</age>'
-- fails as expected
SELECT @x.query('
declare default element namespace "urn:ages";
/age/text()')
GO

DECLARE @x xml(ages)
SET @x = '<age xmlns="urn:ages">12</age>'
-- works as expected
SELECT @x.query('
declare default element namespace "urn:ages";
data(/age)')
GO

DECLARE @x xml(ages)
SET @x = '<age xmlns="urn:ages">12</age>'
-- fails ??!
SELECT @x.query('
declare default element namespace "urn:ages";
string(/age)')
GO

/*
Why does the last query (against strongly typed XML) fail, even though 
there is a schema? How can you fix it? 
*/

DECLARE @x xml(document ages)
SET @x = '<age xmlns="urn:ages">12</age>'
-- fails ??!
SELECT @x.query('
declare default element namespace "urn:ages";
string(/age)')
GO

/*
I guess I can never use text() as a node test with typed XML again. Not so. 
The error message reads: 'text()' is not supported on simple typed 
or 'http://www.w3.org/2001/XMLSchema#anyType' elements. So what's left? 
Mixed content, for one thing. Mixed content consists of a mixture 
of text and also embedded subelements.

If we change the schema to allow mixed content (this schema also allows a particular subelement):
*/

CREATE XML SCHEMA COLLECTION mixedage AS
'<xs:schema
xmlns:xs="http://www.w3.org/2001/XMLSchema"
targetNamespace="urn:ages"
xmlns:tns="urn:ages">
  <xs:complexType name="age" mixed="true">
    <xs:complexContent mixed="true">
      <xs:restriction base="xs:anyType">
         <xs:sequence>
           <xs:element name="dogyears" type="xs:int"/>
         </xs:sequence>
      </xs:restriction>
    </xs:complexContent>
  </xs:complexType>

<xs:element name="age" type="tns:age"/>
</xs:schema>
'

-- Then the text() node test works with typed XML just fine:

DECLARE @x xml(mixedage)
SET @x = '
<ag:age xmlns:ag="urn:ages">This is the age in dog years<dogyears>3</dogyears></ag:age>'
-- now it works OK
SELECT @x.query('
declare default element namespace "urn:ages";
/age/text()')
GO

-- the data() function fails against complex content
DECLARE @x xml(mixedage)
SET @x = '
<ag:age xmlns:ag="urn:ages">This is the age in dog years<dogyears>3</dogyears></ag:age>'
SELECT @x.query('
declare default element namespace "urn:ages";
data(/age)')
GO

-- But not when you specify the text() portion only
DECLARE @x xml(mixedage)
SET @x = '
<ag:age xmlns:ag="urn:ages">This is the age in dog years<dogyears>3</dogyears></ag:age>'
-- now it works OK
SELECT @x.query('
declare default element namespace "urn:ages";
data(/age/text())')
GO

-- or if the complex node is untyped
DECLARE @x xml
SET @x = '
<ag:age xmlns:ag="urn:ages">This is the age in dog years<dogyears>3</dogyears></ag:age>'
-- now it works OK
SELECT @x.query('
declare default element namespace "urn:ages";
data(/age)
')
GO




