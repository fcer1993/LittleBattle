using UnityEngine;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using System.IO;
using ProtoBuf;
using ProtoDefinite;

/// <summary>
/// 计算bundle分包所定义的结构体
/// </summary>
public struct BuildCell
{
    /// <summary>
    /// 被依赖的次数
    /// </summary>
    public int referenceCount;
    /// <summary>
    /// 资源名
    /// </summary>
    public string assetName;
    /// <summary>
    /// bundle名
    /// </summary>
    public string bundleName;

    public BuildCell(int _count, string _assetName, string _bundleName)
    {
        referenceCount = _count;
        assetName = _assetName;
        bundleName = _bundleName;
    }
    public BuildCell(int _count, string _assetName) : this(_count, _assetName, null)
    {

    }
}
/// <summary>
/// 把选定的资源拆包后打包到StreamingAssets目录下
/// </summary>
public class BundleOperation
{
    static string AssetBundlesOutputPath = Application.dataPath + "/StreamingAssets";
    public static List<BuildCell> assetList = new List<BuildCell>();
    /// <summary>
    /// 计算Bundle分包
    /// </summary>
    [MenuItem("Tools/PackBundle")]
    public static void Calculate()
    {
        assetList.Clear();

        string sourcePath = EditorUtility.OpenFolderPanel("SeletionPanel", Application.dataPath, "");

        if (string.IsNullOrEmpty(sourcePath))
        {
            Debug.Log("路径为空！！");
            return;
        }
        Pack(sourcePath);

        #region 遍历所有要打包的资源，计算出被直接引用的次数
        foreach (BuildCell bc in assetList)
        {
            //获取的直接依赖中有自己
            foreach (var dps in AssetDatabase.GetDependencies(bc.assetName, false))
            {
                if (dps == bc.assetName)
                {
                    continue;
                }
                else
                {
                    //将被直接依赖资源的计数器加1（在父级的其他依赖中没有我，则为直接依赖）
                    int dpsBCint = assetList.FindIndex(temp => temp.assetName == dps);
                    if (dpsBCint >= 0)
                    {
                        assetList[dpsBCint] = new BuildCell(assetList[dpsBCint].referenceCount + 1, assetList[dpsBCint].assetName, null);
                    }
                }
            }
        }
        #endregion

        #region 给资源设置AssetBundleName
        foreach (BuildCell bc in assetList)
        {
            if (bc.bundleName != null)
                continue;
            if (bc.referenceCount == 0 || bc.referenceCount >= 2)
            {
                //在代码中给资源设置AssetBundleName
                AssetImporter assetImporter = AssetImporter.GetAtPath(bc.assetName);
                //string assetName = AssetDatabase.AssetPathToGUID(_assetPath);
                string bundleName = bc.assetName.Replace("Assets/", "").Replace(Path.GetExtension(bc.assetName), "").ToLower();
                assetList[assetList.IndexOf(bc)] = new BuildCell(bc.referenceCount, bc.assetName, bundleName);
                assetImporter.assetBundleName = bundleName;
                //收索直接依赖中被依赖数为1的资源，
                //将所有直接依赖中被依赖数为1的资源的bundle名设为父bundle名。
                SearchDPS(bc.assetName, bundleName);
            }
        }
        #endregion

        #region 将资源名和bundle名作配置表
        bundle_Asset baConfig = new bundle_Asset();
        foreach (var bc in assetList)
        {
            NameKey nk = new NameKey();
            nk.Name = bc.assetName;
            nk.Key = bc.bundleName;
            baConfig.namekeys.Add(nk);
        }
        if (!File.Exists(AssetBundlesOutputPath + "/bundleConfig"))
        {
            File.Create(AssetBundlesOutputPath + "/bundleConfig");
        }
        ConfigOperation<bundle_Asset>.Serialize(AssetBundlesOutputPath + "/bundleConfig", baConfig);
        #endregion

        #region 打包
        string outputPath = Path.Combine(AssetBundlesOutputPath, GetPlatformFolder(EditorUserBuildSettings.activeBuildTarget));
        if (!Directory.Exists(outputPath))
        {
            Directory.CreateDirectory(outputPath);
        }

        //根据BuildSetting里面所激活的平台进行打包
        BuildPipeline.BuildAssetBundles(outputPath, BuildAssetBundleOptions.UncompressedAssetBundle, EditorUserBuildSettings.activeBuildTarget);

        AssetDatabase.Refresh();

        Debug.Log("打包完成");
        #endregion


    }

    [MenuItem("Tools/PackOne")]
    public static void PackOne()
    {
        assetList.Clear();

        string sourcePath = EditorUtility.OpenFolderPanel("SeletionPanel", Application.dataPath, "");

        if (string.IsNullOrEmpty(sourcePath))
        {
            Debug.Log("路径为空！！");
            return;
        }

        Pack(sourcePath);

        #region 将该文件夹作为bundleName，并将该文件夹下所有文件作为资源放入这个bundle
        string bundleName = sourcePath.Replace(Application.dataPath + "/","").ToLower();
        foreach (BuildCell bc in assetList)
        {
            //在代码中给资源设置AssetBundleName
            AssetImporter assetImporter = AssetImporter.GetAtPath(bc.assetName);
            assetImporter.assetBundleName = bundleName;
        }
        #endregion

        //这里不写打包语句，是因为在所有打包的地方会执行将有bundleName的资源都进行打包。
    }

    [MenuItem("Tools/ClearBundleNames")]
    public static void ClearBundleNames()
    {
        ClearAssetBundlesName();
    }
    /// <summary>
    /// 递归寻找所有该放入一个bundle的资源
    /// </summary>
    /// <param name="_path"></param>
    /// <param name="fatherBundleName"></param>
    private static void SearchDPS(string _path, string fatherBundleName)
    {
        foreach (var dps in AssetDatabase.GetDependencies(_path, false))
        {
            if (dps == _path)
                continue;
            BuildCell _bc = assetList.Find(temp => temp.assetName == dps);
            if (_bc.referenceCount == 1)
            {
                AssetImporter assetImporterdps = AssetImporter.GetAtPath(_bc.assetName);
                assetList[assetList.IndexOf(_bc)] = new BuildCell(_bc.referenceCount, _bc.assetName, fatherBundleName);
                assetImporterdps.assetBundleName = fatherBundleName;
                SearchDPS(dps, fatherBundleName);
            }
        }
    }

    /// <summary>
    /// 清除之前设置过的AssetBundleName，避免产生不必要的资源也打包
    /// 之前说过，只要设置了AssetBundleName的，都会进行打包，不论在什么目录下 
    /// </summary>
    private static void ClearAssetBundlesName()
    {
        int length = AssetDatabase.GetAllAssetBundleNames().Length;
        //Debug.Log(length);
        string[] oldAssetBundleNames = new string[length];
        for (int i = 0; i < length; i++)
        {
            oldAssetBundleNames[i] = AssetDatabase.GetAllAssetBundleNames()[i];
        }

        for (int j = 0; j < oldAssetBundleNames.Length; j++)
        {
            AssetDatabase.RemoveAssetBundleName(oldAssetBundleNames[j], true);
        }
        length = AssetDatabase.GetAllAssetBundleNames().Length;
        Debug.Log("ClearedName!");
    }

    /// <summary>
    /// 将所有Asset写入列表
    /// </summary>
    /// <param name="source"></param>
    private static void Pack(string source)
    {
        DirectoryInfo folder = new DirectoryInfo(source);
        FileSystemInfo[] files = folder.GetFileSystemInfos();
        int length = files.Length;
        for (int i = 0; i < length; i++)
        {
            if (files[i] is DirectoryInfo)
            {
                Pack(files[i].FullName);
            }
            else
            {
                if (!files[i].Name.EndsWith(".meta"))
                {
                    //从Asset文件夹开始的路径
                    string trueName = "Assets" + Replace(files[i].FullName).Replace(Application.dataPath, "");
                    //将所有依赖包括自己放入列表,dps 是资源从Asset开始的路径
                    foreach (var dps in AssetDatabase.GetDependencies(trueName))
                    {
                        assetList.Add(new BuildCell(0, dps));
                    }
                }
            }
        }
        //去重
        assetList = assetList.Distinct().ToList();
    }
    private static string Replace(string s)
    {
        return s.Replace(@"\", "/");
    }

    private static string GetPlatformFolder(BuildTarget target)
    {
        switch (target)
        {
            case BuildTarget.Android:
                return "Android";
            case BuildTarget.iOS:
                return "IOS";
            case BuildTarget.StandaloneWindows:
            case BuildTarget.StandaloneWindows64:
                return "Windows";
            default:
                return null;
        }
    }
}










