using System;
using System.Data.SqlTypes;

namespace SqlBooleanUsage
{
    class Program
    {

        static void Main(string[] args)
        {
            int? a = null;
            int? b = null;
            SqlInt32 c = SqlInt32.Null;
            SqlInt32 d = SqlInt32.Null;
            if (a == b) Console.WriteLine("a==b");
            if (a != b) Console.WriteLine("a!=b");
            if (c == d) Console.WriteLine("c==d");
            if (c != d) Console.WriteLine("c!=d");
        }
    }

}


