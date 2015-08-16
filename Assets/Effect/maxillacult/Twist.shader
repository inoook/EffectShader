Shader "Custom/Twist" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
		//trueWidth ("trueWidth (Int)", Int) = 0
		//trueHeight ("trueHeight (Int)", Int) = 0
		rand ("rand", Float) = 0
		timer ("timer", Float) = 0
		val2 ("val2", Float) = 1
		val3 ("val3", Float) = 1
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
			
			//int trueWidth;
			//int trueHeight;
			float rand;
			float timer;
			float val2;
			float val3;
			
			float4 frag(v2f_img i) : COLOR {
				half2 pos = i.uv;
				
				//float pix_w = 1.0 / float(imgWidth);
				//float pix_h = 1.0 / float(imgHeight);

//				vec2 texCoord = vec2(max(3.0, min(float(trueWidth)  , pos.x+sin(pos.y/(153.25*rand*rand)*rand+rand*val2+timer*3.0)*val3)),
//									  max(3.0, min(float(trueHeight), pos.y+cos(pos.x/(251.57*rand*rand)*rand+rand*val2+timer*2.4)*val3)-3.));
									  
				half2 txCoord = half2(pos.x+sin(pos.y/(0.15325*rand*rand)*rand+rand*val2+timer*3.0)*val3,
									 pos.y+cos(pos.x/(0.25157*rand*rand)*rand+rand*val2+timer*2.4)*val3);

				half4 col = tex2D(_MainTex, txCoord);
				
				half4 fragColor = col.rgba;
				return fragColor;
			}
			
			ENDCG
		}
	}
}
