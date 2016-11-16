using UnityEngine;
using System.Collections;

public class destory : MonoBehaviour {

    
	// Use this for initialization
	void Start () {

        Invoke("dest",3);
        MeshRenderer mt = transform.GetComponent<MeshRenderer>();
        
        mt.material.color = new Color(Random.Range(0.0f, 1.0f), Random.Range(0.0f, 1.0f), Random.Range(0.0f, 1.0f),0.5f);
        //print(mt.material.color);
	}
	
	// Update is called once per frame
	void Update () {
	
	}
    void dest()
    {
        DestroyImmediate(this.gameObject);
    }
}
