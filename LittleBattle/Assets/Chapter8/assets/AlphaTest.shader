// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/AlphaTest"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color("ColorTint",Color)=(1,1,1,1)
		_Cutoff("AlphaCutoff",Range(0,1))=0.5
	}
	SubShader
	{
		Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest" "IgnoreProjector"="True" }
		Cull Off

		Pass
		{
		Tags{"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			float _Cutoff;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal:NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
				float3 worldnormal:TEXCOORD1;
				float3 worldpos:TEXCOORD2;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
				o.worldnormal=UnityObjectToWorldNormal(v.normal);
				o.worldpos=mul(unity_ObjectToWorld,v.vertex).xyz;
				o.uv=TRANSFORM_TEX(v.uv,_MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 worldnormal=normalize(i.worldnormal);
				fixed3 worldlight=normalize(UnityWorldSpaceLightDir(i.worldpos));
				fixed4 texColor=tex2D(_MainTex,i.uv);

				clip(texColor.a-_Cutoff);

				fixed3 Albedo=texColor.rgb*_Color.rgb;
				fixed3 Ambient=UNITY_LIGHTMODEL_AMBIENT.rgb*Albedo;
				fixed3 DIFFUSE=_LightColor0.rgb*Albedo*max(0,dot(worldnormal,worldlight));
				return fixed4(Ambient+DIFFUSE,1);
			}
			ENDCG
		}
	}
}
