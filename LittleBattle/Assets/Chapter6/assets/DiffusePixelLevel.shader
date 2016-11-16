// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/DiffusePixelLevel" {
	Properties{
		_Diffuse("Diffuse",Color)=(1,1,1,1)
	}

	SubShader{
		Pass{
			Tags{"LightMode"="ForwardBase"}

			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _Diffuse;
			struct a2v{
				float4 vertex :POSITION;
				float3 normal:NORMAL;
			};
			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldnormal:TEXCOORD0;
			};
			v2f vert(a2v v){
				v2f o;
				o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
				o.worldnormal=mul(v.normal,(float3x3)unity_WorldToObject);
				return o;
			}
			fixed4 frag(v2f f):SV_TARGET0{
				fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.rgb;
				fixed3 worldnormal=normalize( f.worldnormal);
				fixed3 worldlight=normalize(_WorldSpaceLightPos0.xyz);

				fixed3 diffuse=_LightColor0.rgb*_Diffuse.rgb*(saturate(dot(worldnormal,worldlight)));//_LightColor0.rgb*

				fixed3 color=ambient+diffuse;
				return(fixed4(color,1.0));

			}

			ENDCG
		}


	}
}
