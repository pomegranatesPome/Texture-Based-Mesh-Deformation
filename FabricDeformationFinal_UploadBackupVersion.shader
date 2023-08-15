Shader "Custom/FabricDeformation"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _NormalMap ("Normal", 2D) = "bump" {}

        _BumpShiftTexture("Bump/Shift Texture", 2D) = "white" {} 
        _ObjWorldPos ("Target Object World Position", Vector) = (0,0,0) 
        _BumpSize("Object Bump Size", Range(1, 3)) = 1
        _BumpHeight("Object Bump Height", Range(0, 1)) = 0.5
        _TextureScale("Texture Scale", Range(0, 1)) = 0.1 
    
    }

    SubShader
    {
        Tags { "RenderType"="Opaque"}
        LOD 100
        
    
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #pragma target 5.0 // NEW
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            
            sampler2D _MainTex;
            sampler2D _NormalMap;
            sampler2D _BumpShiftTexture; 
            half _TextureScale;
            float3 _ObjWorldPos; //set by script
            half _BumpSize;
            half _BumpHeight;

            sampler2D _ShadowMap; 
            float4x4 unity_WorldToLight;


            struct appdata
            {
                float2 uv1 : TEXCOORD0;
                float3 normal : NORMAL;
                float4 vertex : POSITION; // this is in OBJECT SPACE
            };

            struct v2f
            {
                float2 uv1 : TEXCOORD0;
                float3 normal : NORMAL;
                UNITY_FOG_COORDS(1)
                float4 vertex : POSITION;


            };

            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.uv1 = v.uv1;

                float4 vertex_world = mul(unity_ObjectToWorld, v.vertex);
                o.worldPos = vertex_world.xyz;

                float3 diff = vertex_world - _ObjWorldPos;

                float shiftAmount = 0.0;

                if (length(diff) <= _BumpSize)
                {
                    // Calculate the offset from the center
                    float2 offsetFromCenter = (vertex_world.xz - _ObjWorldPos.xz) * _TextureScale;
                    // Ensure the UVs are wrapped between 0 and 1, especially if _ObjWorldPos 
                    // is significantly changing.
                    offsetFromCenter = frac(offsetFromCenter);
                    // Adjust the UVs to center around the object's position
                    float2 adjustedUVs = 0.5 + offsetFromCenter;

                    float4 uv_mip = float4(adjustedUVs, 0, 0);
                    fixed4 sampled = tex2Dlod(_BumpShiftTexture, uv_mip);

                    float shiftingIntensity = sampled.r;
                    shiftAmount = _BumpHeight * shiftingIntensity;
                    v.vertex.z += (shiftAmount *= 0.01);
                }

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);

                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }


            fixed4 frag (v2f i) : SV_Target
            {
                half3 normalizedNormal = normalize(i.normal);
                half3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
        
                fixed4 col = fixed4(0, 0, 0, 1);
               
                
                // Main directional light
                half3 mainLightDir = normalize(_WorldSpaceLightPos0.xyz);
                half3 mainLightIntensity = _LightColor0.rgb;
                col.rgb += mainLightIntensity * max(0, dot(i.normal, mainLightDir));

                half4 maintex = tex2D(_MainTex, i.uv1);
                col.rgb = maintex.rgb * col.rgb;

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                
                return col;
            }
            ENDCG
        } // end pass       
    }
}
