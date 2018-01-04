#define useInchesNot
using System;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Text.RegularExpressions;
using System.IO;
using Microsoft.SqlServer.Server;
using System.Xml.Serialization;
using System.Xml.Schema;
using System.Xml;
using System.Xml.XPath;

namespace Dimensions
{
  class container
  {
    internal int value;
    public container()
    {
      value = 3;
    }
  }
	[SqlUserDefinedType(Format.UserDefined,
	MaxByteSize = 5,
	IsFixedLength = true,
	IsByteOrdered = true,
	ValidationMethodName="CheckDirectInput"
	)]
    //[XmlSerializerAssemblyAttribute(AssemblyName = 
    //  "dimension.xmlserializers, version=0.0.0.0, culture=neutral, publickeytoken=null, processorarchitecture=msil")]
    [XmlSerializerAssemblyAttribute]
    public struct LDim : INullable, IBinarySerialize, IXmlSerializable
	{
    internal static readonly container C  = new container();
    [SqlFacet(Precision=10, Scale=5)]
        [XmlIgnore]
        public static readonly SqlDecimal Fieldtest = 4M;
        [XmlIgnore]
    public static readonly LDim Setback = Parse("20 yd");

[return:SqlFacet(MaxSize=-1)]
public SqlString GetDescription(
    [SqlFacet(MaxSize=10)]
    SqlString intro,
    [SqlFacet(IsNullable=false)]
    SqlDateTime datetime,
    [SqlFacet(Scale=8, Precision=4)]
    SqlDecimal weight)
{
    return intro.Value + ": "
        + datetime.Value.ToLongDateString() + " : "
        +
        weight.Value + " : "
        + this.ToString();
}
    public static int Proptest
    {
      get { return C.value; }
      set { C.value = value; }
    }
    [SqlFacet(MaxSize=-1)]
        //[XmlIgnore]
        public SqlString LongString
    {
      get { return new string('A', 5000); }
      set { this.value = value.Value.Length; }
    }
    //[SqlFacet(MaxSize=4)]
    public SqlString test1;
    [SqlFacet(Precision = 10, Scale = 5)]
        [XmlIgnore]
    public SqlDecimal test2;
    static public int IncContainer()
    {
      C.value++;
      return C.value;
    }
    [SqlFunction]
    static public SqlInt32 SLen(
      [SqlFacet(MaxSize = -1)] SqlString s)
    {
      return s.Value.Length;
    }
    [SqlMethod(InvokeIfReceiverIsNull = true)]
    public int Test(
      [SqlFacet(MaxSize=-1)]
      SqlString s)
    {
      return s.Value.Length;
    }
    //[SqlFunction(IsDeterministic=true, IsPrecise=true)]
    [return:SqlFacet(MaxSize =-1)]
    public static SqlString Reverse(LDim dim)
    {
      if (dim.IsNull)
      {
        return SqlString.Null;
      }
      string sdim = dim.ToString();
      char[] chs = sdim.ToCharArray();
      Array.Reverse(chs);
      return new string(chs);
    }
    [SqlFunction(IsDeterministic = true, IsPrecise = true)]
    [return: SqlFacet(MaxSize = -1)]
    public static SqlString Reverse2(
      [SqlFacet(MaxSize = -1)]
      SqlString str)
    {
      char[] chs = str.Value.ToCharArray();
      Array.Reverse(chs);
      return new string(chs);
    }
    [SqlFunction(IsDeterministic = true, IsPrecise = true)]
    [return: SqlFacet(MaxSize = 40)]
    public static SqlString Reverse3(
      [SqlFacet(MaxSize = 80)]
      SqlString str)
    {
      char[] chs = str.Value.ToCharArray();
      Array.Reverse(chs);
      return new string(chs);
    }
        public int PTest()
        {
            return 6;
        }
    
    private decimal value;
		private string units;
        public override string ToString()
		{
			if (IsNull)
			{
				return null;
			}

			// Put your code here
			return String.Format("{0} {1}", value, units);
		}
        [XmlIgnore]
        public bool IsNull
{
    [SqlMethod(InvokeIfReceiverIsNull=true)]
	get
	{
		return units == null;
	}
}
		public static LDim Null
		{
			get
			{
				return new LDim();
			}
		}
		[SqlFacet(Precision = 9, Scale = 3)]
        [XmlIgnore]
        public SqlDecimal Inches
		{
			get
			{
				SqlDecimal d;
				if (IsNull) return SqlDecimal.Null;
				if (units == "in")
				{
					return this.value;
				}
				if (units == "ft")
				{
					d = this.value * 12.0M;
					return this.value * 12.0M;
				}
				return 36.0M * this.value;
			}
			set
			{
				if (units != null)
				{
					this.value = value.Value;
					units = "in";
				}
			}
		}
		[SqlFunction(Name = "LDimAdd")]
		static public LDim operator +(LDim d1, LDim d2)
		{
			if (d1.IsNull || d2.IsNull)
			{
				return Null;
			}
			if (d1.units == d2.units)
			{
				LDim dim = new LDim();
				dim.units = d1.units;
				dim.value = d1.value + d2.value;
				return dim;
			}
			LDim dim1 = new LDim();
			dim1.units = "in";
			dim1.value = d1.Inches.Value + d2.Inches.Value;
			return dim1;
		}
		bool CheckDirectInput()
		{
			return CheckRangeAndAccurcy(this);
		}
		static bool CheckRangeAndAccurcy(LDim d)
		{
			decimal value = d.value;
			// check overall range
			if (d.units == "in")
			{
				if ((value > (52800M * 12M)) ||
				(value < -(52800M * 12M)))
				{
					return false;
				}
			}
			if (d.units == "ft")
			{
				if ((value > 52800M) ||
				(value < -52800M))
				{
					return false;
				}
			}
			if (d.units == "yd")
			{
				if ((value > (52800M / 3M)) ||
				(value < -(52800M) / 3M))
				{
					return false;
				}
			}
			// check accuracy to 0.001 inches
			if (d.units == "ft")
			{
				value *= 12M;
			}
			if (d.units == "yd")
			{
				value *= 36M;
			}
			decimal norm = value * 1000M;
			norm = decimal.Round(norm);
			if ((norm - (value * 1000M)) != 0M)
			{
				return false;
			}
			return true;
		}
		static void MoveBitsFromIntToByte(uint i1, int start1, int width, ref byte b2, int start2)
		{
			uint mask = 0xFFFFFFFF;
			mask = 1U << start1 + 1;
			mask -= 1;
			uint mask2 = 1U << (start1 - (width - 1));
			mask2 -= 1;
			mask2 ^= 0xFFFFFFFF;
			mask &= mask2;
			i1 &= mask;
			int shift = start2 - start1;
			if (shift < 0)
			{
				i1 >>= -shift;
			}
			if (shift > 0)
			{
				i1 <<= shift;
			}
			mask = 1U << start2 + 1;
			mask -= 1U;
			mask2 = 1U << (start2 - (width - 1));
			mask2 -= 1;
			mask2 ^= 0xFFFFFFFF;
			mask &= mask2;
			b2 |= (byte)(i1 & mask);
			
		}
		static void MoveBitsFromByteToInt(byte b1, int start1, int width, ref uint i2, int start2)
		{
			uint bvalue = b1;
			uint mask = 1U << (1 + start1);
			mask -= 1U;
			uint mask2 = 1U << (start1 - (width - 1));
			mask2 -= 1;
			mask ^= mask2;
			bvalue &= mask;
			mask = 1U << (1 + start2);
			mask -= 1U;
			mask2 = 1U << (1 + start2 - width);
			mask2 -= 1;
			mask ^= mask2;
			mask ^= 0xFFFFFFFF;
			i2 &= mask;
			int shift = start2 - start1;
			if (shift < 0)
			{
				bvalue >>= -shift;
			}
			if (shift > 0)
			{
				bvalue <<= shift;
			}
			i2 |= bvalue;
		}
		public static LDim Parse(SqlString s)
		{
			if (s.IsNull)
				return Null;
			// regular expression to test, extract
			string fp = @"-?([0-9]+(\.[0-9]*)?|\.[0-9]+)";
			Regex vu = new Regex(@"(?<v>" + fp + @") (?<u>in|ft|yd)");

			if (!vu.IsMatch(s.Value))
			{
				throw new Exception("Bad format", null);
			}

			Match m = vu.Match(s.Value);
			LDim d = new LDim();

			d.units = m.Result("${u}");
			d.value = decimal.Parse(m.Result("${v}"));
			if (!CheckRangeAndAccurcy(d))
			{
				throw new Exception("Out of range or accuracy", null);
			}
			return d;
		}
		[SqlMethod(IsMutator = true, OnNullCall = false)]
		public void SetNull()
		{
			units = null;
			value = 0;
		}
		[SqlMethod(IsMutator=true, OnNullCall=true)]
		public void ScaleBy(
      [SqlFacet(Precision=10, Scale=15)]
      SqlDecimal scale)
		{
			if (!IsNull && !scale.IsNull)
			{
				Decimal oldValue = this.value;
				this.value *= scale.Value;
				if (!CheckRangeAndAccurcy(this))
				{
					this.value = oldValue;
				}
			}
		}
		[SqlMethod(IsMutator = false, OnNullCall = false)]
		public LDim GetScaled(SqlDecimal scale)
		{
			LDim ldim = new LDim();
			if (!IsNull)
			{
				ldim.value = this.value;
				ldim.units = this.units;
				ldim.value *= scale.Value;
				if (!CheckRangeAndAccurcy(ldim))
				{
					ldim = this;
				}
			}
			return ldim;
		}
        [SqlMethod(InvokeIfReceiverIsNull=true)]
        public int SomeMethod()
        {
            return 1;
        }
        [SqlMethod(InvokeIfReceiverIsNull = true)]
        public LDim SomeMethod2()
        {
            return this;
        }
        [SqlMethod(InvokeIfReceiverIsNull = true)]
        public object SomeMethod3()
        {
            return new LDim();
        }

        [XmlIgnore]
        public SqlInt32 TestPropInt
        {
            [SqlMethod(InvokeIfReceiverIsNull = true)]
            get { return 1; }
        }
        [SqlMethod(//IsMutator = false, 
            //OnNullCall = true,
            InvokeIfReceiverIsNull=true)]
        public LDim GetScaledCNR(SqlDecimal scale)
        {
            LDim ldim = new LDim();
            if (!IsNull)
            {
                ldim.value = this.value;
                ldim.units = this.units;
                ldim.value *= scale.Value;
                if (!CheckRangeAndAccurcy(ldim))
                {
                    ldim = this;
                }
            }
            return ldim;
        }
        [SqlMethod(IsMutator = true, OnNullCall = false)]
		public void ToIn()
		{
			if (units == "ft")
			{
				value *= 12M;
			}

			if (units == "yd")
			{
				value *= 36M;
			}

			units = "in";
		}
		public void Write(System.IO.BinaryWriter w)
		{
			byte[] bytes = ToBytes();
			foreach (byte b in bytes) 
			{
				w.Write(b); 
			};
		}

		public byte[] ToBytes()
		{
			byte[] bytes = new byte[5];
			if (IsNull)
			{
				bytes[0] = bytes[1] = bytes[2] = bytes[3] = bytes[4] = 0;
			}
			else
			{
				// store as inches and thousandths of an inch
				int thousandths;
				uint sign = 1;
				Decimal floor = 0M;
				Decimal d = this.Inches.Value;
				int inches;
				if (d < 0M)
				{
					floor = Decimal.Floor(-d);
					thousandths = (int)((-d - floor) * 1000M);
					sign = 0;
				}
				else
				{
					floor = Decimal.Floor(d);
					thousandths = (int)((d - floor) * 1000M);
				}
				inches = (int)floor;

				if (sign == 0)
				{
					// this is negative dim
					inches = 10 * 5280 * 12 - inches;
					thousandths = 1000 - thousandths;
				}
				// max number of inches is 633600 or 0x9AB00
				// this fits in about 2.5 bytes or 20 bits
				// thousandths (0-999) fits about 1.5 bytes or 10 bits
				// sign takes 1 bit
				// units takes 2 bits
				// store as inches. note as calculated inches is never negative
				// total bits needed is 20 + 10 + 1 + 2 or 33
				// storage then will be 5 bytes
				byte b = 0;
				MoveBitsFromIntToByte(sign, 0, 1, ref b, 7);
				// move bit 19 to position 6
				MoveBitsFromIntToByte((uint)inches, 19, 7, ref b, 6);
				//w.Write(b); //1
				bytes[0] = b;
				// move bit 11 to position 7
				b = 0;
				MoveBitsFromIntToByte((uint)inches, 12, 8, ref b, 7);
				//w.Write(b); //2
				bytes[1] = b;
				// move bit 4 to position 7
				b = 0;
				MoveBitsFromIntToByte((uint)inches, 4, 5, ref b, 7);
				// move bit bit 10 to position 2
				MoveBitsFromIntToByte((uint)thousandths, 9, 3, ref b, 2);
				//w.Write(b); //3
				bytes[2] = b;
				// move bit 7 to position 7
				b = 0;
				MoveBitsFromIntToByte((uint)thousandths, 6, 7, ref b, 6);
				//w.Write(b); //4
				bytes[3] = b;
				// no add units 1=in, 2=ft, 3=yd
				if (units == "in")
				{
					b = 1;
				}
				if (units == "ft")
				{
					b = 2;
				}
				if (units == "yd")
				{
					b = 3;
				}
				//w.Write(b); //5
				bytes[4] = b;
			}
			return bytes;
		}
		public void Read(System.IO.BinaryReader r)
		{
			byte[] bytes = r.ReadBytes(5);
			FromBytes(bytes);
		}
		public void FromBytes(byte[] bytes)
		{
			if (
			(bytes[0] == 0)
			&& (bytes[1] == 0)
			&& (bytes[2] == 0)
			&& (bytes[3] == 0)
			&& (bytes[4] == 0)
			)
			{
				units = null;
				value = 0M;
				return;
			}

			uint sign = 0;
			MoveBitsFromByteToInt(bytes[0], 7, 1, ref sign, 0);
			uint inches = 0;
			MoveBitsFromByteToInt(bytes[0], 6, 7, ref inches, 19);
			MoveBitsFromByteToInt(bytes[1], 7, 8, ref inches, 12);
			MoveBitsFromByteToInt(bytes[2], 7, 5, ref inches, 4);
			uint thousandths = 0;
			MoveBitsFromByteToInt(bytes[2], 2, 3, ref thousandths, 9);
			MoveBitsFromByteToInt(bytes[3], 6, 7, ref thousandths, 6);
			uint u = 0;
			MoveBitsFromByteToInt(bytes[4], 1, 2, ref u, 1);
			if (sign == 0)
			{
				inches = 10 * 5280 * 12 - inches;
				thousandths = 1000 - thousandths;
			}
			value = thousandths;
			value /= 1000M;
			value += inches;
			switch (u)
			{
				case 1: units = "in"; break;
				case 2:
					units = "ft";
					value /= 12;
					break;
				case 3:
					units = "yd";
					value /= 36;
					break;
			}

			if (sign == 0)
			{
				value = -value;
			}
		}

        #region IXmlSerializable Members
#if true
        System.Xml.Schema.XmlSchema IXmlSerializable.GetSchema()
        {
            System.IO.StringReader sr = new StringReader(@"
<xsd:schema xmlns:xsd='http://www.w3.org/2001/XMLSchema'>
<xsd:element name='LDim'>
<xsd:complexType>
<xsd:sequence>
<xsd:element name='Dimension'>
<xsd:element name='value' type='xsd:float'/>
<xsd:element name='units:'>
<xsd:simpleType>
<xsd:restriction>
<xsd:enumeration value='ft'/>
<xsd:enumeration value='in'/>
<xsd:enumeration value='yd'/>
</xsd:restriction>
</xsd:simpleType>
</xsd:element>
</xsd:element>
</xsd:sequence>
</xsd:complexType>
</xsd:element>
</xsd:schema>");
            XmlSchema schema = XmlSchema.Read(sr, null);
            return null;
        }

        void IXmlSerializable.ReadXml(System.Xml.XmlReader reader)
        {
            XPathDocument xdoc = new XPathDocument(reader);
            XPathNavigator nav = xdoc.CreateNavigator();
            XmlNamespaceManager nm = new XmlNamespaceManager(nav.NameTable);
            nm.AddNamespace("xsi", "http://www.w3.org/2001/XMLSchema-instance");
            if ((bool)(nav.Evaluate("boolean(//@xsi:nil = 'true')", nm)))
            {
                value = 0;
                units = null;
            }
            else
            {
                LDim dim = Parse((string)(nav.Evaluate(
                "concat(//value, ' ', //units)")));
                units = dim.units;
                value = dim.value;
            }
        }

        void IXmlSerializable.WriteXml(System.Xml.XmlWriter writer)
        {
            if (!IsNull)
            {
                writer.WriteStartElement("Dimension");
                writer.WriteElementString("value", value.ToString());
                writer.WriteElementString("units", units);
                writer.WriteEndElement();
            }
            else
            {
                writer.WriteStartElement("Dimension");
                writer.WriteAttributeString("nil",
                    "http://www.w3.org/2001/XMLSchema-instance", "true");
                writer.WriteEndElement();
            }
        }
#endif
        #endregion
    }
}