using System; 
using System.Data.SqlTypes; 
using System.Xml; 
using System.Xml.XPath; 
using System.Xml.Xsl;

// Once the assembly is registered and a corresponding user-defined Transact-SQL function SqlXslTransform() corresponding to ApplyXslTransform() is created , the function can be invoked from Transact-SQL as in the following query:
//SELECT dbo.SqlXslTransform (xCol, 'C:\temp\xsltransform.xsl') 
//  FROM docs

public class TransformXml 
{ 
	public static SqlXml ApplyXslTransform (SqlXml XmlData, string xslPath) 
	{ 
		// Load XSL transformation 
		XslCompiledTransform xform = new XslCompiledTransform(); 
		xform.Load (xslPath); 
		
		// Load XML data 
		XPathDocument xDoc = new XPathDocument (XmlData.CreateReader()); 
		XPathNavigator nav = xDoc.CreateNavigator (); 
		
		// Apply the transformation 
		// using makes sure that we flush the writer at the end 
		using (XmlWriter writer = nav.AppendChild()) 
		{ 
			xform.Transform(XmlData.CreateReader(), writer); 
		} 
		
		// Return the transformed value 
		SqlXml retSqlXml = new SqlXml (nav.ReadSubtree()); 
		return (retSqlXml); 
	} 
}
