using UnityEngine;
using System.Collections;

public class Controller : MonoBehaviour {
    public GameObject box;

    private Vector3 oldpos;
    private Vector3 newpos;
    private bool ismove=false;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
        if (Input.GetKey(KeyCode.A))
        {
            box.transform.Rotate(new Vector3(0,1,0),20*Time.deltaTime,Space.World);
        }
        if (Input.GetKey(KeyCode.D))
        {
            box.transform.Rotate(new Vector3(0, -1, 0), 20 * Time.deltaTime, Space.World);
        }
        if (Input.GetKey(KeyCode.W))
        {
            box.transform.Rotate(new Vector3(0, 0, 1), 20 * Time.deltaTime, Space.World);
        }
        if (Input.GetKey(KeyCode.S))
        {
            box.transform.Rotate(new Vector3(0, 0, -1), 20 * Time.deltaTime, Space.World);
        }

        if (ismove)
        {

        }

        if (Input.GetMouseButton(0))
        {
            box.transform.Rotate(Vector3.up, -Input.GetAxis("Mouse X"), Space.World);
        }

	
	}
}
