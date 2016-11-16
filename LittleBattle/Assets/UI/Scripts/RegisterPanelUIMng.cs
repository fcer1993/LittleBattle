using UnityEngine;
using UnityEngine.UI;
using System.Data;
using System;
using System.Collections;

public class RegisterPanelUIMng : MonoBehaviour
{
    public InputField username;
    public InputField account;
    public InputField psw;


    public void BacktoLogin()
    {
        GameObject LoginPanel = LoadBundleOperation.LoadBundle("LoginPanel.prefab");
        LoginPanel.transform.SetParent(transform.parent.transform);
        LoginPanel.GetComponent<RectTransform>().offsetMax = Vector2.zero;
        LoginPanel.GetComponent<RectTransform>().offsetMin = Vector2.zero;
        this.gameObject.SetActive(false);
        Destroy(this.gameObject, 0.1f);
    }

    public void Register()
    {
        register();
        BacktoLogin();
    }

    private void register()
    {
        try
        {
            SqlAccess sql = new SqlAccess();

            long uniqueIdLong   = GuidToLongID();
            Debug.Log(uniqueIdLong);

            DataSet ds = sql.InsertInto("user", new string[] { uniqueIdLong.ToString(), username.text, account.text, psw.text });
            
            sql.Close();
        }
        catch (Exception e)
        {
            Debug.Log(e.Message);

        }
    }

    private static long GuidToLongID()
    {
        byte[] buffer = Guid.NewGuid().ToByteArray();
        return BitConverter.ToInt64(buffer, 0);
    }
}
