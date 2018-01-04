using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    class WordInfo
    {
        public int Length
        {
            get;
            private set;
        }
        public string Word
        {
            get;
            private set;
        }
        public WordInfo(string word, int length)
        {
            Word = word;
            Length = length;
        }

    }


    static public void WordInfoCracker(object obj, out string word, out int length)
    {
        var wi = obj as WordInfo;
        word = wi.Word;
        length = wi.Length;
    }





    [Microsoft.SqlServer.Server.SqlFunction(
        TableDefinition="word nvarchar(max), length int",
        FillRowMethodName="WordInfoCracker"
        )
    ]
    public static System.Collections.IEnumerable WordSplit(string str, string splitOn)
    {
        foreach (var word in str.Split(splitOn.ToCharArray(),
            StringSplitOptions.RemoveEmptyEntries))
            {
            yield return new WordInfo(word, word.Length)
                ;
        }



    }


};

