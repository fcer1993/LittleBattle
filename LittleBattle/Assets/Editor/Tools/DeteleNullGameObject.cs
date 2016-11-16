using UnityEngine;
using UnityEditor;
using System.Linq;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 删除无用的空物体
/// </summary>
public class DeteleNullGameObject
{
    /// <summary>
    /// 如果名字中包含需要的关键字则保留
    /// </summary>
    private static string[] needNames = { "GameObject2" };

    [MenuItem("Tools/DeleteNullGameObj")]
    public static void DeleteNullGameObj()
    {   
        foreach (var child in Selection.gameObjects)
        {
            DltNullGameObjDps(child.transform);
        }
    }
    public static void DltNullGameObjDps(Transform _child)
    {
        foreach (Transform crt in _child.transform)
        {
            DltNullGameObjDps(crt);
            //Debug.Log(crt.name + Contains(crt.name));
            if (crt.GetComponents<Component>().Length == 1 &&
                crt.childCount == 0 &&
                !Contains(crt.name))
            {
                MonoBehaviour.DestroyImmediate(crt.gameObject);
            }
        }
    }
    public static bool Contains(string _crtName)
    {
        foreach(var s in needNames)
        {
            if (_crtName.Contains(s))
            {
                return true;
            } 
        }
        return false;
    } 
}
