Shader "Custom/Chapter15/FogWithNoise" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_FogDensity ("Fog Density", Float) = 1.0
		_FogColor ("Fog Color", Color) = (1, 1, 1, 1)
		_FogStart ("Fog Start", Float) = 0.0
		_FogEnd ("Fog End", Float) = 1.0
		_NoiseTex ("Noise Texture", 2D) = "white" {}
		_FogXSpeed ("Fog Horizontal Speed", Float) = 0.1
		_FogYSpeed ("Fog Vertical Speed", Float) = 0.1
		_NoiseAmount ("Noise Amount", Float) = 1
	}
	SubShader {
		CGINCLUDE
		
		#include "UnityCG.cginc"
		
		float4x4 _FrustumCornersRay;
		
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
		sampler2D _CameraDepthTexture;
		half _FogDensity;
		fixed4 _FogColor;
		float _FogStart;
		float _FogEnd;
		sampler2D _NoiseTex;
		half _FogXSpeed;
		half _FogYSpeed;
		half _NoiseAmount;
		
		struct v2f {
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
			float2 uv_depth : TEXCOORD1;
			float4 interpolatedRay : TEXCOORD2;
		};
		
		v2f vert(appdata_img v) {
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			
			o.uv = v.texcoord;
			o.uv_depth = v.texcoord;//深度图UV
			
			#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0)//平台差异性，起点在左上角
				o.uv_depth.y = 1 - o.uv_depth.y;
			#endif
			
			//判断当定点在那个位置，该使用那个方向向量
			int index = 0;
			if (v.texcoord.x < 0.5 && v.texcoord.y < 0.5) {
				index = 0;
			} else if (v.texcoord.x > 0.5 && v.texcoord.y < 0.5) {
				index = 1;
			} else if (v.texcoord.x > 0.5 && v.texcoord.y > 0.5) {
				index = 2;
			} else {
				index = 3;
			}
			#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0)//平台差异性，起点在左上角
				index = 3 - index;
			#endif
			
			o.interpolatedRay = _FrustumCornersRay[index];//选择方向向量
				 	 
			return o;
		}
		
		fixed4 frag(v2f i) : SV_Target {
			float linearDepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv_depth));//获取深度
			float3 worldPos = _WorldSpaceCameraPos + linearDepth * i.interpolatedRay.xyz;
			
			float2 speed = _Time.y * float2(_FogXSpeed, _FogYSpeed);
			float noise = (tex2D(_NoiseTex, i.uv + speed).r - 0.5) * _NoiseAmount;//计算当前像素的噪声值，取r来表示。
					
			float fogDensity = (_FogEnd - worldPos.y) / (_FogEnd - _FogStart); //计算当前高度的雾效浓度
			fogDensity = saturate(fogDensity * _FogDensity * (1 +noise));//混合噪声值
			
			fixed4 finalColor = tex2D(_MainTex, i.uv);
			finalColor.rgb = lerp(finalColor.rgb, _FogColor.rgb, fogDensity);
			
			return finalColor;
		}
		
		ENDCG
		
		Pass {          	
			CGPROGRAM  
			
			#pragma vertex vert  
			#pragma fragment frag  
			  
			ENDCG
		}
	} 
	FallBack Off
}
