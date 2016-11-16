using UnityEngine;
using System.Collections;

public class Movement : MonoBehaviour
{
    private DealServer ds;
    // Use this for initialization
    void Start ()
    {
        ds = GetComponent<DealServer>();
	}
	
	// Update is called once per frame
	void Update ()
    {
        if (Input.GetMouseButtonDown(1))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit rayhit;
            if (Physics.Raycast(ray, out rayhit, 100f, ~(1 << 5)))
            {
                //Debug.Log(rayhit.point);
                Send(rayhit.point);
                GameObject player = GameObject.Find("Player");
                player.GetComponent<Animator>().SetTrigger("Walking");
                player.GetComponent<Animator>().SetBool("Walked", true);
            }
        }
	}
    private void Send(Vector3 point)
    {
        ds.SetPosition(point);
    } 
    
}
