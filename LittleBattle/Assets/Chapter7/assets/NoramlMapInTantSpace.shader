Shader "Custom/NoramlMapInTantSpace" {
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
					float3 lightdir:TEXCOORD1;
					float3 viewdir:TEXCOORD2;
				};
				v2f vert (a2v v){
					v2f o;
					o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
					o.uv.xy=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
					o.uv.zw=v.texcoord.xy*_Bump_ST.xy+_Bump_ST.zw;

					//float3 BINORMAL=cross(normalize(v.normal),normalize(v.tangent.xyz))*v.tangent.w;
					//float3x3 rotation=float3x3(v.tangent.xyz,BINORMAL,v.normal);
					TANGENT_SPACE_ROTATION;
					o.lightdir=mul(rotation,ObjSpaceLightDir(v.vertex)).xyz;
					o.viewdir=mul(rotation,ObjSpaceViewDir(v.vertex)).xyz;
					return o;
				}
				fixed4 frag(v2f i):SV_TARGET0{
					fixed3 tangentlightdir=normalize(i.lightdir);
					fixed3 tangentviewdir=normalize(i.viewdir);

					fixed4 packedNormal=tex2D(_Bump,i.uv.zw);
					fixed3 tangentnormal;
					tangentnormal=UnpackNormal(packedNormal);
					tangentnormal.xy*=_BumpScale;
					tangentnormal.z=sqrt(1.0-saturate(dot(tangentnormal.xy,tangentnormal.xy)));
					fixed3 Albedo=tex2D(_MainTex,i.uv).rgb*_Color.rgb;
					fixed3 Ambient=UNITY_LIGHTMODEL_AMBIENT.xyz*Albedo;
					fixed3 DIFFUSE=_LightColor0.rgb*Albedo*max(0,dot(tangentnormal,tangentlightdir));
					fixed3 halfdir=normalize(tangentlightdir+tangentviewdir);
					fixed3 SPECULAR=_LightColor0.rgb*_Specular.rgb*pow(max(0,dot(tangentnormal,halfdir)),_Glossiness)*10.0f;
					return fixed4(Ambient+DIFFUSE+SPECULAR,1.0);//
				}
				ENDCG
			}
			
		}
		FallBack "SPECULAR"
}
