// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/RampTexture"
{
	Properties{
	_Color("ClolorTint",Color)=(1,1,1,1)
	_RampTex("RampTexture",2D)="white"{}
	_SpecularLightColor("SPECULARColor",Color)=(1,1,1,1)
	_Glossiness("Gloss",Range(8.0,256))=20
	}

	SubShader{
		Pass
		{
			Tags{"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _RampTex;
			float4 _RampTex_ST;
			fixed4 _SpecularLightColor;
			float _Glossiness;

			struct a2v{
				float4 vertex:POSITION;
				float4 normal:NORMAL;
				float4 texcoord:TEXCOORD0;
			};
			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				float2 uv:TEXCOORD2;
			};
			v2f vert(a2v v){
				v2f o;
				o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
				o.worldNormal=UnityObjectToWorldNormal(v.normal);
				o.worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;
				o.uv=TRANSFORM_TEX(v.texcoord,_RampTex);
				return o;
			}
			fixed4 frag(v2f i):SV_TARGET0{
				fixed3 worldNormal=normalize(i.worldNormal);
				fixed3 worldLightDir=normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 Ambient=UNITY_LIGHTMODEL_AMBIENT.rgb;

				fixed halfLambert=0.5*dot(worldNormal,worldLightDir)+0.5;
				fixed3 diffusecolor=tex2D(_RampTex,fixed2(halfLambert,halfLambert)).rgb*_Color.rgb;
				fixed3 DIFFUSE=_LightColor0.rgb*diffusecolor;
				fixed3 viewdir=normalize(UnityWorldSpaceViewDir(i.worldPos));
				fixed3 halfDir=normalize(worldLightDir+viewdir);
				fixed3 SPECULAR=_LightColor0.rgb*_SpecularLightColor*pow(max(0,dot(worldNormal,halfDir)),_Glossiness);

				return fixed4(Ambient+DIFFUSE+SPECULAR,1.0);
			}
			ENDCG
		}

	}
	FallBack "DIFFUSE"
}