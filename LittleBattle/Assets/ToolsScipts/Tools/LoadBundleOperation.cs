using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using ProtoBuf;
using ProtoDefinite;

public class LoadBundleOperation
{
    static string AssetBundlesPath = Application.dataPath + "/StreamingAssets/";
    static string BundleBasePath = AssetBundlesPath + Util.GetPlatformFolder(Application.platform);
    //bundle-asset配置文件路径
    static string defalteConfigPath = Application.dataPath + "/StreamingAssets/bundleConfig";

    /// <summary>
    /// 根据资源名称加载Bundle
    /// </summary>
    /// <param name="AssetName"><para>资源名需要后缀,以区分不同类型但名字相同的资源</para>
    /// <para>虽然资源名可以是全路径名，大小写不区分，但是在读配置文件时需要大小写，及仅需</para>
    /// <para>全名，并且资源名字命名中不应该有类似Cube/cube这样的命名存在</para></param>
    // 这是在所有资源都是最新的情况下，而资源的更新在打开应用的时候，检查版本，资源版本，以及新资源
    public static GameObject LoadBundle(string AssetName)
    {
        if (string.IsNullOrEmpty(AssetName))
        {
            Debug.Log("AssetName is Null.");
            return null;
        }

        //从bundle配置文件中找到资源对应的bundle名
        string BundleName = null;
        bundle_Asset bundleConfig = ConfigOperation<bundle_Asset>.Deserialize(defalteConfigPath);

        try
        {
            BundleName = bundleConfig.namekeys.Find(temp => AssetName == (temp.Name.Substring(temp.Name.LastIndexOf('/') + 1))).Key;
        }
        catch
        {
            Debug.Log("BundleName is Null or No Bundle for thisAsset");
            return null;
        }

        //获取根bundle文件，并取得bundle的根链表
        AssetBundle baseBundle = AssetBundle.LoadFromFile(Util.PathADD(BundleBasePath, Util.GetPlatformFolder(Application.platform)));
        AssetBundleManifest mainfest = (AssetBundleManifest)baseBundle.LoadAsset("AssetBundleManifest");
        baseBundle.Unload(false);

        //加载该bundle所需依赖bundle
        List<string> dps = mainfest.GetAllDependencies(BundleName).ToList();
        List<AssetBundle> dpBundles = new List<AssetBundle>();
        foreach (var dpBundleName in dps)
        {
            dpBundles.Add(AssetBundle.LoadFromFile(Util.PathADD(BundleBasePath, dpBundleName)));
        }
        //加载目标bundle
        AssetBundle targetBundle = AssetBundle.LoadFromFile(Util.PathADD(BundleBasePath, BundleName));
        GameObject targetObj = targetBundle.LoadAsset(AssetName) as GameObject;
        //释放加载的bundle
        targetBundle.Unload(false);
        foreach (var ab in dpBundles)
        {
            ab.Unload(false);
        }

        if (targetObj != null)
            return MonoBehaviour.Instantiate(targetObj);
        else return null;
    }
}