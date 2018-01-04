using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GenerateStores
{
  class Program
  {
    static void Main(string[] args)
    {
      var rand = new Random();
      var franchisee_ids = new int[] {301,  512, 121, 891, 2355, 67 };
      var zipcodes = new string[] {"09090", "12345", "89012", "21221", "54345"};
      var store_count=50;
      Console.WriteLine("INSERT INTO Stores VALUES ");
      string template = "{0}({1}, {2}, '{3}', {4})";
      var comma = "";
      for(var sample_number = 0; sample_number < store_count; sample_number++)
      {
        var store_id = ((sample_number % store_count) + 7) * 3;
        var use_franchisee_id = franchisee_ids[rand.Next(0, franchisee_ids.Length)];
        var years_in_business = rand.Next(1, 8);
        var use_zipcode = zipcodes[rand.Next(0, zipcodes.Length)];
        var insert = string.Format(template, comma, store_id, use_franchisee_id, use_zipcode, years_in_business);
        Console.WriteLine(insert);
 
        comma = ",";
 
      }
    }
  }
}
