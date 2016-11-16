// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Culloff" {
		Properties{
		_Color("MainTint",Color)=(1,1,1,1)
		_MainTex("MainTex",2D)="white"{}
		_AlphaScale("Alpha Scale",Range(0,1))=1
	}

	SubShader{
		Pass{
			Tags{"Queue"="Transparent" "IgnoreProjector"="true" "RenderType"="Transparent"}
			Cull front
			//ZWrite Off
			Blend SrcALpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _AlphaScale;

			struct a2v{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
				float2 texcoord:TEXCOORD0;
			};
			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldpos:TEXCOORD0;
				float2 uv:TEXCOORD1;
				float3 worldnormal:TEXCOORD2;

			};
			v2f vert(a2v v){
				v2f o;
				o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
				o.worldpos=mul(unity_ObjectToWorld,v.vertex);
				o.worldnormal=UnityObjectToWorldNormal(v.normal);
				o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);//v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw
				return o;
			}
			fixed4 frag(v2f i):SV_TARGET0{
				fixed3 worldnormal=normalize(i.worldnormal);
				fixed3 worldlight=normalize(UnityWorldSpaceLightDir(i.worldpos));

				fixed4 texColor=tex2D(_MainTex,i.uv);

				fixed3 Albedo=texColor.rbg*_Color.rgb;
				fixed3 Ambient=UNITY_LIGHTMODEL_AMBIENT.rbg*Albedo;

				fixed3 DIFFUSE=_LightColor0.rgb*Albedo*max(0,dot(worldnormal,worldlight));
				return fixed4(Ambient+DIFFUSE,texColor.a*_AlphaScale);

			}

			ENDCG
		}

		Pass{
			Tags{"Queue"="Transparent" "IgnoreProjector"="true" "RenderType"="Transparent"}
			Cull back
			//ZWrite Off
			Blend SrcALpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _AlphaScale;

			struct a2v{
				float4 vertex:POSITION;
				float2 texcoord:TEXCOORD0;
				float3 normal:NORMAL;
			};
			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldpos:TEXCOORD0;
				float2 uv:TEXCOORD1;
				float3 worldnormal:TEXCOORD2;

			};
			v2f vert(a2v v){
				v2f o;
				o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
				o.worldpos=mul(unity_ObjectToWorld,v.vertex);
				o.worldnormal=UnityObjectToWorldNormal(v.normal);
				o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);//v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw
				return o;
			}
			fixed4 frag(v2f i):SV_TARGET0{
				fixed3 worldnormal=normalize(i.worldnormal);
				fixed3 worldlight=normalize(UnityWorldSpaceLightDir(i.worldpos));

				fixed4 texColor=tex2D(_MainTex,i.uv);

				fixed3 Albedo=texColor.rbg*_Color.rgb;
				fixed3 Ambient=UNITY_LIGHTMODEL_AMBIENT.rbg*Albedo;
				fixed3 DIFFUSE=_LightColor0.rgb*Albedo*max(0,dot(worldnormal,worldlight));
				return fixed4(Ambient+DIFFUSE,texColor.a*_AlphaScale);

			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
