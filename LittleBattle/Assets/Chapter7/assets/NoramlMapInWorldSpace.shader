// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/NoramlMapInWorldSpace" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Bump("NormalMap",2D)="Bump"{}
		_BumpScale("_BumpScale",Float)=1.0
		_Specular("SPECULARcolor",Color)=(1,1,1,1)
		_Glossiness ("Smoothness", Range(8,256)) = 20
	}
	SubShader {
		Pass
		{
			Tags { "LightMode"="ForwardBase" }


				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "Lighting.cginc"

						
				fixed4 _Color;
				sampler2D _MainTex;
				float4 _MainTex_ST;
				sampler2D _Bump;
				float4 _Bump_ST;
				float _BumpScale;
				fixed4 _Specular;
				float _Glossiness;


				struct a2v{
					float4 vertex:POSITION;
					float3 normal:NORMAL;
					float4 tangent:TANGENT;
					float4 texcoord:TEXCOORD0;

				};
				struct v2f{
					float4 pos:SV_POSITION;
					float4 uv :TEXCOORD0;
					float4 TtoW0:TEXCOORD1;
					float4 TtoW1:TEXCOORD2;
					float4 TtoW2:TEXCOORD3;
				};
				v2f vert (a2v v){
					v2f o;
					o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
					o.uv.xy=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
					o.uv.zw=v.texcoord.xy*_Bump_ST.xy+_Bump_ST.zw;

					float3 worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;
					fixed3 worldNormal=UnityObjectToWorldNormal(v.normal);
					fixed3 worldTangent=UnityObjectToWorldDir(v.tangent.xyz);
					fixed3 worldBinormal=cross(worldNormal,worldTangent)*v.tangent.w;
					o.TtoW0=float4(worldTangent.x,worldBinormal.x,worldNormal.x,worldPos.x);
					o.TtoW1=float4(worldTangent.y,worldBinormal.y,worldNormal.y,worldPos.y);
					o.TtoW2=float4(worldTangent.z,worldBinormal.z,worldNormal.z,worldPos.z);
					return o;
				}
				fixed4 frag(v2f i):SV_TARGET0{
					//fixed3 tangentlightdir=normalize(i.lightdir);
					//fixed3 tangentviewdir=normalize(i.viewdir);

					//fixed4 packedNormal=tex2D(_Bump,i.uv.zw);
					//fixed3 tangentnormal;
					//tangentnormal=UnpackNormal(packedNormal);
					//tangentnormal.xy*=_BumpScale;
					//tangentnormal.z=sqrt(1.0-saturate(dot(tangentnormal.xy,tangentnormal.xy)));
					//fixed3 Albedo=tex2D(_MainTex,i.uv).rgb*_Color.rgb;
					//fixed3 Ambient=UNITY_LIGHTMODEL_AMBIENT.xyz*Albedo;
					//fixed3 DIFFUSE=_LightColor0.rgb*Albedo*max(0,dot(tangentnormal,tangentlightdir));
					//fixed3 halfdir=normalize(tangentlightdir+tangentviewdir);
					//fixed3 SPECULAR=_LightColor0.rgb*_Specular.rgb*pow(max(0,dot(tangentnormal,halfdir)),_Glossiness)*10.0f;
					//return fixed4(Ambient+DIFFUSE+SPECULAR,1.0);//
					////////////////////////////////////////////////////////
					float3 worldPos=float3(i.TtoW0.w,i.TtoW1.w,i.TtoW2.w);
					fixed3 lightdir=normalize(UnityWorldSpaceLightDir(worldPos));
					fixed3 viewdir=normalize(UnityWorldSpaceViewDir(worldPos));

					fixed3 bump=UnpackNormal(tex2D(_Bump,i.uv.zw));
					bump.xy*=_BumpScale;
					bump.z=sqrt(1-saturate(dot(bump.xy,bump.xy)));
					bump=normalize(half3(dot(i.TtoW0.xyz,bump),dot(i.TtoW1.xyz,bump),dot(i.TtoW2.xyz,bump)));

					fixed3 Albedo=tex2D(_MainTex,i.uv).rgb*_Color.rgb;
					fixed3 Ambient=UNITY_LIGHTMODEL_AMBIENT.xyz*Albedo;
					fixed3 DIFFUSE=_LightColor0.rgb*Albedo*max(0,dot(bump,lightdir));
					fixed3 halfdir=normalize(lightdir+viewdir);
					fixed3 SPECULAR=_LightColor0.rgb*_Specular.rgb*pow(max(0,dot(bump,halfdir)),_Glossiness)*10.0f;
					return fixed4(Ambient+DIFFUSE+SPECULAR,1.0);
					////////////////////////////////
					//return fixed4(1,1,1,1);
				}

				ENDCG
			}
			
		}
		FallBack "SPECULAR"
}
