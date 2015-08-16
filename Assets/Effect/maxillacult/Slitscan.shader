Shader "Custom/Slitscan" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		//imgWidth ("imgWidth", Float) = 800
		//imgHeight ("imgHeight", Float) = 600
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
            
			uniform sampler2D _MainTex;
			
			//uniform float imgWidth,imgHeight;
			//uniform int flags;
			uniform float val3;
			
			//int flgs;
			float pix_w,pix_h;
			float3 pos;
			
			float4 frag(v2f_img i) : COLOR {
				half2 vUv = i.uv;
				
				//pix_w = 1.0 / float(imgWidth);
			    //pix_h = 1.0 / float(imgHeight);
			    //flgs = flags;
			    
				float slit_h = val3;
				
			    float2 texCoord = float2(floor(vUv.x/slit_h)*slit_h ,vUv.y);
				float4 fragColor = tex2D(_MainTex, texCoord);
				return fragColor;
			}
			
			ENDCG
		}
	} 
	
}
