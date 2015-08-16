Shader "Custom/DrawByNoise" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		rand ("Rand", Float) = 1.0
		_Step ("step", Float) = 3
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
			float _Step;
			
			sampler2D _CameraDepthNormalsTexture;
			
			uniform half2 center;
			uniform float angle;
			uniform float scale;
			uniform half2 tSize;
			
			float stepColor(float c) {
				return floor(saturate(c)*(_Step*2)/2)/(_Step*2)*2;
			}
			
			float4 frag(v2f_img i) : COLOR {
				half2 vUv = i.uv;
				half2 pos = vUv * _ScreenParams;
				
				float4 col = tex2D( _MainTex, vUv );
				float average = ( col.r + col.g + col.b ) / 3.0;
				float nz = snoise(half2(pos.x*pos.y+rand , pos.x+pos.y-rand));
				//
				half4 dnPix = tex2D (_CameraDepthNormalsTexture, i.uv);
				float depth = DecodeFloatRG (dnPix.zw);
				if(depth < 0.99){
				average *= depth*4.0 + 0.5;
				}
				
				float newColor = stepColor( average + (nz*0.15) )+0.2;
				//float newColor = ( stepColor(average) + (nz*0.15) ) * 1.5;
				//float newColor = ( (average) + stepColor(abs(nz*2)) );
				float4 fragColor = float4( newColor, newColor, newColor, col.a );
				
				return fragColor;
			}
			
			
			ENDCG
		}
	}
	
}
