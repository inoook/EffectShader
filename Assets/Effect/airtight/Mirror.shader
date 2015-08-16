Shader "Custom/Mirror" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_side ("side", Int) = 1 // 0 - 3
	}
	
	SubShader {

		Pass
	    {            
	        CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"
	
			uniform sampler2D _MainTex;
			uniform float _side;
			
			float4 frag(v2f_img i) : COLOR {
				half2 p = i.uv;
				
				int side = (int(_side));
				if (side == 0){
					if (p.x > 0.5) p.x = 1.0 - p.x;
				}else if (side == 1){
					if (p.x < 0.5) p.x = 1.0 - p.x;
				}else if (side == 2){
					if (p.y < 0.5) p.y = 1.0 - p.y;
				}else if (side == 3){
					if (p.y > 0.5) p.y = 1.0 - p.y;
				}
				float4 fragColor = tex2D(_MainTex, p);
				return fragColor;
			}
	        ENDCG        
	    }
	}
}
