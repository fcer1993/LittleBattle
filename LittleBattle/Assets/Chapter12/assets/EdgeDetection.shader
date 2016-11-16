Shader "Custom/EdgeDetection" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_EdgeOnly ("Edge Only",float) = 1.0
		_EdgeColor ("Edge Color", Color) = (0, 0, 0, 1)
		_BackgroundColor ("Background Color", Color) = (1, 1, 1, 1)
	}
	SubShader {
		Pass {  
			ZTest Always Cull Off ZWrite Off
			
			CGPROGRAM
			
			#include "UnityCG.cginc"
			
			#pragma vertex vert  
			#pragma fragment fragSobel
			
			sampler2D _MainTex;  
			uniform half4 _MainTex_TexelSize;//一个像素的大小
			fixed _EdgeOnly;
			fixed4 _EdgeColor;
			fixed4 _BackgroundColor;
			
			struct v2f {
				float4 pos : SV_POSITION;
				fixed2 uv2: TEXCOORD0;
				half2 uv[9] : TEXCOORD1;
				
			};
			  
			v2f vert(appdata_img v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv2=v.texcoord;
				half2 uv = v.texcoord;
				
				o.uv[0] = uv + _MainTex_TexelSize.xy * half2(-1, -1);
				o.uv[1] = uv + _MainTex_TexelSize.xy * half2(0, -1);
				o.uv[2] = uv + _MainTex_TexelSize.xy * half2(1, -1);
				o.uv[3] = uv + _MainTex_TexelSize.xy * half2(-1, 0);
				o.uv[4] = uv + _MainTex_TexelSize.xy * half2(0, 0);
				o.uv[5] = uv + _MainTex_TexelSize.xy * half2(1, 0);
				o.uv[6] = uv + _MainTex_TexelSize.xy * half2(-1, 1);
				o.uv[7] = uv + _MainTex_TexelSize.xy * half2(0, 1);
				o.uv[8] = uv + _MainTex_TexelSize.xy * half2(1, 1);
						 
				return o;
			}
			//得到亮度图（一张黑白图）
			fixed luminance(fixed4 color) {
				return  0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b; 
			}
			
			half Sobel(v2f i) {
				//const half Gx[9] = {-1,  0,  1,
				//						-2,  0,  2,
				//						-1,  0,  1};
				//const half Gy[9] = {-1, -2, -1,
				//						0,  0,  0,
				//						1,  2,  1};		

				const half Gx[9]={1, 2, 1,
									0, 0, 0,
									-1, -2, -1};
				const half Gy[9]={-1, 0, 1,
									-2, 0, 2,
									-1, 0, 1};
				
				half texColor;
				half edgeX = 0;
				half edgeY = 0;
				for (int it = 0; it < 9; it++) {
					texColor = luminance(tex2D(_MainTex, i.uv[it]));
					edgeX += texColor * Gx[it];
					edgeY += texColor * Gy[it];
				}
				
				half edge = 1 - abs(edgeX) - abs(edgeY);
				
				return edge;
			}
			
			fixed4 fragSobel(v2f i) : SV_Target {
				half edge = Sobel(i);
				
				fixed4 withEdgeColor = lerp(_EdgeColor, tex2D(_MainTex, i.uv[4]), edge);
				fixed4 onlyEdgeColor = lerp(_EdgeColor, _BackgroundColor, edge);
				//return lerp(withEdgeColor, onlyEdgeColor, _EdgeOnly);


				//返回亮度度图/灰度图
				fixed3 rendertex=tex2D(_MainTex,i.uv2);
				fixed lum=0.2125*rendertex.r+0.7145*rendertex.g+0.0721*rendertex.b;
				//return fixed4(lum,lum,lum,1);

				//返回灰度图/亮度度图
				fixed3 rendertex1=tex2D(_MainTex,i.uv2);
				fixed lum1=0.3*rendertex1.r+0.59*rendertex1.g+0.11*rendertex1.b;
				return fixed4(lum1,lum1,lum1,1);
				
 			}
			
			ENDCG
		} 
	}
	FallBack Off
}
