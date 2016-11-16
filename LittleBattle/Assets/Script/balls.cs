using UnityEngine;
using System.Collections;

public class balls : MonoBehaviour
{
    private float ht = 3f;
    private float ft;
    public Vector3 forward;
    // Use this for initialization
    void Start ()
    {
        ft = Time.time;
	}
	
	// Update is called once per frame
	void Update ()
    {
        transform.Translate(forward * 1 * Time.deltaTime);
        if (Time.time - ft >= ht)
        {
            DestroyImmediate(this.gameObject);
        }
	}

    void OnTriggerEnter(Collider go)
    {
        if (go.tag == "Player")
        {
            Debug.Log("I get you : " + go.name + "!!");
        }
    }
}
