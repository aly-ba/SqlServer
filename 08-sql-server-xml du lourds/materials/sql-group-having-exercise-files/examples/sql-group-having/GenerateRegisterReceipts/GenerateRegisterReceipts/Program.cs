using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GenerateRegisterReceipts
{
  class Program
  {
    static void Main(string[] args)
    {
      var rand = new Random();
      var store_count = 50;
      var store_ids = new int[50];
      for (var index = 0; index < store_count; index++)
      {
        store_ids[index] = (index + 7) * 3;        
      }
      var template = "{0}({1}, {2}, {3}, {4}, '{5}', {6})";
      var sequence = 1001;
      for (var set = 0; set < 30; set++)
      {
        var receipt_count = 1000;
        Console.WriteLine("INSERT INTO [Unified Receipts] VALUES");
        var comma = "";
        for (var sample_number = 0; sample_number < receipt_count; sample_number++)
        {
          var use_store_id = store_ids[rand.Next(0, store_ids.Length)];
          var amount = ((float)rand.Next(50, 12000)) / 100;
          var month = rand.Next(1, 12);
          var day = rand.Next(1, 29);
          var date = string.Format("{0}/{1,2}/{2}", month, day, 2012);
          var register = rand.Next(1, 15);
          var cashier = rand.Next(10, 18);
          //                                     0        1          2            3          4      5     6
          var insert = string.Format(template, comma, register, use_store_id, ++sequence, amount, date, cashier);
          Console.WriteLine(insert);
        }
        Console.WriteLine(";");
      }
    }
  }
}
