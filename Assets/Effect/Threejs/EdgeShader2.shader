// https://github.com/mrdoob/three.js/blob/master/examples/js/shaders/EdgeShader2.js
Shader "Custom/EdgeShader2" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Pass
	    {            
	        CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            
			sampler2D _MainTex;
			
			float3x3 G[2];

			
			float4 frag(v2f_img i) : COLOR {
				half2 vUv = i.uv;
				half2 resolution = _ScreenParams.xy;
				
				float3x3 g0 = float3x3( 1.0, 2.0, 1.0, 0.0, 0.0, 0.0, -1.0, -2.0, -1.0 );
				float3x3 g1 = float3x3( 1.0, 0.0, -1.0, 2.0, 0.0, -2.0, 1.0, 0.0, -1.0 );
				
				float3x3 I;
				float cnv[2];
				float3 sample;

				G[0] = g0;
				G[1] = g1;

				// /* fetch the 3x3 neighbourhood and use the RGB vector's length as intensity value */
				for (float i = 0.0; i < 3.0; i++){
					for (float j = 0.0; j < 3.0; j++) {
						sample = tex2D( _MainTex, vUv + float2(i, j)/resolution ).rgb;
						I[int(i)][int(j)] = length(sample);
					}
				}

				// /* calculate the convolution values for all the masks */
				for (int i=0; i<2; i++) {
					float dp3 = dot(G[i][0], I[0]) + dot(G[i][1], I[1]) + dot(G[i][2], I[2]);
					cnv[i] = dp3 * dp3; 
				}
				
				float v = 0.5 * sqrt(cnv[0]*cnv[0]+cnv[1]*cnv[1]);
				float4 fragColor = float4(v, v, v, v);
				return fragColor;
			}
			
			ENDCG
		}
	}
	
}
