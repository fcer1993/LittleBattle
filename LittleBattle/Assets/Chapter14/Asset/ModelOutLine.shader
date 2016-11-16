Shader "Custom/Chapter14/ModelOutLine" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_OutLine("Line",Range(0,1))=1
	}
	SubShader {
		Pass{
			Cull front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct a2v{
				float4 vertex:POSITION;
				float4 normal:NORMAL;
				float2 texcoord:TEXCOORD0;
			};
			struct v2f{
				float4 pos:POSITION;
				float2 uv:TEXCOORD0;
			};
			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _OutLine;
			v2f vert(a2v v){
				v2f o;
				float4 pos=mul(UNITY_MATRIX_MV,v.vertex);
				float3 normal=mul((float3x3)UNITY_MATRIX_MV,v.normal);
				normal.z=-0.5;
				pos=pos+float4(normalize(normal),0)*_OutLine;
				o.pos=mul(UNITY_MATRIX_P,pos);
				return o;

			}
			fixed4 frag(v2f i):SV_TARGET0{
				return _Color;
				//fixed3 color=tex2D(_MainTex,i.uv);
				//return fixed4(color,1);
			}
			ENDCG

		}
		Pass{
			Cull back
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct a2v{
				float4 vertex:POSITION;
				float4 normal:NORMAL;
				float2 texcoord:TEXCOORD0;
			};
			struct v2f{
				float4 pos:POSITION;
				float2 uv:TEXCOORD0;
			};
			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			v2f vert(a2v v){
				v2f o;
				float4 v1=v.vertex;
				o.pos=mul(UNITY_MATRIX_MVP,v1);
				o.uv=v.texcoord*_MainTex_ST.xy+_MainTex_ST.zw;
				//o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);
				return o;

			}
			fixed4 frag(v2f i):SV_TARGET0{
				//return fixed4(0,0,0,1);
				fixed3 color=tex2D(_MainTex,i.uv);
				return fixed4(color,1);
			}
			ENDCG
		}

	}
	FallBack "Diffuse"
}
