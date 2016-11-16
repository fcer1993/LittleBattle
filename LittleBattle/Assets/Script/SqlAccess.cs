using UnityEngine;
using System;
using System.Data;
using System.Collections;
using MySql.Data.MySqlClient;
using MySql.Data;
using System.IO;
public class SqlAccess
{
    public static MySqlConnection dbConnection;
    //如果只是在本地的话，写localhost就可以。
    // static string host = "localhost";  
    //如果是局域网，那么写上本机的局域网IP
    static string host = "localhost";
    static string id = "Wxiang";
    static string pwd = "w623985761";
    static string database = "littlebattle";


    public SqlAccess()
    {
        OpenSql();
    }


    public static void OpenSql()
    {

        try
        {
            string connectionString =
                string.Format("Server = {0};Database = {1}; User ID = {2}; Password = {3};port={4};",
                                host, database, id, pwd, "3306");
            dbConnection = new MySqlConnection(connectionString);
            dbConnection.Open();
        }
        catch (Exception e)
        {
            throw new Exception("服务器连接失败，请重新检查是否打开MySql服务。" + e.Message.ToString());

        }

    }


    public DataSet SelectWhere(string tableName, string[] items, string[] col, string[] operation, string[] values)
    {

        if (col.Length != operation.Length || operation.Length != values.Length)
        {

            throw new Exception("col.Length != operation.Length != values.Length");

        }

        string query = "SELECT " + items[0];

        for (int i = 1; i < items.Length; ++i)
        {

            query += ", " + items[i];

        }

        query += " FROM " + tableName + " WHERE " + col[0] + operation[0] + "'" + values[0] + "' ";

        for (int i = 1; i < col.Length; ++i)
        {

            query += " AND " + col[i] + operation[i] + "'" + values[0] + "' ";

        }

        return ExecuteQuery(query);

    }


    //插入一条数据，包括所有，不适用自动累加ID。
    public DataSet InsertInto(string tableName, string[] values)
    {

        string query = "INSERT INTO " + tableName + " VALUES (" + "'" + values[0] + "'";

        for (int i = 1; i < values.Length; ++i)
        {

            query += ", " + "'" + values[i] + "'";

        }

        query += ")";

        Debug.Log(query);
        return ExecuteQuery(query);

    }


    public void Close()
    {

        if (dbConnection != null)
        {
            dbConnection.Close();
            dbConnection.Dispose();
            dbConnection = null;
        }

    }

    public static DataSet ExecuteQuery(string sqlString)
    {
        if (dbConnection.State == ConnectionState.Open)
        {
            DataSet ds = new DataSet();
            try
            {

                MySqlDataAdapter da = new MySqlDataAdapter(sqlString, dbConnection);
                da.Fill(ds);

            }
            catch (Exception ee)
            {
                throw new Exception("SQL:" + sqlString + "/n" + ee.Message.ToString());
            }
            finally
            {
            }
            return ds;
        }
        return null;
    }
}
