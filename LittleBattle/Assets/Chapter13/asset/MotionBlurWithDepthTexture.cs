using UnityEngine;
using System.Collections;

public class MotionBlurWithDepthTexture : PostEffectsBase {

    public Shader motionBlurShader;
    private Material motionBlurMaterial=null;

    public Material material
    {
        get
        {
            motionBlurMaterial = CheckShaderAndCreateMaterial(motionBlurShader,motionBlurMaterial);
            return motionBlurMaterial;
        }
    }
    [Range(0.0f, 1.0f)]
    public float blurSize = 0.5f;
    private Camera mycamera;
    public Camera camera
    {
        get
        {
            if (!mycamera)
            {
                mycamera=GetComponent<Camera>();
               
            }
            return mycamera;
        }
    }
    private Matrix4x4 previousViewProjectionMatrix;

    void OnEnable()
    {
        camera.depthTextureMode |= DepthTextureMode.Depth;
        previousViewProjectionMatrix = camera.projectionMatrix * camera.worldToCameraMatrix;
    }
    void OnRenderImage(RenderTexture src,RenderTexture dest)
    {
        if (material != null)
        {
            material.SetFloat("_BlurSize", blurSize);

            material.SetMatrix("_PreviousViewProjectionMatrix", previousViewProjectionMatrix);
            Matrix4x4 currentViewProjectionMatrix = camera.projectionMatrix * camera.worldToCameraMatrix;//当前视图*投影矩阵
            Matrix4x4 currentViewProjectionInverseMatrix = currentViewProjectionMatrix.inverse;//当前视图*投影矩阵的逆矩阵
            material.SetMatrix("_CurrentViewProjectionInverseMatrix", currentViewProjectionInverseMatrix);
            previousViewProjectionMatrix = currentViewProjectionMatrix;

            Graphics.Blit(src, dest, material);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
