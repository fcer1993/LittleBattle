using UnityEngine;
using System.Collections;

public class createCube : MonoBehaviour {

    public Transform pos;
    public GameObject prefabs;
    private float i = 0.5f;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {

        i -= Time.deltaTime;
        if (i<=0)
        {
            creat();
            i = 0.2f;
        }
        

	}
    void creat()
    {
        Instantiate(prefabs,pos.transform.position,Quaternion.identity);
    }
}
