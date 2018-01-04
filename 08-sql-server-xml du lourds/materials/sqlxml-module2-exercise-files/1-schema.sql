use tempdb
go

create xml schema collection dbo.geocoll
as
'<xs:schema xmlns:xs=
  "http://www.w3.org/2001/XMLSchema"
  targetNamespace="urn:geo"
  xmlns:tns="urn:geo"
  elementFormDefault="qualified">
  <xs:simpleType name="dim">
    <xs:restriction base="xs:int"/>
  </xs:simpleType>
  <xs:complexType name="Point">
    <xs:sequence>
      <xs:element name="X"
        type="tns:dim"/>
      <xs:element name="Y"
        type="tns:dim"/>
    </xs:sequence>
  </xs:complexType>
  <xs:element name="Point"
    type="tns:Point"/>
</xs:schema>'
go

CREATE TABLE point_tab( 
 id int IDENTITY primary key,
 -- geocoll include schema for 'urn:geo'
 thepoint xml(geocoll)
)
GO

-- this works, schema-valid Point
INSERT INTO point_tab VALUES(
 '<Point xmlns="urn:geo"><X>10</X><Y>20</Y></Point>')

-- this insert fails, foo is not an integer
INSERT INTO point_tab VALUES(
 '<Point xmlns="urn:geo"><X>10</X><Y>foo</Y></Point>') 
 
-- check schema and collection metadata
SELECT * FROM sys.xml_schema_collections
SELECT * FROM sys.xml_schema_types
SELECT * FROM sys.column_xml_schema_collection_usages

-- can't drop XML schema collection 
drop table point_tab
drop xml schema collection geocoll

