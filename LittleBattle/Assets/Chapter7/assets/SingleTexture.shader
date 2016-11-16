// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/SingleTexture" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex("Main Tex",2D)="white"{}
		_Specular("Specular",Color)=(1,1,1,1)
		_Glossiness("gloss",Range(8.0,256))=20
	}
	SubShader {
		Pass{
			Tags{"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Specular;
			float _Glossiness;

			struct a2v{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
				float4 texcoord:TEXCOORD0;
			};
			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldnormal:TEXCOORD0;
				float3 worldpos:TEXCOORD1;
				float2 uv:TEXCOORD2;
			};

			v2f vert(a2v v){
				v2f o;
				o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
				o.worldnormal=UnityObjectToWorldNormal(v.normal);
				o.worldpos=mul(unity_ObjectToWorld,v.vertex).xyz;
				o.uv=v.texcoord.xy* _MainTex_ST.xy+ _MainTex_ST.zw;
				return o;
			}
			float4 frag(v2f f):SV_TARGET{
				fixed3 worldnormal=normalize(f.worldnormal);
				fixed3 worldLightdir=normalize(UnityWorldSpaceLightDir(f.worldpos));
				fixed3 viewdir=normalize(UnityWorldSpaceViewDir(f.worldpos));

				fixed3 Albedo=tex2D(_MainTex,f.uv).rgb*_Color.rgb;
				fixed3 Ambient=UNITY_LIGHTMODEL_AMBIENT.rgb*Albedo;
				fixed3 diffuse=_LightColor0.rgb*Albedo*max(0,dot(worldnormal,worldLightdir));
				
				fixed3 halfdir=normalize(worldLightdir+viewdir);

				fixed3 specular=_LightColor0.rgb*_Specular.rbg*pow(saturate(dot(worldnormal,halfdir)),_Glossiness);
				
				return fixed4(Ambient+diffuse+specular,1);
			}



			ENDCG
		}
	}
	FallBack "SPECULAR"
}
