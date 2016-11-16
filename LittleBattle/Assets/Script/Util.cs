using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

public class Util
{
    /// <summary>
    /// 获取平台分类
    /// </summary>
    /// <param name="target">运行时平台</param>
    /// <returns></returns>
    public static string GetPlatformFolder(RuntimePlatform target)
    {
        switch (target)
        {
            case RuntimePlatform.Android:
                return "Android";
            case RuntimePlatform.IPhonePlayer:
                return "IOS";
            case RuntimePlatform.WindowsPlayer:
            case RuntimePlatform.WindowsEditor:
                return "Windows";
            default:
                return null;
        }
    }
    /// <summary>
    /// 清理内存
    /// </summary>
    public static void ClearMemory()
    {
        Resources.UnloadUnusedAssets();
        GC.Collect();
    }
    /// <summary>
    /// 延时功能
    /// </summary>
    public static void DelayCall(float rTime, UnityEngine.Events.UnityAction rFunc)
    {
        Timing.RunCoroutine(OnDelayCall(rTime, rFunc));
    }
    /// <summary>
    /// 回调协程
    /// </summary>
    private static IEnumerator<float> OnDelayCall(float time, UnityEngine.Events.UnityAction rFunc)
    {
        yield return Timing.WaitForSeconds(time);
        if (rFunc != null) rFunc();
    }

    #region *************字符串处理*************
    /// <summary>
    /// 为路径添加“/”符号
    /// </summary>
    /// <param name="paths">路径参数</param>
    /// <returns></returns>
    public static string PathADD(params string[] paths)
    {
        string results = paths[0];
        for (int i = 1; i < paths.Length; i++)
        {
            results = results + "/" + paths[i];
        }
        return results;
    }
    /// <summary>
    /// 获取去掉\0的byte数组
    /// </summary>
    public static byte[] BytesExceptDiveZero(byte[] sBytes)
    {
        List<byte> bytes = new List<byte>();
        for (int i = 0; i < sBytes.Length; i++)
        {
            if (sBytes[i] != 0)
            {
                bytes.Add(sBytes[i]);
            }
        }
        return bytes.ToArray();
    }
    /// <summary>
    /// byte数组去掉\0并转成String
    /// </summary>
    public static string GetString(byte[] sBytes)
    {
        return System.Text.Encoding.UTF8.GetString(BytesExceptDiveZero(sBytes));
    }
    #endregion


    #region *************单位换算*************
    /// <summary>
    /// 以参数最大单位换算大小
    /// </summary>
    /// <param name="size"></param>
    /// <returns></returns>
    public static String GetReadableByteSize(double size)
    {
        String[] units = new String[] { "B", "KB", "MB", "GB", "TB", "PB" };
        double mod = 1024.0;
        int i = 0;
        while (size >= mod)
        {
            size /= mod;
            i++;
        }
        return Math.Round(size) + units[i];
    }
   #endregion


    #region *************时间*************
    /// <summary>
    /// 时间戳换算成秒
    /// </summary>
    public static DateTime GetTime(ulong timeStamp)
    {
        DateTime start = new DateTime(1970, 1, 1, 8, 0, 0);
        return start.AddSeconds(timeStamp);
    }
    /// <summary>
    /// 时间戳换算成秒
    /// </summary>
    public static DateTime GetTime(UInt32 timeStamp)
    {
        DateTime start = new DateTime(1970, 1, 1, 8, 0, 0);
        return start.AddSeconds(timeStamp);
    }
    /// <summary>
    /// 当地时间换算成时间戳
    /// </summary>
    public static long GetTime(DateTime time)
    {
        DateTime startTime = TimeZone.CurrentTimeZone.ToLocalTime(new System.DateTime(1970, 1, 1, 0, 0, 0));
        return (long)(time - startTime).TotalSeconds;
    }
    /// <summary>
    /// 协调世界时间换算成时间戳
    /// </summary>
    public static long GetTime()
    {
        TimeSpan ts = new TimeSpan(DateTime.UtcNow.Ticks - new DateTime(1970, 1, 1, 0, 0, 0).Ticks);
        return (long)ts.TotalMilliseconds;
    }
    /// <summary>
    /// 时间段换算成秒
    /// </summary>
    public static long GetTime(TimeSpan timespan)
    {
        return (long)timespan.TotalMilliseconds;
    }
    /// <summary>
    /// 获得该时间所属星期
    /// </summary>
    public static int GetWeek(DateTime nowTime)
    {
        return int.Parse(nowTime.DayOfWeek.ToString("D"));
    }
    #endregion
}