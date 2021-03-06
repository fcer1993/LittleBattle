﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/SpecularVertexLevel" {
	Properties{
		_Diffuse("DIFFUSE",Color)=(1,1,1,1)
		_Specular("SPECULAR",Color)=(1,1,1,1)
		_Gloss("GLOSS",Range(8.0,256.0))=20
	}

	SubShader{
		
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
				fixed3 color:Color;
			};

			v2f vert(a2v v){
				v2f o;
				o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
				fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.rgb;

				float3 worldnormal=normalize( mul(v.normal,(float3x3)unity_WorldToObject));
				float3 worldlight=normalize(_WorldSpaceLightPos0.xyz);
				fixed3 diffuse=_LightColor0.rgb*_Diffuse.rgb*saturate(dot(worldnormal,worldlight));//漫反射颜色

				fixed3 ref=normalize(reflect(-(worldlight),worldnormal));
				fixed3 viewdir=normalize(_WorldSpaceCameraPos.xyz-mul(unity_ObjectToWorld,v.vertex).xyz);
				fixed3 specular=_LightColor0.rgb*_Specular*pow( saturate(dot(viewdir,ref)),_Gloss);

				o.color=ambient+diffuse+specular;
				return o;
			}
			float4 frag(v2f f):SV_TARGET0{

				return(float4(f.color,1.0));
			}
			ENDCG
		}
		
	}
	FallBack"Specular"
}
