using UnityEngine;
using ProtoBuf;
using ProtoDefinite;
using System.Reflection;
using System.Linq;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 序列化与反序列化工具，需要文件（资源）名。
/// </summary>
/// <typeparam name="T">配置文件的格式</typeparam>
public class ConfigOperation<T> 
{
    public static void Serialize(string _path, T t)
    {
        using (var file = System.IO.File.Create(_path))
        {
            Serializer.Serialize(file, t);
        }
    }
    public static T Deserialize(string _path)
    {
        using (var file = System.IO.File.OpenRead(_path))
        {
           return Serializer.Deserialize<T>(file);
        }
    }
}
/// <summary>
/// 反射机制动态序列反序列化
/// </summary>
public class ConfigOperation
{
    private static string defaltePath = Application.dataPath + "/Resourses";

    public static void CreateConfig(System.Type type,string _path)
    {
        using (var file = System.IO.File.OpenRead(_path))
        {
           // return Serializer.Deserialize<type>(file);
        }
    }
    
}



