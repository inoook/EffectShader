Shader "Custom/RGBShift" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		amount ("Sides", Float) = 0.005
        angle ("angle", Float) = 0.0
	}
	
	SubShader {
		
		Pass
		{            
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			float amount;
			float angle;

			float4 frag(v2f_img i) : COLOR {
				half2 vUv = i.uv;
				
				half2 offset = amount * half2( cos(angle), sin(angle));
				half4 cr = tex2D(_MainTex, vUv + offset);
				half4 cga = tex2D(_MainTex, vUv);
				half4 cb = tex2D(_MainTex, vUv - offset);
				return float4(cr.r, cga.g, cb.b, cga.a);
			}                         
			ENDCG        
		}
	}
}
