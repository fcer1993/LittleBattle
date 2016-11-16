using UnityEngine;
using System.Collections;
using GameBase;

public class SkillFour : SkillBase
{
    public SkillFour()
    {
        this.Id = "444";
    }
    public override void Execute()
    {
        Debug.Log("I`m skillFour!");
    }
    //public override void OnFocus()
    //{
    //    Debug.Log("I`m showing InUI!");
    //}
}
