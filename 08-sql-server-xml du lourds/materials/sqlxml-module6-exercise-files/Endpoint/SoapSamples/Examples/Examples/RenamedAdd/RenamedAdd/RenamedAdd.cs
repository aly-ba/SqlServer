using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.SqlServer.Server;


namespace RenamedAdd
{
    public class RenamedAdd
    {
        [SqlFunction(Name = "My Addition",
            IsDeterministic=true,
            IsPrecise=true)]
        public static int AddThese(int a1, int a2)
        {
            return a1 + a2;
        }


    }
}
