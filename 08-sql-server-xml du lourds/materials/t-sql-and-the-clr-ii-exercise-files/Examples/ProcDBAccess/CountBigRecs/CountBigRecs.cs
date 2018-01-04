using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;


public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void CountBigRecs(SqlInt32 limit, out SqlInt32 count)
    {
        count = 0;
        using (SqlConnection conn = new SqlConnection("context connection=true"))
        using (SqlCommand cmd = new SqlCommand(
            @"select count(*) from Rectangles where (height * width) > @limit", conn))
        {
            cmd.Parameters.AddWithValue("@limit", limit);
            conn.Open();
            count = (int)cmd.ExecuteScalar();
        }
    }
    [SqlProcedure]
    public static void GetBigRecs(SqlInt32 limit)
    {
        using (SqlConnection conn = new SqlConnection("context connection=true"))
        using (SqlCommand cmd = new SqlCommand(
                @"select (height * width) as area from Rectangles where (height * width) > @limit",
                    conn))
        {
            conn.Open();
            cmd.Parameters.AddWithValue("@limit", limit);
            SqlContext.Pipe.ExecuteAndSend(cmd);
        }
    }

    [SqlProcedure]
    public static void GetBigRecs2(SqlInt32 limit)
    {
        using (SqlConnection conn = new SqlConnection("context connection=true"))
        using (SqlCommand cmd = new SqlCommand(
                @"select (height * width) as area from Rectangles where (height * width) > @limit",
                    conn))
        {
            conn.Open();
            cmd.Parameters.AddWithValue("@limit", limit);
            var results = cmd.ExecuteReader();
            SqlContext.Pipe.Send(results);
        }
    }


    [SqlProcedure]
    public static void GetBigRecs3(SqlInt32 limit)
    {
        using (SqlConnection conn = new SqlConnection("context connection=true"))
        using (SqlCommand cmd = new SqlCommand(
                    @"select height, width from Rectangles",
                                conn))
        {

            conn.Open();
            cmd.Parameters.AddWithValue("@limit", limit);
            var results = cmd.ExecuteReader();
            var metadata = new SqlMetaData[1]
                    {
                                new SqlMetaData("area", SqlDbType.Int)
                    };
            var pipe = SqlContext.Pipe;
            var record = new SqlDataRecord(metadata);
            pipe.SendResultsStart(record);
            while (results.Read())
            {
                var height = (int)results[0];
                var width = (int)results[1];
                if ((height * width) > limit)
                {
                    record.SetSqlInt32(0, height * width);
                    pipe.SendResultsRow(record);
                }
            }
            pipe.SendResultsEnd();

        }
    }

    [SqlProcedure]
    public static void TrimAllWidths(SqlInt32 trimby, out SqlInt32 affected)
    {
        using (SqlConnection conn = new SqlConnection("context connection=true"))
        using (SqlCommand cmd = new SqlCommand(
                        @"update Rectangles set width = width - @trimby
            where width - @trimby > 10", conn))
        {
            conn.Open();
            cmd.Parameters.AddWithValue("@trimby", trimby);
            affected = cmd.ExecuteNonQuery();
        }
    }


    [SqlProcedure]
    public static void MakeError(SqlInt32 severity, SqlInt32 state, SqlString message)
    {
        if (severity.IsNull || state.IsNull || message.IsNull)
        {
            return;
        }
        var error = String.Format("RAISERROR (N'A Phony Error %s', {0}, {1}, @message)",
                severity.Value.ToString(), state.ToString());
        using (SqlConnection conn = new SqlConnection("context connection=true"))
        using (SqlCommand cmd = new SqlCommand(
                error,
                    conn))
        {
            conn.Open();
            cmd.Parameters.AddWithValue("@message", message);
            SqlContext.Pipe.ExecuteAndSend(cmd);
        }
    }






};
