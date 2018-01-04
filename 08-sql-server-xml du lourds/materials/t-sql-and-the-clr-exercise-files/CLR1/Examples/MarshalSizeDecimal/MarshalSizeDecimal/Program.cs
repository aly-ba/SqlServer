using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;

namespace MarshalSizeDecimal
{
    class Program
    {
        static void Main(string[] args)
        {
            SqlDecimal sd = 0;
            Decimal d = 0;
            Console.WriteLine("sd size: {0}  d size:{1}",
                              Marshal.SizeOf(sd),
                              Marshal.SizeOf(d));
        }
    }
}
