// http://armedunity.com/topic/4950-brightnesscontrastsaturation-shader/
Shader "Custom/BrightnessContrastSaturation" {
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
		_SaturationAmount ("Saturation Amount", Range(0.0, 1.0)) = 1.0
		_BrightnessAmount ("Brightness Amount", Range(0.0, 1.0)) = 1.0
		_ContrastAmount ("Contrast Amount", Range(0.0,2.0)) = 1.0
	}
	SubShader 
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			
			uniform sampler2D _MainTex;
			uniform float _SaturationAmount;
			uniform float _BrightnessAmount;
			uniform float _ContrastAmount;
			
			float3 ContrastSaturationBrightness( float3 color, float brt, float sat, float con)
			{
				//RGB Color Channels
				float AvgLumR = 0.5;
				float AvgLumG = 0.5;
				float AvgLumB = 0.5;
				
				//Luminace Coefficients for brightness of image
				float3 LuminaceCoeff = float3(0.2125,0.7154,0.0721);
				
				//Brigntess calculations
				float3 AvgLumin = float3(AvgLumR,AvgLumG,AvgLumB);
				float3 brtColor = color * brt;
				float intensityf = dot(brtColor, LuminaceCoeff);
				float3 intensity = float3(intensityf, intensityf, intensityf);
				
				//Saturation calculation
				float3 satColor = lerp(intensity, brtColor, sat);
				
				//Contrast calculations
				float3 conColor = lerp(AvgLumin, satColor, con);
				
				return conColor;
				
			}
			
			
			float4 frag (v2f_img i) : COLOR
			{
				float4 renderTex = tex2D(_MainTex, i.uv);
				
				
				renderTex.rgb = ContrastSaturationBrightness(renderTex.rgb, _BrightnessAmount, _SaturationAmount, _ContrastAmount); 
				
				return renderTex;
			
			}
			
			ENDCG
		}
		
	}
}