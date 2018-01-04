#if _DYNAMIC_XMLSERIALIZER_COMPILATION
[assembly:System.Security.AllowPartiallyTrustedCallers()]
[assembly:System.Security.SecurityTransparent()]
#endif
[assembly:System.Reflection.AssemblyVersionAttribute("0.0.0.0")]
[assembly:System.Xml.Serialization.XmlSerializerVersionAttribute(ParentAssemblyId=@"50ade277-6b3d-44be-acbf-58cd6135cb69,", Version=@"2.0.0.0")]
namespace Microsoft.Xml.Serialization.GeneratedAssembly {

    public class XmlSerializationWriter1 : System.Xml.Serialization.XmlSerializationWriter {

        public void Write4_pt(object o) {
            WriteStartDocument();
            if (o == null) {
                WriteNullTagLiteral(@"pt", @"");
                return;
            }
            TopLevelElement();
            Write2_pt(@"pt", @"", ((global::pt)o), true, false);
        }

        public void Write5_LDim(object o) {
            WriteStartDocument();
            if (o == null) {
                WriteEmptyTag(@"LDim", @"");
                return;
            }
            WriteSerializable((System.Xml.Serialization.IXmlSerializable)((global::Dimensions.LDim)o), @"LDim", @"", false, true);
        }

        public void Write6_SumLDim(object o) {
            WriteStartDocument();
            if (o == null) {
                WriteEmptyTag(@"SumLDim", @"");
                return;
            }
            Write3_SumLDim(@"SumLDim", @"", ((global::SumLDim)o), false);
        }

        void Write3_SumLDim(string n, string ns, global::SumLDim o, bool needType) {
            if (!needType) {
                System.Type t = o.GetType();
                if (t == typeof(global::SumLDim)) {
                }
                else {
                    throw CreateUnknownTypeException(o);
                }
            }
            WriteStartElement(n, ns, o, false, null);
            if (needType) WriteXsiType(@"SumLDim", @"");
            WriteEndElement(o);
        }

        void Write2_pt(string n, string ns, global::pt o, bool isNullable, bool needType) {
            if ((object)o == null) {
                if (isNullable) WriteNullTagLiteral(n, ns);
                return;
            }
            if (!needType) {
                System.Type t = o.GetType();
                if (t == typeof(global::pt)) {
                }
                else {
                    throw CreateUnknownTypeException(o);
                }
            }
            WriteStartElement(n, ns, o, false, null);
            if (needType) WriteXsiType(@"pt", @"");
            WriteElementStringRaw(@"value", @"", System.Xml.XmlConvert.ToString((global::System.Single)((global::System.Single)o.@value)));
            WriteEndElement(o);
        }

        protected override void InitCallbacks() {
        }
    }

    public class XmlSerializationReader1 : System.Xml.Serialization.XmlSerializationReader {

        public object Read4_pt() {
            object o = null;
            Reader.MoveToContent();
            if (Reader.NodeType == System.Xml.XmlNodeType.Element) {
                if (((object) Reader.LocalName == (object)id1_pt && (object) Reader.NamespaceURI == (object)id2_Item)) {
                    o = Read2_pt(true, true);
                }
                else {
                    throw CreateUnknownNodeException();
                }
            }
            else {
                UnknownNode(null, @":pt");
            }
            return (object)o;
        }

        public object Read5_LDim() {
            object o = null;
            Reader.MoveToContent();
            if (Reader.NodeType == System.Xml.XmlNodeType.Element) {
                if (((object) Reader.LocalName == (object)id3_LDim && (object) Reader.NamespaceURI == (object)id2_Item)) {
                    o = (global::Dimensions.LDim)ReadSerializable(( System.Xml.Serialization.IXmlSerializable)System.Activator.CreateInstance(typeof(global::Dimensions.LDim), System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.CreateInstance | System.Reflection.BindingFlags.NonPublic, null, new object[0], null));
                }
                else {
                    throw CreateUnknownNodeException();
                }
            }
            else {
                UnknownNode(null, @":LDim");
            }
            return (object)o;
        }

        public object Read6_SumLDim() {
            object o = null;
            Reader.MoveToContent();
            if (Reader.NodeType == System.Xml.XmlNodeType.Element) {
                if (((object) Reader.LocalName == (object)id4_SumLDim && (object) Reader.NamespaceURI == (object)id2_Item)) {
                    o = Read3_SumLDim(true);
                }
                else {
                    throw CreateUnknownNodeException();
                }
            }
            else {
                UnknownNode(null, @":SumLDim");
            }
            return (object)o;
        }

        global::SumLDim Read3_SumLDim(bool checkType) {
            System.Xml.XmlQualifiedName xsiType = checkType ? GetXsiType() : null;
            bool isNull = false;
            if (checkType) {
            if (xsiType == null || ((object) ((System.Xml.XmlQualifiedName)xsiType).Name == (object)id4_SumLDim && (object) ((System.Xml.XmlQualifiedName)xsiType).Namespace == (object)id2_Item)) {
            }
            else
                throw CreateUnknownTypeException((System.Xml.XmlQualifiedName)xsiType);
            }
            global::SumLDim o;
            try {
                o = (global::SumLDim)System.Activator.CreateInstance(typeof(global::SumLDim), System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.CreateInstance | System.Reflection.BindingFlags.NonPublic, null, new object[0], null);
            }
            catch (System.MissingMethodException) {
                throw CreateInaccessibleConstructorException(@"global::SumLDim");
            }
            catch (System.Security.SecurityException) {
                throw CreateCtorHasSecurityException(@"global::SumLDim");
            }
            bool[] paramsRead = new bool[0];
            while (Reader.MoveToNextAttribute()) {
                if (!IsXmlnsAttribute(Reader.Name)) {
                    UnknownNode((object)o);
                }
            }
            Reader.MoveToElement();
            if (Reader.IsEmptyElement) {
                Reader.Skip();
                return o;
            }
            Reader.ReadStartElement();
            Reader.MoveToContent();
            int whileIterations0 = 0;
            int readerCount0 = ReaderCount;
            while (Reader.NodeType != System.Xml.XmlNodeType.EndElement && Reader.NodeType != System.Xml.XmlNodeType.None) {
                if (Reader.NodeType == System.Xml.XmlNodeType.Element) {
                    UnknownNode((object)o, @"");
                }
                else {
                    UnknownNode((object)o, @"");
                }
                Reader.MoveToContent();
                CheckReaderCount(ref whileIterations0, ref readerCount0);
            }
            ReadEndElement();
            return o;
        }

        global::pt Read2_pt(bool isNullable, bool checkType) {
            System.Xml.XmlQualifiedName xsiType = checkType ? GetXsiType() : null;
            bool isNull = false;
            if (isNullable) isNull = ReadNull();
            if (checkType) {
            if (xsiType == null || ((object) ((System.Xml.XmlQualifiedName)xsiType).Name == (object)id1_pt && (object) ((System.Xml.XmlQualifiedName)xsiType).Namespace == (object)id2_Item)) {
            }
            else
                throw CreateUnknownTypeException((System.Xml.XmlQualifiedName)xsiType);
            }
            if (isNull) return null;
            global::pt o;
            o = new global::pt();
            bool[] paramsRead = new bool[1];
            while (Reader.MoveToNextAttribute()) {
                if (!IsXmlnsAttribute(Reader.Name)) {
                    UnknownNode((object)o);
                }
            }
            Reader.MoveToElement();
            if (Reader.IsEmptyElement) {
                Reader.Skip();
                return o;
            }
            Reader.ReadStartElement();
            Reader.MoveToContent();
            int whileIterations1 = 0;
            int readerCount1 = ReaderCount;
            while (Reader.NodeType != System.Xml.XmlNodeType.EndElement && Reader.NodeType != System.Xml.XmlNodeType.None) {
                if (Reader.NodeType == System.Xml.XmlNodeType.Element) {
                    if (!paramsRead[0] && ((object) Reader.LocalName == (object)id5_value && (object) Reader.NamespaceURI == (object)id2_Item)) {
                        {
                            o.@value = System.Xml.XmlConvert.ToSingle(Reader.ReadElementString());
                        }
                        paramsRead[0] = true;
                    }
                    else {
                        UnknownNode((object)o, @":value");
                    }
                }
                else {
                    UnknownNode((object)o, @":value");
                }
                Reader.MoveToContent();
                CheckReaderCount(ref whileIterations1, ref readerCount1);
            }
            ReadEndElement();
            return o;
        }

        protected override void InitCallbacks() {
        }

        string id5_value;
        string id3_LDim;
        string id4_SumLDim;
        string id2_Item;
        string id1_pt;

        protected override void InitIDs() {
            id5_value = Reader.NameTable.Add(@"value");
            id3_LDim = Reader.NameTable.Add(@"LDim");
            id4_SumLDim = Reader.NameTable.Add(@"SumLDim");
            id2_Item = Reader.NameTable.Add(@"");
            id1_pt = Reader.NameTable.Add(@"pt");
        }
    }

    public abstract class XmlSerializer1 : System.Xml.Serialization.XmlSerializer {
        protected override System.Xml.Serialization.XmlSerializationReader CreateReader() {
            return new XmlSerializationReader1();
        }
        protected override System.Xml.Serialization.XmlSerializationWriter CreateWriter() {
            return new XmlSerializationWriter1();
        }
    }

    public sealed class ptSerializer : XmlSerializer1 {

        public override System.Boolean CanDeserialize(System.Xml.XmlReader xmlReader) {
            return xmlReader.IsStartElement(@"pt", @"");
        }

        protected override void Serialize(object objectToSerialize, System.Xml.Serialization.XmlSerializationWriter writer) {
            ((XmlSerializationWriter1)writer).Write4_pt(objectToSerialize);
        }

        protected override object Deserialize(System.Xml.Serialization.XmlSerializationReader reader) {
            return ((XmlSerializationReader1)reader).Read4_pt();
        }
    }

    public sealed class LDimSerializer : XmlSerializer1 {

        public override System.Boolean CanDeserialize(System.Xml.XmlReader xmlReader) {
            return xmlReader.IsStartElement(@"LDim", @"");
        }

        protected override void Serialize(object objectToSerialize, System.Xml.Serialization.XmlSerializationWriter writer) {
            ((XmlSerializationWriter1)writer).Write5_LDim(objectToSerialize);
        }

        protected override object Deserialize(System.Xml.Serialization.XmlSerializationReader reader) {
            return ((XmlSerializationReader1)reader).Read5_LDim();
        }
    }

    public sealed class SumLDimSerializer : XmlSerializer1 {

        public override System.Boolean CanDeserialize(System.Xml.XmlReader xmlReader) {
            return xmlReader.IsStartElement(@"SumLDim", @"");
        }

        protected override void Serialize(object objectToSerialize, System.Xml.Serialization.XmlSerializationWriter writer) {
            ((XmlSerializationWriter1)writer).Write6_SumLDim(objectToSerialize);
        }

        protected override object Deserialize(System.Xml.Serialization.XmlSerializationReader reader) {
            return ((XmlSerializationReader1)reader).Read6_SumLDim();
        }
    }

    public class XmlSerializerContract : global::System.Xml.Serialization.XmlSerializerImplementation {
        public override global::System.Xml.Serialization.XmlSerializationReader Reader { get { return new XmlSerializationReader1(); } }
        public override global::System.Xml.Serialization.XmlSerializationWriter Writer { get { return new XmlSerializationWriter1(); } }
        System.Collections.Hashtable readMethods = null;
        public override System.Collections.Hashtable ReadMethods {
            get {
                if (readMethods == null) {
                    System.Collections.Hashtable _tmp = new System.Collections.Hashtable();
                    _tmp[@"pt::"] = @"Read4_pt";
                    _tmp[@"Dimensions.LDim::"] = @"Read5_LDim";
                    _tmp[@"SumLDim::"] = @"Read6_SumLDim";
                    if (readMethods == null) readMethods = _tmp;
                }
                return readMethods;
            }
        }
        System.Collections.Hashtable writeMethods = null;
        public override System.Collections.Hashtable WriteMethods {
            get {
                if (writeMethods == null) {
                    System.Collections.Hashtable _tmp = new System.Collections.Hashtable();
                    _tmp[@"pt::"] = @"Write4_pt";
                    _tmp[@"Dimensions.LDim::"] = @"Write5_LDim";
                    _tmp[@"SumLDim::"] = @"Write6_SumLDim";
                    if (writeMethods == null) writeMethods = _tmp;
                }
                return writeMethods;
            }
        }
        System.Collections.Hashtable typedSerializers = null;
        public override System.Collections.Hashtable TypedSerializers {
            get {
                if (typedSerializers == null) {
                    System.Collections.Hashtable _tmp = new System.Collections.Hashtable();
                    _tmp.Add(@"pt::", new ptSerializer());
                    _tmp.Add(@"SumLDim::", new SumLDimSerializer());
                    _tmp.Add(@"Dimensions.LDim::", new LDimSerializer());
                    if (typedSerializers == null) typedSerializers = _tmp;
                }
                return typedSerializers;
            }
        }
        public override System.Boolean CanSerialize(System.Type type) {
            if (type == typeof(global::pt)) return true;
            if (type == typeof(global::Dimensions.LDim)) return true;
            if (type == typeof(global::SumLDim)) return true;
            return false;
        }
        public override System.Xml.Serialization.XmlSerializer GetSerializer(System.Type type) {
            if (type == typeof(global::pt)) return new ptSerializer();
            if (type == typeof(global::Dimensions.LDim)) return new LDimSerializer();
            if (type == typeof(global::SumLDim)) return new SumLDimSerializer();
            return null;
        }
    }
}
