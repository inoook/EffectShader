// http://www.airtightinteractive.com/demos/js/shaders/js/shaders/KaleidoShader.js
Shader "Custom/KaleidoscopeImageEffect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_sides ("Sides", Float) = 6.0 // sides: number of reflections
		_angle ("angle", Float) = 0.0 //  angle: initial angle in radians
	}
	SubShader {

		Pass
		{            
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			float _sides;
			float _angle;

			float4 frag(v2f_img i) : COLOR {
				half2 p = i.uv - 0.5;
				float r = length(p);
				//float a = atan(p.y, p.x) + _angle;
				float atn = abs(atan2(p.y, -p.x)) + _angle;

				float tau = 2.0 * 3.1416 ;
				float sides = _sides; 
				atn = fmod(atn, tau/sides);
				atn = abs(atn - tau/sides/2.0) ;
				p = r * float2(cos(atn), sin(atn));

				float4 col = tex2D(_MainTex, p+0.5);
				return col;
			}
			ENDCG
		}

	} 
}
