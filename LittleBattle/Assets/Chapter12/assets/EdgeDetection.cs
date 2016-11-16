using UnityEngine;
using System.Collections;

public class EdgeDetection : PostEffectsBase {

    public Shader edgeShader;
    public Material edgeMaterial=null;

    public Material material
    {
        get
        {
            edgeMaterial = CheckShaderAndCreateMaterial(edgeShader,edgeMaterial);
            return edgeMaterial;
        }
    }
    [Range(0.0f, 1f)]
    public float edgesOnly = 0.0f;

    public Color edgeColor = Color.black;
    public Color backgroundColor = Color.white;


	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material!=null)
        {
            material.SetFloat("_EdgeOnly",edgesOnly);
            material.SetColor("_EdgeColor",edgeColor);
            material.SetColor("_BackgroundColor", backgroundColor);
            Graphics.Blit(src,dest,material);
        }
        else
        {
            Graphics.Blit(src,dest);
        }


    }
}
