using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlTypes;
using System.Xml.Linq;

namespace LINQ2XMLlib
{
    public class Class1
    {
        [Microsoft.SqlServer.Server.SqlFunction ]   
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
