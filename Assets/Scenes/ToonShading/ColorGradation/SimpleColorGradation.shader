﻿//--------------------------- 色阶分层 ---------------------
Shader "lcl/ToonShading/SimpleColorGradation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        
        _DiffuseColorHigh ("DiffuseColorHigh", Color) = (1, 1, 1, 1)
        _DiffuseColorMid ("DiffuseColorMid", Color) = (1, 1, 1, 1)
        _DiffuseColorLow ("DiffuseColorLow", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _DiffuseColorHigh;
            float4 _DiffuseColorMid;
            float4 _DiffuseColorLow;


            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normal = mul(v.normal,(float3x3) unity_WorldToObject);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 normal = normalize(i.normal);

                float NdotL = dot(normal, lightDir);

                float v1 = NdotL + 1;
                float v2 = NdotL;
                float3 D1 = lerp(_DiffuseColorLow, _DiffuseColorMid, v1);
                float3 D2 = lerp(_DiffuseColorMid, _DiffuseColorHigh, v2);
                float3 diffuseColor = lerp(D1, D2, NdotL > 0);

                return float4(diffuseColor,1);
            }
            ENDCG

        }
    }
}
