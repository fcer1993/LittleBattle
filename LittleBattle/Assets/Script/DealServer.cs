using UnityEngine;
using System;
using System.Data;
using System.Collections;
using MySql.Data.MySqlClient;
using MySql.Data;
using System.IO;

public class DealServer : MonoBehaviour
{
    private Vector3 Position;
    private float Speed = 1.88f;
	// Use this for initialization
	void Start ()
    {
        Position = this.transform.position;
	}

    // Update is called once per frame
    void Update()
    {
        if (Vector3.Distance(this.transform.position, Position) >= 0.77f)
        {
            transform.position = Vector3.MoveTowards(transform.position, new Vector3(Position.x, transform.position.y, Position.z), Speed * Time.deltaTime);
            //transform.Translate(0f, 0f, Speed * Time.deltaTime); 
        }
        else
        {
            GameObject player = GameObject.Find("Player");
            player.GetComponent<Animator>().SetBool("Walked", false);
        }
    }
   
    public void SetPosition(Vector3 point)
    {
        Position = new Vector3(point.x, Position.y, point.z);

        Vector3 targetForward = Position - transform.position;

        float angle = Vector3.Angle(transform.forward, targetForward);
        float targetAngle = Vector3.Cross(transform.forward, targetForward).y >= 0 ? angle : -angle;
        //Debug.Log(targetAngle);
        transform.Rotate(0f, targetAngle, 0f);
    }
    public static string sbyaccount(string accout)
    {
        try
        {
            SqlAccess sql = new SqlAccess();

            DataSet ds = sql.SelectWhere("user", new string[] { "PSW" }, new string[] { "Account" }, new string[] { "=" }, new string[] { accout });
            if (ds != null)
            {

                DataTable table = ds.Tables[0];

                foreach (DataRow row in table.Rows)//设想只会有一个结果
                {
                    foreach (DataColumn column in table.Columns)
                    {
                        Debug.Log(row[column].ToString());
                        return row[column].ToString();
                    }
                }

            }
            sql.Close();
        }
        catch (Exception e)
        {
            Debug.Log(e.Message);
            
        }
        return null;
    }
}
