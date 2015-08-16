Shader "Custom/LineScreen" {
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
				//half lineScale = 1;
				
				float f = sin( (vUv.x*resolution.x + vUv.y*resolution.y+avg*20)*1.25);
				float s = avg*2;
				
				return f + s;
			}

			float4 frag(v2f_img i) : COLOR {
				half2 vUv = i.uv;
				
				float4 col = tex2D( _MainTex, vUv );
				float average = ( col.r + col.g + col.b ) / 3.0;
				//float newColor = saturate( pattern(i, average) );
				float newColor = abs( pattern(i, average) );
				float4 fragColor = float4( newColor, newColor, newColor, col.a );
				return fragColor;
			}
			ENDCG
		}
	}
	
}
