// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/DiffuseVertexLevel" {
	
	properties{
		_Diffuse("Diffuse",Color)=(1.0,1.0,1.0,1.0)
	}
	SubShader{
		
		Pass
		{
			Tags{"LightMode"="ForwardBase"}

			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag 
			#include "Lighting.cginc"

			fixed4 _Diffuse;

			struct a2v{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
			};
			struct v2f{
				float4 pos:SV_POSITION;
				fixed3 color:COLOR;
			};
			v2f vert(a2v v){
				v2f o;
				o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
				fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldnormal =normalize(mul(v.normal,(float3x3)unity_WorldToObject));
				fixed3 worldlight=normalize(_WorldSpaceLightPos0.xyz);
				o.color=_LightColor0.rgb*_Diffuse.rgb*saturate(dot(worldnormal,worldlight));
				o.color+=ambient;
				return o;
			}
			fixed4 frag(v2f f):Color{
				return fixed4(f.color,1.0);
			}
			ENDCG
		}

	}


	FallBack "Diffuse"
}
