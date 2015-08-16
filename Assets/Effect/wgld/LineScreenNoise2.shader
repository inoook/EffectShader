Shader "Custom/LineScreenNoise2" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		rand ("Rand", Float) = 1.0
	}
	SubShader {
		Pass
	    {            
	        CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            #include "../Libs/Noise.cginc"
            
			uniform sampler2D _MainTex;
			float rand;
			
			uniform half2 center;
			uniform float angle;
			uniform float scale;
			uniform half2 tSize;
			
			float pattern(v2f_img i, half avg) {
				half2 vUv = i.uv;
				half2 resolution = _ScreenParams.xy;
				
				float f = sin( (vUv.x*resolution.x + vUv.y*resolution.y) * (1-saturate(avg) + 0.75) );
				//float f = sin( (vUv.x*resolution.x + vUv.y*resolution.y * avg));
				
				return f;
			}

			float4 frag(v2f_img i) : COLOR {
				half2 vUv = i.uv;
				half2 pos = vUv * _ScreenParams;
				
				float4 col = tex2D( _MainTex, vUv );
				float average = ( col.r + col.g + col.b ) / 3.0;
				float nz = snoise(half2(pos.x*pos.y+rand , pos.x+pos.y-rand))*0.75;
				
				int sp = 8;
				float newColor = floor(saturate(average)*(sp*2)/2)/(sp*2)*2;
				//newColor *= abs( pattern(i, newColor) );
				newColor = average * abs( pattern(i, newColor) ) * 1.35;
				float4 fragColor = float4( newColor, newColor, newColor, col.a ) - abs(nz)*0.75;
				return fragColor;
			}
			
			
			ENDCG
		}
	}
	
}
