using UnityEngine;
using System.Collections;


public class NewBehaviourScript : MonoBehaviour
{
    
    public int ii;
    [TextArea(1, 2)]
    public string s;
    public string s1;
    public enum mm
    {
        mmm = 0,
        mmm2 = 1
    }
    public struct qq
    {
        public string qq1;
        public string qq2;
    }
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
    [ContextMenu("123")]
    public void a()
    { }
}
