// Made with Amplify Shader Editor v1.9.1.8
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE_Deformation"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_BumpSize("Bump Size", Range( 0 , 5)) = 1
		_BumpHeight("Bump Height", Range( 0 , 10)) = 0.5
		_TextureScale("Texture Scale", Range( 0 , 1)) = 0.1
		_BumpShiftTexture("Bump Shift Texture", 2D) = "white" {}
		_MainTexture("MainTexture", 2D) = "white" {}
		_NormalTexture("NormalTexture", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float3 _ObjWorldPos;
		uniform float _BumpSize;
		uniform sampler2D _BumpShiftTexture;
		uniform float _TextureScale;
		uniform float _BumpHeight;
		uniform sampler2D _NormalTexture;
		uniform float4 _NormalTexture_ST;
		uniform sampler2D _MainTexture;
		uniform float4 _MainTexture_ST;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 ase_vertex4Pos = v.vertex;
			float4 transform56 = mul(unity_ObjectToWorld,ase_vertex4Pos);
			float3 temp_output_57_0 = (transform56).xyz;
			float4 appendResult41 = (float4(0.0 , 0.0 , ( tex2Dlod( _BumpShiftTexture, float4( ( frac( ( (( temp_output_57_0 - _ObjWorldPos )).xz * _TextureScale ) ) + 0.5 ), 0, 0.0) ).r * ( _BumpHeight * 0.1 ) ) , 0.0));
			v.vertex.xyz += (( length( abs( ( temp_output_57_0 - _ObjWorldPos ) ) ) >= 0.0 && length( abs( ( temp_output_57_0 - _ObjWorldPos ) ) ) <= _BumpSize ) ? appendResult41 :  float4( float3(0,0,0) , 0.0 ) ).xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalTexture = i.uv_texcoord * _NormalTexture_ST.xy + _NormalTexture_ST.zw;
			o.Normal = tex2D( _NormalTexture, uv_NormalTexture ).rgb;
			float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			float4 tex2DNode46 = tex2D( _MainTexture, uv_MainTexture );
			o.Albedo = tex2DNode46.rgb;
			o.Alpha = 1;
			clip( tex2DNode46.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19108
Node;AmplifyShaderEditor.CommentaryNode;29;-1662.718,42.50067;Inherit;False;1237.483;374.4062;Adjusted UVs;8;30;23;21;22;8;20;19;18;Sample the Bump Texture;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;15;-836.0551,-832.3757;Inherit;False;1097.973;717.8781;If vertex and obj are close, enable vertex offset;9;49;12;13;2;6;5;45;25;14;Vertex Offset Or Not;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;17;-1096.168,-775.8109;Inherit;False;592.3069;234.2831;;3;57;56;9;World Space Vertex Pos;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;25;-612.5035,-291.18;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;-1612.718,99.83884;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;30;-726.152,158.8042;Inherit;True;Property;_BumpShiftTexture;Bump Shift Texture;4;0;Create;True;0;0;0;False;0;False;-1;fde8365c95bd2ad418f39a024537d4a1;fde8365c95bd2ad418f39a024537d4a1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;26;-1189.878,-269.5385;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;43;-1819.812,35.52924;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;41;-164.4481,215.9556;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;45;-382.7751,-194.7468;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;42;-79.15858,80.15432;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;46;390.7329,-1080.416;Inherit;True;Property;_MainTexture;MainTexture;5;0;Create;True;0;0;0;False;0;False;-1;None;11dec8b8fdb688d4f819239e2998c3f8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;47;400.3907,-890.858;Inherit;True;Property;_NormalTexture;NormalTexture;6;0;Create;True;0;0;0;False;0;False;-1;None;4e0daffb01b1ecb46a614fcc1d143f8c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;924.8653,-678.5403;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ASE_Deformation;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;False;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-455.4701,-555.1378;Inherit;False;Property;_BumpSize;Bump Size;1;0;Create;True;0;0;0;False;0;False;1;3.51;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;2;-817.8912,-530.731;Inherit;False;Global;_ObjWorldPos;_ObjWorldPos;0;0;Create;True;0;0;0;False;0;False;0,0,0;-9.18,-0.53,12.01;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;5;-182.5941,-421.2502;Inherit;False;Constant;_ZeroOffset;Zero Offset;1;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.AbsOpNode;49;-292.4415,-652.6871;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LengthOpNode;13;-156.2178,-647.1886;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareWithRange;14;-11.98188,-645.1534;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-894.0368,436.7872;Inherit;False;Property;_BumpHeight;Bump Height;2;0;Create;True;0;0;0;False;0;False;0.5;2.49;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-790.4092,514.1147;Inherit;False;Constant;_Float1;Float 1;6;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-606.4092,465.1147;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-329.6289,260.5394;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;19;-1429.611,92.50095;Inherit;True;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1457.301,277.4583;Inherit;False;Property;_TextureScale;Texture Scale;3;0;Create;True;0;0;0;False;0;False;0.1;0.114;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;21;-1030.827,165.2456;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1162.238,150.1108;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-896.6703,210.8799;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1095.533,266.7283;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;53;-1113.063,628.9148;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;12;-432.5178,-655.8886;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;56;-894.9399,-726.1979;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;57;-705.5533,-704.9231;Inherit;False;True;True;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;9;-1085.485,-717.6141;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;58;-529.6342,-475.3864;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;59;-610.0287,-243.1296;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;60;-1183.523,-221.6906;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;61;-1751.664,32.00386;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
WireConnection;25;0;2;0
WireConnection;18;0;61;0
WireConnection;18;1;43;0
WireConnection;30;1;23;0
WireConnection;26;0;25;0
WireConnection;43;0;26;0
WireConnection;41;2;39;0
WireConnection;45;0;42;0
WireConnection;42;0;41;0
WireConnection;0;0;46;0
WireConnection;0;1;47;0
WireConnection;0;10;46;4
WireConnection;0;11;14;0
WireConnection;49;0;12;0
WireConnection;13;0;49;0
WireConnection;14;0;13;0
WireConnection;14;2;6;0
WireConnection;14;3;45;0
WireConnection;14;4;5;0
WireConnection;50;0;7;0
WireConnection;50;1;51;0
WireConnection;39;0;30;1
WireConnection;39;1;50;0
WireConnection;19;0;18;0
WireConnection;21;0;20;0
WireConnection;20;0;19;0
WireConnection;20;1;8;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;12;0;57;0
WireConnection;12;1;2;0
WireConnection;56;0;9;0
WireConnection;57;0;56;0
WireConnection;58;0;57;0
WireConnection;59;0;58;0
WireConnection;60;0;59;0
WireConnection;61;0;60;0
ASEEND*/
//CHKSM=A903EDF8431D178BE04D4BEC50F34104C1FAEE3C