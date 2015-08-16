Shader "Custom/Poster" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Step ("step", Float) = 5
	}
	SubShader {
		Pass
	    {            
	        CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag_gray
            #pragma target 3.0

            #include "UnityCG.cginc"
            
			sampler2D _MainTex;
			int _Step;
			
			float stepColor(float c) {
				return floor(saturate(c)*(_Step*2)/2)/(_Step*2)*2;
			}
			
			float4 frag_gray(v2f_img i) : COLOR {
				half2 p = i.uv;

				float4 col = tex2D( _MainTex, p );
				float average = ( col.r + col.g + col.b ) / 3.0;
				float newColor = stepColor(average);
				
				float4 fragColor = float4( newColor, newColor, newColor, col.a );
				return fragColor;
			}
			
			float4 frag_rgb(v2f_img i) : COLOR {
				half2 p = i.uv;

				float4 col = tex2D( _MainTex, p );
				float average = ( col.r + col.g + col.b ) / 3.0;
				float nR = stepColor(col.r);
				float nG = stepColor(col.g);
				float nB = stepColor(col.b);
				
				float4 fragColor = float4( nR, nG, nB, col.a );
				return fragColor;
			}
			
			ENDCG
		}
	}
	
}
