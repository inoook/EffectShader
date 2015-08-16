Shader "Custom/Noise" {
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
            
			sampler2D _MainTex;
			float rand;
			
			float4 frag(v2f_img i) : COLOR {
				half2 p = i.uv;
				half2 pos = p * _ScreenParams;
				
    			float4 fragColor = tex2D(_MainTex, p);
    			//fragColor.rgb = fragColor.rgb + snoise(vec2(pos.x*pos.y+rand*231.5 , pos.x+pos.y-rand*324.1))*0.5;
    			fragColor.rgb = fragColor.rgb + snoise(vec2(pos.x*pos.y+rand , pos.x+pos.y-rand))*0.5;

				return fragColor;
			}
			
			ENDCG
		}
	}
	
}
