Shader "Custom/AtestForFun/Ztest3" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		
	}
	SubShader {
		Tags{}
		LOD 300
		Pass{
		Tags{}
		
		ColorMask RGB
		CGPROGRAM 
		#pragma vertex vert
		#pragma fragment frag 
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		float _Glossiness;
		struct v2f{
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;

		};

		v2f vert(appdata_base v){
			v2f o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.uv=v.texcoord;
			return o;
		}
		fixed4 frag(v2f i):SV_TARGET0{
			fixed4 color=tex2D(_MainTex,i.uv);
			clip(color.a-_Glossiness);
			return fixed4(color);
		}
		ENDCG
		}
	} 
	FallBack "Diffuse"
}
