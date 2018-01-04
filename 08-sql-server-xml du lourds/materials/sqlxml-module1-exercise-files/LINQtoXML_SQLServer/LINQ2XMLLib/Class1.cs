using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlTypes;
using System.Xml.Linq;

/*============================================================================
  File:     Class1.cs

  Summary:  This is a .NET UDF to illustrate support for LINQ to XML in
	    SQL Server 2008.  
	    The SQLCLR function must be compiled and deployed first for the test
	    to work. Use Visual Studio's autodeploy feature after creating the 
	    database in this script.

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

namespace LINQ2XMLlib
{
    public class Class1
    {
        [Microsoft.SqlServer.Server.SqlFunction]   
        public static SqlXml MakeXML()
        {
            XElement srcTree = new XElement("Root",
                new XElement("Element", 1),
                new XElement("Element", 2),
                new XElement("Element", 3),
                new XElement("Element", 4),
                new XElement("Element", 5)
            );
            XElement xmlTree = new XElement("Root",
                new XElement("Child", 1),
                new XElement("Child", 2),
                from el in srcTree.Elements()
                where (int)el > 2
                select el
            );

            SqlXml sxml = new SqlXml(xmlTree.CreateReader());
            return sxml;

        }
    }
}
