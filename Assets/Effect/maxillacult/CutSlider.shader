Shader "Custom/CutSlider" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		rand ("rand", Float) = 1
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
			uniform float rand;
			
			float4 frag(v2f_img i) : COLOR {
				half2 pos = i.uv;
				
				float2 txCoord = float2(pos.x, pos.y);
				float4 col = tex2D(_MainTex, txCoord);
				//vec4 col_s = tex2D(_MainTex, texCoord + vec2(floor(sin(pos.y/30.0*rand+rand*rand))*30.0*rand, 0));
				float4 col_s = tex2D(_MainTex, txCoord + float2(floor(sin(pos.y/50 *_ScreenParams.y*rand + rand * rand))*0.1*rand, 0));
				
				return col_s;
			}
			
			ENDCG
		}
	} 
	
}
