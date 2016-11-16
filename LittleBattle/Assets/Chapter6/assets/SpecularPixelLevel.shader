// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/SpecularPixelLevel" {
	Properties {
		_Diffuse("DIFFUSE",Color)=(1,1,1,1)
		_Specular("SPECULAR",Color)=(1,1,1,1)
		_Gloss("GLOSS",Range(8.0,256.0))=20
	}
	SubShader {
		Pass{
			Tags{"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;

			struct a2v{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
			};
			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldnormal:TEXCOORD0;
				float3 worldpos:TEXCOORD1;
			};

			v2f vert(a2v v){
				v2f o;
				o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
				float3 worldnormal=normalize( mul(v.normal,(float3x3)unity_WorldToObject));
				o.worldnormal=worldnormal;
				o.worldpos=mul(unity_ObjectToWorld,v.vertex);
				return o;
			}
			float4 frag(v2f f):SV_TARGET0{

				float3 worldlight=normalize(_WorldSpaceLightPos0.xyz);
				fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.rgb;//环境光颜色
				fixed3 diffuse=_LightColor0.rgb*_Diffuse.rgb*saturate(dot(f.worldnormal,worldlight));//漫反射颜色

				fixed3 ref=normalize(reflect(-(worldlight),f.worldnormal));
				fixed3 viewdir=normalize(_WorldSpaceCameraPos.xyz-f.worldpos.xyz);
				fixed3 specular=_LightColor0.rgb*_Specular*pow( saturate(dot(viewdir,ref)),_Gloss);//高光颜色

				fixed3 color=ambient+diffuse+specular;
				return(float4(color,1.0));
			}
			ENDCG
		}
		
	}
	FallBack "Diffuse"
}
