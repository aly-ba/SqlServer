using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;


public partial class StoredProcedures
{
    [SqlProcedure]
    public static void MakeFib(SqlInt32 first, SqlInt32 second, SqlInt32 length)
    {

        var resultMetadata = new SqlMetaData[2];
        resultMetadata[0] = new SqlMetaData("position", SqlDbType.Int);
        resultMetadata[1] = new SqlMetaData("value", SqlDbType.Int);



        var dataRecord = new SqlDataRecord(resultMetadata);
        var pipe = SqlContext.Pipe;
        pipe.SendResultsStart(dataRecord);

        var position = 1;
        dataRecord.SetSqlInt32(0, position);
        dataRecord.SetSqlInt32(1, first);
        pipe.SendResultsRow(dataRecord);
        position += 1;
        dataRecord.SetSqlInt32(0, position);
        dataRecord.SetSqlInt32(1, second);
        pipe.SendResultsRow(dataRecord);
        var preceding2 = first;

        while (position < length)
        {
            position += 1;
            dataRecord.SetSqlInt32(0, position);
            var preceding1 = dataRecord.GetSqlInt32(1);
            dataRecord.SetSqlInt32(1, preceding2 + preceding1);
            pipe.SendResultsRow(dataRecord);
            preceding2 = preceding1;
        }



        pipe.SendResultsEnd();






    }


};
