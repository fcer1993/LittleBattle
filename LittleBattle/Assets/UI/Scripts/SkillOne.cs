using UnityEngine;
using System.Collections;
using GameBase;

public class SkillOne : SkillBase
{
    private GameObject player;
    public SkillOne()
    {
        this.Id = "111";
    }
    public override void Execute()
    {
        player = GameObject.Find("Player");
        GameObject BallParticle = LoadBundleOperation.LoadBundle("Ball.prefab");

        Matrix4x4 lam = player.transform.localToWorldMatrix;
        Vector3 po1 = lam * new Vector3(0f, 0.8f, 1.2f);

        BallParticle.transform.position = player.transform.position + po1;
        BallParticle.GetComponent<balls>().forward = player.transform.forward;
        Debug.Log("I`m skillone!");
    }
    //public override void OnFocus()
    //{
    //    Debug.Log("I`m showing InUI!");
    //}
}
