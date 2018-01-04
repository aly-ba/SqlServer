/*============================================================================
  File:     lax_schema.sql

  Summary:  This script illustrates SQL Server 2008 support for xsd:Any data
			type with lax validation.

  Date:     August 2008

  SQL Server Version: 10.0.1600.22 (RTM)
------------------------------------------------------------------------------
  Written by Bob Beauchemin, SQLskills.com

  For more scripts and sample code, check out http://www.SQLskills.com
  
  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.
============================================================================*/
use tempdb
go

create xml schema collection lax_example
as
'<xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xs:element name="people">
		<xs:complexType>
			<xs:sequence>
				<xs:element maxOccurs="unbounded" name="person">
					<xs:complexType>
						<xs:sequence>
							<xs:element name="name">
								<xs:complexType>
									<xs:sequence>
										<xs:element name="givenName" type="xs:string" />
										<xs:element name="familyName" type="xs:string" />
									</xs:sequence>
								</xs:complexType>
							</xs:element>
							<xs:element name="age" type="xs:integer" />
							<xs:element name="height" type="xs:string" />
						</xs:sequence>
					</xs:complexType>
				</xs:element>
			</xs:sequence>
		</xs:complexType>
	</xs:element>
	
	<xs:element name="StrictPerson" >
		<xs:complexType >
			<xs:sequence>
				<xs:any processContents="strict" namespace="##any" />
			</xs:sequence>
		</xs:complexType>
	</xs:element>
	<xs:element name="SkipPerson" >
		<xs:complexType >
			<xs:sequence>
				<xs:any processContents="skip" namespace="##any" />
			</xs:sequence>
		</xs:complexType>
	</xs:element>
	<xs:element name="OpenPerson" >
		<xs:complexType >
			<xs:sequence>
				<xs:any processContents="lax" namespace="##any" />
			</xs:sequence>
		</xs:complexType>
	</xs:element>
</xs:schema>'
go

use tempdb
go

declare @x xml (lax_example) = '
<people >
      <person>
         <name>
           <givenName />
           <familyName />
         </name>
         <age >2008</age>
         <height >1.8</height>
       </person>
</people>
'
go

declare @x xml (lax_example) = 
'<people >
      <person>
         <name>
           <givenName />
           <familyName />
         </name>
         <age >foo</age>
         <height >1.8</height>
       </person>
   </people>
'
go

--Using the OpenPerson element we can add any sub element
--due to the lax validation
declare @x xml (lax_example) = '
<OpenPerson>
	<someRandomElement>
		<somethingelse />
	</someRandomElement>
</OpenPerson>'
go

declare @x xml (lax_example) = '
<StrictPerson>
	<someRandomElement>
		<somethingelse />
	</someRandomElement>
</StrictPerson>'
go

declare @x xml (lax_example) = '
<SkipPerson>
	<someRandomElement>
		<somethingelse />
	</someRandomElement>
</SkipPerson>'
go

--Highlights that use of an element that is in the schema the element
--still has to be schema valid
declare @x xml (lax_example) = '<OpenPerson><people ></people></OpenPerson>'
go
declare @x xml (lax_example) = '<StrictPerson><people ></people></StrictPerson>'
go
declare @x xml (lax_example) = '<SkipPerson><people ></people></SkipPerson>'
go

--With a complete element the xml validates
declare @x xml (lax_example) = 
'<OpenPerson>
   <people >
      <person>
         <name>
           <givenName />
           <familyName />
         </name>
         <age >2008</age>
         <height >1.8</height>
       </person>
   </people>
</OpenPerson>'
go

declare @x xml (lax_example) = 
'<StrictPerson>
   <people >
      <person>
         <name>
           <givenName />
           <familyName />
         </name>
         <age >2008</age>
         <height >1.8</height>
       </person>
   </people>
</StrictPerson>'
go

declare @x xml (lax_example) = 
'<SkipPerson>
   <people >
      <person>
         <name>
           <givenName />
           <familyName />
         </name>
         <age >foo</age>
         <height >1.8</height>
       </person>
   </people>
</SkipPerson>'
go

drop xml schema collection lax_example
go


