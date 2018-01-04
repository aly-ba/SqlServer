#region Using directives

using System;
using System.Web;
using System.Web.Services;
using System.Xml;
using System.Xml.Schema;
using System.Xml.Serialization;

#endregion

namespace SqlSoapHeader
{
	/// <summary>
	/// This is a sample implementation of the SQL 2005 Security SOAP Header in the SOAP 1.1 format.
	/// This class inherites from SoapHeader as all SOAP Header classes need to do.  
	/// This class also implements the IXmlSerializable so the client can control the XML serialization format.
	/// This class is meant to be used as a SOAP header only.
	/// </summary>
    //[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd", IncludeInSchema = true)]
    //[System.Xml.Serialization.XmlRootAttribute(Namespace = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd", ElementName = "wsse:Security")]
    public class Security : System.Web.Services.Protocols.SoapHeader, System.Xml.Serialization.IXmlSerializable
	{

		// private member variables to hold the user input values.
		private String WssePassword;
		private String SqlOldPassword;
		private String WsseUsername;

		// the set of string const that is required for serialization.
		private const String strxmlns = "xmlns";
		private const String strsqlns = "http://schemas.microsoft.com/sqlserver/2004/SOAP";
		private const String strwssens = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd";
		private const String strsql = "sql";
		private const String strwsse = "wsse";
		private const String strUsernameToken = "UsernameToken";
		private const String strUsername = "Username";
		private const String strPassword = "Password";
        private const String strType = "Type";
        private const String strPasswordText = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText";
		private const String strOldPassword = "OldPassword";

        public Security()
		{
			// setting default values
			this.WssePassword = null;
			this.SqlOldPassword = null;
			this.WsseUsername = null;
		}

		// IXmlSerializable methods
		public XmlSchema GetSchema()
		{
			// VS.Net 2003 requires an ID value for the XmlSchema
			// This is the minimum implementation required for this method.
			// Note: this method is not really used anywhere.
			XmlSchema _xmlSchema = new XmlSchema();
			_xmlSchema.Id = "Sql 2005";
			return _xmlSchema;
		}

		public void ReadXml(XmlReader reader)
		{
			// not implemented
		}

		public void WriteXml(XmlWriter writer)
		{
			// The SOAP header serialization context to passed to this method after the class name element
			// node has been opened (ie. WriteStartElement("Security"))

			// Writing additional attributes to the "Security" element
			// xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"
			// xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"
			writer.WriteAttributeString(strxmlns, strwsse, null, strwssens);
			//writer.WriteAttributeString(strxmlns, strwssens);

			// check for SOAP header specific attributes
			if (this.MustUnderstand)
			{
				writer.WriteAttributeString("mustUnderstand", "http://schemas.xmlsoap.org/soap/envelope/", this.EncodedMustUnderstand);
			}
			if ((null != this.Actor) && ("" != this.Actor))
			{
				writer.WriteAttributeString("actor", "http://schemas.xmlsoap.org/soap/envelope/", this.Actor);
			}

			// <wsse:UsernameToken>
			writer.WriteStartElement(strwsse, strUsernameToken, strwssens);

			// <wsse:Username></wsse:Username>
			writer.WriteStartElement(strwsse, strUsername, strwssens);
			if (null == this.WsseUsername)
				writer.WriteAttributeString("xsi", "nil", "http://www.w3.org/2001/XMLSchema-instance", "true");
			else
				writer.WriteString(this.WsseUsername);
			writer.WriteEndElement();

			// <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText"></wsse:Password>
			writer.WriteStartElement(strwsse, strPassword, strwssens);
			writer.WriteAttributeString(strType, strPasswordText);
 
            if (null == this.WssePassword)
				writer.WriteAttributeString("xsi", "nil", "http://www.w3.org/2001/XMLSchema-instance", "true");
			else
				writer.WriteString(this.WssePassword);
			writer.WriteEndElement();

			// xmlns:sql="http://schemas.microsoft.com/sqlserver/2004/SOAP"
			// <sql:OldPassword Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">pass-word1</sql:OldPassword>
			if (null != this.SqlOldPassword)
			{
				writer.WriteStartElement(strsql, strOldPassword, strsqlns);
				writer.WriteAttributeString(strxmlns, strsql, null, strsqlns);
				writer.WriteAttributeString(strType, strPasswordText);

                writer.WriteString(this.SqlOldPassword);
				writer.WriteEndElement();
			}

			//</wsse:UsernameToken>
			writer.WriteEndElement();
		}

		// Property accessors
		public String Password
		{
			get
			{
				return this.WssePassword;
			}
			set
			{
				this.WssePassword = value;
			}
		}

		public String OldPassword
		{
			get
			{
				return this.SqlOldPassword;
			}
			set
			{
				this.SqlOldPassword = value;
			}
		}

		public String Username
		{
			get
			{
				return this.WsseUsername;
			}
			set
			{
				this.WsseUsername = value;
			}
		}
	} // end of public class Security


	/// <summary>
	/// This is a sample implementation of the SQL 2005 initialDatabase SQL options SOAP Header.
	/// This sample code is generated by taking the schema definition from the WSDL and running through the 
	/// .Net Frameworks SDK "xsd.exe" tool.
	/// </summary>
	[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options")]
	[System.Xml.Serialization.XmlRootAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options", IsNullable = false)]
	public class initialDatabase : System.Web.Services.Protocols.SoapHeader
	{

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		public string value;

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		[System.ComponentModel.DefaultValueAttribute(false)]
		public bool optional = false;

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		public string filename;
	} // end of public class initialDatabase


	/// <summary>
	/// This is a sample implementation of the SQL 2005 initialLanguage SQL options SOAP Header.
	/// This sample code is generated by taking the schema definition from the WSDL and running through the 
	/// .Net Frameworks SDK "xsd.exe" tool.
	/// </summary>
	[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options")]
	[System.Xml.Serialization.XmlRootAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options", IsNullable = false)]
	public class initialLanguage : System.Web.Services.Protocols.SoapHeader
	{

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		public string value;

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		[System.ComponentModel.DefaultValueAttribute(false)]
		public bool optional = false;
	} // end of public class initialLanguage


	/// <summary>
	/// This is a sample implementation of the SQL 2005 environmentChangeNotifications SQL options SOAP Header.
	/// This sample code is generated by taking the schema definition from the WSDL and running through the 
	/// .Net Frameworks SDK "xsd.exe" tool.
	/// </summary>
	[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options")]
	[System.Xml.Serialization.XmlRootAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options", IsNullable = false)]
	public class environmentChangeNotifications : System.Web.Services.Protocols.SoapHeader
	{

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		[System.ComponentModel.DefaultValueAttribute(false)]
		public bool databaseChange = false;

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		[System.ComponentModel.DefaultValueAttribute(false)]
		public bool languageChange = false;

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		[System.ComponentModel.DefaultValueAttribute(false)]
		public bool transactionBoundary = false;
	} // end of public class environmentChangeNotifications


	/// <summary>
	/// This is a sample implementation of the SQL 2005 applicationName SQL options SOAP Header.
	/// This sample code is generated by taking the schema definition from the WSDL and running through the 
	/// .Net Frameworks SDK "xsd.exe" tool.
	/// </summary>
	[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options")]
	[System.Xml.Serialization.XmlRootAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options", IsNullable = false)]
	public class applicationName : System.Web.Services.Protocols.SoapHeader
	{

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		public string value;
	} // end of public class applicationName


	/// <summary>
	/// This is a sample implementation of the SQL 2005 hostName SQL options SOAP Header.
	/// This sample code is generated by taking the schema definition from the WSDL and running through the 
	/// .Net Frameworks SDK "xsd.exe" tool.
	/// </summary>
	[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options")]
	[System.Xml.Serialization.XmlRootAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options", IsNullable = false)]
	public class hostName : System.Web.Services.Protocols.SoapHeader
	{

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		public string value;
	} // end of public class hostName


	/// <summary>
	/// This is a sample implementation of the SQL 2005 clientPID SQL options SOAP Header.
	/// This sample code is generated by taking the schema definition from the WSDL and running through the 
	/// .Net Frameworks SDK "xsd.exe" tool.
	/// </summary>
	[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options")]
	[System.Xml.Serialization.XmlRootAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options", IsNullable = false)]
	public class clientPID : System.Web.Services.Protocols.SoapHeader
	{

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		public long value;
	} // end of public class clientPID


	/// <summary>
	/// This is a sample implementation of the SQL 2005 clientNetworkID SQL options SOAP Header.
	/// This sample code is generated by taking the schema definition from the WSDL and running through the 
	/// .Net Frameworks SDK "xsd.exe" tool.
	/// </summary>
	[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options")]
	[System.Xml.Serialization.XmlRootAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options", IsNullable = false)]
	public class clientNetworkID : System.Web.Services.Protocols.SoapHeader
	{

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute(DataType = "base64Binary")]
		public System.Byte[] value;
	} // end of public class clientNetworkID


	/// <summary>
	/// This is a sample implementation of the SQL 2005 clientInterface SQL options SOAP Header.
	/// This sample code is generated by taking the schema definition from the WSDL and running through the 
	/// .Net Frameworks SDK "xsd.exe" tool.
	/// </summary>
	[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options")]
	[System.Xml.Serialization.XmlRootAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options", IsNullable = false)]
	public class clientInterface : System.Web.Services.Protocols.SoapHeader
	{

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		public string value;
	} // end of public class clientInterface


	/// <summary>
	/// This is a sample implementation of the SQL 2005 notificationRequest SQL options SOAP Header.
	/// This sample code is generated by taking the schema definition from the WSDL and running through the 
	/// .Net Frameworks SDK "xsd.exe" tool.
	/// </summary>
	[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options")]
	[System.Xml.Serialization.XmlRootAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options", IsNullable = false)]
	public class notificationRequest : System.Web.Services.Protocols.SoapHeader
	{

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		public string notificationId;

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		public string deliveryService;

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute(DataType = "integer")]
		public string timeout;
	} // end of public class notificationRequest


	/// <summary>
	/// This is a sample implementation of the SQL 2005 sqlSession SQL options SOAP Header.
	/// This sample code is generated by taking the schema definition from the WSDL and running through the 
	/// .Net Frameworks SDK "xsd.exe" tool.
	/// </summary>
	[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options")]
	[System.Xml.Serialization.XmlRootAttribute(Namespace = "http://schemas.microsoft.com/sqlserver/2004/SOAP/Options", IsNullable = false)]
	public class sqlSession : System.Web.Services.Protocols.SoapHeader
	{

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		[System.ComponentModel.DefaultValueAttribute(false)]
		public bool initiate = false;

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		[System.ComponentModel.DefaultValueAttribute(false)]
		public bool terminate = false;

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute(DataType = "base64Binary")]
		public System.Byte[] sessionId;

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute()]
		public int timeout;

		/// <remarks/>
		[System.Xml.Serialization.XmlIgnoreAttribute()]
		public bool timeoutSpecified;

		/// <remarks/>
		[System.Xml.Serialization.XmlAttributeAttribute(DataType = "base64Binary")]
		public System.Byte[] transactionDescriptor;
	} // end of public class sqlSession

}
