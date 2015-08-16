Shader "Custom/ColorControl" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		riseR ("riseR", Float) = 0.2
		riseG ("riseG", Float) = 0.2
		riseB ("riseB", Float) = 0.2
		
		// blue invert 0.2, 0.2, -0.4
		// blue rise 0.2, 0.2, 0.075
	}
	SubShader {
		Pass
	    {            
	        CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            
			uniform sampler2D _MainTex;
			uniform float riseR;
			uniform float riseG;
			uniform float riseB;
			
			float4 frag(v2f_img i) : COLOR {
				half2 pos = i.uv;
				
				float e = 2.718281828459045235360287471352;
			    half2 txCoord = half2(pos.x , pos.y);
			    half4 col = tex2D(_MainTex, txCoord);
			    
				half3 k =   half3(riseR, riseG, riseB);
				half3 min = half3(0.0,0.0,0.0);
				half3 max = half3(1.0,1.0,1.0);

				col.r = (1.0/(1.0+pow(e,(-k.r*((col.r*2.0)-1.0)*20.0)))*(max.r-min.r)+min.r);
				col.g = (1.0/(1.0+pow(e,(-k.g*((col.g*2.0)-1.0)*20.0)))*(max.g-min.g)+min.g);
				col.b = (1.0/(1.0+pow(e,(-k.b*((col.b*2.0)-1.0)*20.0)))*(max.b-min.b)+min.b);
			    
				return col.rgba;
			}
			
			ENDCG
		}
	}
}
