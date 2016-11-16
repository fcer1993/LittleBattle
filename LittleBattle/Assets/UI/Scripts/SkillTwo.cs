using UnityEngine;
using System.Collections;
using GameBase;

public class SkillTwo : SkillBase
{
    public SkillTwo()
    {
        Id = "222";
    }
    public override void Execute()
    {
        Debug.Log("I`m skillTwo!");
    }
    //public override void ShowInUI()
    //{
    //    Debug.Log("I`m showing InUI!");
    //}
}
