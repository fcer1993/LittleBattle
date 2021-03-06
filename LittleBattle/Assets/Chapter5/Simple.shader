﻿Shader "Custom/Simple" {
	Properties{
		_Color("color tint",Color)=(1.0,1.0,1.0,1.0)
	}
	SubShader{
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			fixed4 _Color;
			struct a2v{
				float4 vert:POSITION;
				float3 normal:NORMAL;
				float4 texcoord :TEXCOORD0;
			};
			struct v2f{
				float4 pos:SV_POSITION;
				float3 col:COLOR0;
			};
			v2f vert(a2v v):POSITION{
				v2f o;
				o.pos=mul(UNITY_MATRIX_MVP,v.vert);
				o.col=v.normal*0.5+fixed3(0.5,0.5,0.5);
				return o;
			}
			fixed4 frag(v2f i):SV_TARGET0{
				fixed3 c=i.col;
				c*=_Color.rgb;
				return fixed4(c,1.0);
			}
		ENDCG
		}
	}
	FallBack "Diffuse"
}
