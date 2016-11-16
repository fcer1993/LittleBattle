using UnityEngine;
using System.Collections;

public class BrightnessSaturationAndContrast : PostEffectsBase {

    public Shader bristctSahder;
    public Material bristctMaterial;
    public Material material
    {
        get
        {
            bristctMaterial = CheckShaderAndCreateMaterial(bristctSahder,bristctMaterial);
            return bristctMaterial;
        }
    }
    [Range(0.0f, 3.0f)]
    public float brightness = 1.0f;
    [Range(0.0f, 3.0f)]
    public float saturation = 1.0f;
    [Range(0.0f, 3.0f)]
    public float contrast = 1.0f;

	// Use this for initialization
	void Start () {
        
	}
	
	// Update is called once per frame
	void Update () {
	
	}
    void OnRenderImage(RenderTexture src,RenderTexture dest)
    {
        if (material!=null)
        {
            material.SetFloat("_Brightness",brightness);
            material.SetFloat("_Saturation", saturation);
            material.SetFloat("_Contrast", contrast);
            Graphics.Blit(src,dest,material);
        }
        else
        {
            Graphics.Blit(src,dest);
        }
    }
}
