using UnityEngine;
using System.Collections.Generic;
using System.Linq;
using System.Collections;

[AddComponentMenu("UI/UIMng")]
public class UIMng : MonoBehaviour
{
    // Use this for initialization
    private List<GameObject> PanelList;

    public GameObject BackpackPanel;

    void Start ()
    {
        GameObject NormalGamePanel = LoadBundleOperation.LoadBundle("NormalGamePanel.prefab");
        NormalGamePanel.transform.SetParent(transform);
        NormalGamePanel.GetComponent<RectTransform>().offsetMax = Vector2.zero;
        NormalGamePanel.GetComponent<RectTransform>().offsetMin = Vector2.zero;

        //GameObject LoginPanel = LoadBundleOperation.LoadBundle("LoginPanel.prefab");
        //LoginPanel.transform.SetParent(transform);
        //LoginPanel.GetComponent<RectTransform>().offsetMax = Vector2.zero;
        //LoginPanel.GetComponent<RectTransform>().offsetMin = Vector2.zero;

        BackpackPanel.SetActive(false);
    }
	
	// Update is called once per frame
	void Update ()
    {
        if (Input.GetKeyDown(KeyCode.B))
        {
            BackpackPanel.SetActive(!BackpackPanel.activeSelf);
        }
	}
}
