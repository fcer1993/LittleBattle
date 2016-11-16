Shader "Custom/Sakura0" {
	Properties {
		
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Brightness("Brightness",float)=1
		_Saturation("Saturation",float)=1
		_Contrast("Contrast",float)=1
		
	}
	SubShader {
		Pass{
			ZTest Always
			Cull Off
			ZWrite Off 
			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag 
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float _Brightness;
			float _Saturation;
			float _Contrast;

			//struct a2v{
			//	float4 vertex:POSITION;
			//	float4 texcoord:TEXCOORD0;
			//};

			struct v2f{
				float4 pos:POSITION;
				fixed2 uv:TEXCOORD0;

			};

			v2f vert(appdata_img v){
				v2f o;
				o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
				o.uv=v.texcoord;
				return o;

			}

			fixed4 frag(v2f i):SV_TARGET0{
				fixed4 rendertex=tex2D(_MainTex,i.uv);
				//应用亮度
				fixed3 finalcolor=rendertex.rgb*_Brightness;
				//应用饱和度
				fixed luminace=0.2125*rendertex.r+0.7145*rendertex.g+0.0721*rendertex.b;
				fixed3 luminacecolor=fixed3(luminace,luminace,luminace);
				finalcolor=lerp(luminacecolor,finalcolor,_Saturation);
				//应用对比度
				fixed3 avgcolor=fixed3(0.5,0.5,0.5);
				finalcolor=lerp(avgcolor,finalcolor,_Contrast);
				return fixed4(finalcolor,rendertex.a);

			}
			ENDCG
		}
	} 
	FallBack off
}
