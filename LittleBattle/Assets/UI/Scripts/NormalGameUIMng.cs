using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using GameBase;
using ProtoBuf;
using ProtoDefinite;


public class NormalGameUIMng : MonoBehaviour
{
    public List<Image> skills;

    SkillMng skillMng = new SkillMng(4);
    // Use this for initialization
    void Start()
    {
        skillMng.Add(new SkillOne());
        skillMng.Add(new SkillTwo());
        skillMng.Add(new SkillThree());
        skillMng.Add(new SkillFour());

        LoadSkillIcon.Set(skills,skillMng);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Q))
        {
            skillMng[0].Execute();
        }
        if (Input.GetKeyDown(KeyCode.W))
        {
            skillMng[1].Execute();
        }
        if (Input.GetKeyDown(KeyCode.E))
        {
            skillMng[2].Execute();
        }
        if (Input.GetKeyDown(KeyCode.R))
        {
            skillMng[3].Execute();
        }

    }
}
