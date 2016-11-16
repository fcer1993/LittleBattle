Shader "Custom/MaskTexture" {
	Properties{
		_Color("Color Tint",Color)=(1,1,1,1)
		_MainTex("MainTex",2D)="white"{}
		_BumpMap("NormalMap",2D)="Bump"{}
		_BumpScale("Bump Scale",Float)=1.0
		_SpecularMask("specularmask",2D)="white"{}
		_SpecularScale("Specularscale",Float)=1.0
		_Specular("Specular",Color)=(1,1,1,1)
		_Glossiness("Gloss",Range(8.0,256))=20
	}

	SubShader{
		Pass{
			Tags{"LightMode"="ForwardBase"}

			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag 
			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float _BumpScale;
			sampler2D _SpecularMask;
			float _SpecularScale;
			fixed4 _Specular;
			float _Glossiness;

			struct a2v{

				float4 vertex:POSITION;
				float3 normal:NORMAL;
				float4 tangent:TANGENT;
				float4 texcoord:TEXCOORD0;
			};
			struct v2f{
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
				float3 lightdir:TEXCOORD1;
				float3 viewdir:TEXCOORD2;

			};

			v2f vert (a2v v){
				v2f o;
				o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
				o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
				TANGENT_SPACE_ROTATION;
				o.lightdir=mul(rotation,ObjSpaceLightDir(v.vertex)).xyz;
				o.viewdir=mul(rotation,ObjSpaceViewDir(v.vertex)).xyz;
				return o;

			}
			fixed4 frag(v2f i):SV_TARGET0{
				fixed3 tangentLightDir=normalize(i.lightdir);
				fixed3 tangentViewDir=normalize(i.viewdir);
				fixed4 temp=tex2D(_BumpMap,i.uv);
				fixed3 tangentNormal=UnpackNormal(temp);
				tangentNormal.xy*=_BumpScale;
				tangentNormal.z=sqrt(1.0-saturate(dot(tangentNormal.xy,tangentNormal.xy)));

				fixed3 Albedo =tex2D(_MainTex,i.uv).rgb*_Color.rgb;
				fixed3 Ambient=UNITY_LIGHTMODEL_AMBIENT.xyz*Albedo;
				fixed3 DIFFUSE=_LightColor0.rgb*Albedo*max(0,dot(tangentNormal,tangentLightDir));
				fixed3 halfdir=normalize(tangentLightDir+tangentViewDir);
				fixed3 specularmask=tex2D(_SpecularMask,i.uv).r*_SpecularScale;
				fixed3 SPECULAR=_LightColor0.rgb*_Specular*pow(max(0,dot(halfdir,tangentNormal)),_Glossiness)*specularmask;
				
				return fixed4(DIFFUSE+DIFFUSE+SPECULAR,1);//

			}
			ENDCG
		}
	}
	FallBack "SPECULAR"
}
