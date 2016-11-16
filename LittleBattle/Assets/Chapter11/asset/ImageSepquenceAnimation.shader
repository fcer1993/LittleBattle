Shader "Custom/ImageSepquenceAnimation" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_HorizontalAmount("HorizontalAmount",float)=8
		_VerticalAmount("VerticalAmount",float)=8
		_Speed("Speed",Range(1,100))=30
	}
	SubShader {
			Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector"="True" }

		Pass{
		Tags { "LightMode"="ForwardBase" }
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma vertex vert 
		#pragma fragment frag
		#include "UnityCG.cginc"

		fixed4 _Color;
		sampler2D _MainTex;
		fixed4 _MainTex_ST;
		float _HorizontalAmount;
		float _VerticalAmount;
		float _Speed;

		struct a2v{
			float4 vertex:POSITION;
			float4 texcoord:TEXCOORD0;

		};

		struct v2f{
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;

		};

		v2f vert(a2v v){
			v2f o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);
			//o.uv=v.texcoord.xy* _MainTex_ST.xy+ _MainTex_ST.zw;
			return o;
		}
		fixed4 frag(v2f i):SV_TARGET0{
			float time=floor(_Time.y*_Speed);
			float row=floor(time/_HorizontalAmount);
			float colum=time-row*_HorizontalAmount;

			//对贴图进行offset,位移操作
			half2 uv=i.uv+half2(colum,-row);
			//对贴图进行tilling缩放操作
			uv.x/=_HorizontalAmount;
			uv.y/=_VerticalAmount;

			fixed4 c=tex2D(_MainTex,uv);
			c.rgb*=_Color;

			return c;
		}

		ENDCG

		}

	} 
	FallBack "Diffuse"
}
