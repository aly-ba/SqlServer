using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.SqlServer.Server;

namespace UDFFromScratch
{
    public class Arithmetic
    {
        [SqlFunction(
            Name="Integer Multiply",
            IsDeterministic=true,
            IsPrecise=true
            )
        ]
        public static int IntMul(int m1, int m2)
        {
            return m1 * m2;
        }

        [SqlFunction(
            IsDeterministic=false,
            IsPrecise=false)]
        public static float floatMul(float m1, float m2)
        {
            return m1*m2;
        }



    }
}
