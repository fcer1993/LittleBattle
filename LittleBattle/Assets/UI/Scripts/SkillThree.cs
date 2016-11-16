using UnityEngine;
using System.Collections;
using GameBase;

public class SkillThree : SkillBase
{
    public SkillThree()
    {
        Id = "333";
    }
    public override void Execute()
    {
        Debug.Log("I`m skillThree!");
    }
    //public override void ShowInUI()
    //{
    //    Debug.Log("I`m showing InUI!");
    //}
}
