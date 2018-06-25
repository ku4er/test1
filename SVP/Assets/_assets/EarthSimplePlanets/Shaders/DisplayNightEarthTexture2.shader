// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/DisplayNightEarthTexture2" {
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" { }
		_SpotAngle ("Spot Angle", Float) = 30.0
		_Range ("Range", Float) = 5.0
		_Contrast ("Contrast", Range (20.0, 150.0)) = 50.0	

		/*
		_MainColor ("MainColor", Color) = (1,1,1,1)  
		_LightColor ("LightColor", Color) = (1,1,1,1)  

		_R ("_r", Float) = 1.0
		_G ("_g", Float) = 1.0
		_B ("_b", Float) = 1.0

		_R_light ("_r_light", Float) = 1.0
		_G_light ("_g_light", Float) = 1.0
		_B_light ("_b_light", Float) = 1.0

		_Line ("_line", Range (0.0, 1.0)) = 1.0	
		*/
	}
 
	Subshader 
	{
		Tags {"RenderType"="Transparent" "Queue"="Transparent"}
		Pass 
		{
			Blend SrcAlpha OneMinusSrcAlpha
			ZTest LEqual
 
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
 
			uniform sampler2D _MainTex;
			uniform float4 _LightPos; // light world position - set via script
			uniform float4 _LightDir; // light world direction - set via script
			uniform float _SpotAngle;
			uniform float _Range;
			uniform float _Contrast;

			uniform float _R;
			uniform float _G;
			uniform float _B;

			uniform float _R_light;
			uniform float _G_light;
			uniform float _B_light;

			uniform float _Line;
			uniform half4 _MainColor;
			uniform half4 _LightColor;

			struct v2f_interpolated 
			{
				float4 pos : SV_POSITION;
				float2 texCoord : TEXCOORD0;
				float3 lightDir : TEXCOORD1;
			};
 
			v2f_interpolated vert(appdata_full v)
			{
				v2f_interpolated o;
				o.texCoord.xy = v.texcoord.xy;
				o.pos = UnityObjectToClipPos(v.vertex);
				half3 worldSpaceVertex = mul(unity_ObjectToWorld, v.vertex).xyz;
				// calculate light direction to vertex
				o.lightDir = worldSpaceVertex-_LightPos.xyz;
				return o;
			}
 
			half4 frag(v2f_interpolated i) : COLOR 
			{
				half dist = saturate(1-(length(i.lightDir)/_Range)); // get distance factor
				half cosLightDir = dot(normalize(i.lightDir), normalize(_LightDir)); // get light angle
				half ang = cosLightDir-cos(radians(_SpotAngle/2)); // calculate angle factor
				half alpha = saturate(dist * ang * _Contrast) * 0.7; // combine distance, angle and contrast
				half4 c = tex2D(_MainTex, i.texCoord); // get texel
				
				/*
				if(c.r > _Line && c.g > _Line && c.b > _Line)
				{
					c *= _LightColor * _LightColor;
					//c.r *= _R_light;
					//c.g *= _G_light;
					//c.b *= _B_light;
				}
				else
				{
					c *= _MainColor * _MainColor;
					//c.r *= _R;
					//c.g *= _G;
					//c.b *= _B;
				}
				*/

				c.a *= alpha; // combine texel and calculated alpha
				return c;
			}
			ENDCG
		}	
	}
	FallBack "Diffuse"
}