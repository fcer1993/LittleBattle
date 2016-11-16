using UnityEngine;
using System.Collections;

public class EDGDetectByDepthAndNormal : PostEffectsBase {

    public Shader edgeDetectShader;
    public GameObject obj;

    private Material edgeDetectMaterial = null;
    private Mesh mesh=new Mesh();
    private Matrix4x4 matri=new Matrix4x4();
    public RenderTexture pretexture;
    public Material material
    {
        get
        {
            edgeDetectMaterial = CheckShaderAndCreateMaterial(edgeDetectShader, edgeDetectMaterial);
            return edgeDetectMaterial;
        }
    }

    [Range(0.0f, 1.0f)]
    public float edgesOnly = 0.0f;

    public Color edgeColor = Color.black;

    public Color backgroundColor = Color.white;

    public float sampleDistance = 1.0f;
        [Range(0.0f, 1.0f)]
    public float sensitivityDepth = 1.0f;
        [Range(0.0f, 1.0f)]
    public float sensitivityNormals = 1.0f;

    void OnEnable()
    {
        GetComponent<Camera>().depthTextureMode |= DepthTextureMode.DepthNormals;
    }
    void Strat()
    {
       
    }

    [ImageEffectOpaque]//在所有不透明物体渲染后
    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {

        //src = pretexture;
        //Graphics.DrawMeshNow(obj.GetComponent<MeshFilter>().sharedMesh,obj.transform.position,obj.transform.rotation );

        if (material != null)
        {
            material.SetFloat("_EdgeOnly", edgesOnly);
            material.SetColor("_EdgeColor", edgeColor);
            material.SetColor("_BackgroundColor", backgroundColor);
            material.SetFloat("_SampleDistance", sampleDistance);
            material.SetVector("_Sensitivity", new Vector4(sensitivityNormals, sensitivityDepth, 0.0f, 0.0f));

            //Graphics.Blit(src,pretexture);

            Graphics.Blit(src, dest, material);
            //pretexture = dest;
            //Graphics.Blit(pretexture, dest);


        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
