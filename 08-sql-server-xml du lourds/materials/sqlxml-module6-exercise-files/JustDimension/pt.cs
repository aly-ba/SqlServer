using System;
using System.Data.Sql;
using System.Data.SqlTypes;
using System.Runtime.InteropServices;
using Microsoft.SqlServer.Server;
[Serializable]
[StructLayout(LayoutKind.Sequential 

	)]
[SqlUserDefinedType(Format.Native ,
	IsByteOrdered=true//,
//	MaxByteSize=512
	)]

public class pt: INullable
{
	public float value;
    public override string ToString()
    {
        string s="null";
		if (value != float.MaxValue)
		{
			s = value.ToString();
		}
        // Put your code here
        return s;
    }

    public bool IsNull
    {
        get
        {
            // Put your code here
            return value == float.MaxValue ;
        }
    }

    public static pt Null
    {
        get
        {
            pt h = new pt();
			h.value = float.MaxValue;
            return h;
        }
    }

    public static pt Parse(SqlString s)
    {
        if (s.IsNull || s.Value.ToLower() == "null")
            return Null;
        pt u = new pt();
		u.value = float.Parse(s.Value);
        // Put your code here
        return u;
    }

    // This is a place-holder method
    public static SqlString Method1(SqlString Param1)
    {
        //Insert method code here
        return "Hello";
    }
}

