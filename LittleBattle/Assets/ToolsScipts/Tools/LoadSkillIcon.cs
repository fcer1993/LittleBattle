using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using ProtoBuf;
using ProtoDefinite;
using GameBase;

/// <summary>
/// 加载技能图标
/// </summary>
public class LoadSkillIcon
{
    static string AssetBundlesPath = Application.dataPath + "/StreamingAssets/";
    static string BundleBasePath = AssetBundlesPath + Util.GetPlatformFolder(Application.platform);
    static string defalteConfigPath = Application.dataPath + "/StreamingAssets/skillConfig";

    /// <summary>
    /// 按传入技能id顺序返回技能Icon
    /// </summary>
    /// <param name="skillIDs"></param>
    /// <returns></returns>
    public static List<Sprite> GetSprites(params string[] skillIDs)
    {
        skill_Icon skillConfig = ConfigOperation<skill_Icon>.Deserialize(defalteConfigPath);
        AssetBundle ab = AssetBundle.LoadFromFile(Util.PathADD(BundleBasePath, "ui/texture/skillicon"));

        List<Sprite> sprites = new List<Sprite>();

        for (int i = 0; i < skillIDs.Length; i++)
        {
            try
            {
                string s = skillConfig.namekeys.Find(temp => skillIDs[i] == temp.Name).Key;
                sprites.Add( ab.LoadAsset(s) as Sprite);
            }
            catch
            {
                Debug.Log("SkillIcon is Null or No Icon for thisSkill!");
            }
        }
        ab.Unload(false);
        return sprites;
    }

    /// <summary>
    /// 根据传入的参数赋值
    /// </summary>
    /// <param name="images"></param>
    /// <param name="skillMng"></param>
    public static void Set(List<Image> images, SkillMng skillMng)
    {
        skill_Icon skillConfig = ConfigOperation<skill_Icon>.Deserialize(defalteConfigPath);
        AssetBundle ab = AssetBundle.LoadFromFile(Util.PathADD(BundleBasePath, "ui/texture/skillicon"));

        for (int i = 0; i < skillMng.Count; i++)
        {
            try
            {
                string s = skillConfig.namekeys.Find(temp => skillMng[i].Id == temp.Name).Key;
                images[i].sprite = ab.LoadAsset(s) as Sprite;
            }
            catch
            {
                Debug.Log("SkillIcon is Null or No Icon for thisSkill!");
            }
        }
        ab.Unload(false);
    }
}
