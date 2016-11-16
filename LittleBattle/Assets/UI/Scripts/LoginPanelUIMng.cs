using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class LoginPanelUIMng : MonoBehaviour
{
    public InputField account;
    public InputField psw;
    public Text showmessage;
    public void QuitGame()
    {
        Application.Quit();
    }

    public void EnterGame()
    {
        if (DealServer.sbyaccount(account.text) == psw.text)
        {
            GameObject NormalGamePanel = LoadBundleOperation.LoadBundle("NormalGamePanel.prefab");
            NormalGamePanel.transform.SetParent(transform.parent.transform);
            NormalGamePanel.GetComponent<RectTransform>().offsetMax = Vector2.zero;
            NormalGamePanel.GetComponent<RectTransform>().offsetMin = Vector2.zero;
            this.gameObject.SetActive(false);
            Destroy(this.gameObject, 0.1f);
        }
        else
        {
            showmessage.text = "用户名或密码错误!";
            showmessage.color = Color.red;
        }
    }

    public void RegisterAccount()
    {
        GameObject RegisterPanel = LoadBundleOperation.LoadBundle("RegisterPanel.prefab");
        RegisterPanel.transform.SetParent(transform.parent.transform);
        RegisterPanel.GetComponent<RectTransform>().offsetMax = Vector2.zero;
        RegisterPanel.GetComponent<RectTransform>().offsetMin = Vector2.zero;
        this.gameObject.SetActive(false);
        Destroy(this.gameObject, 0.1f);
    }
}
