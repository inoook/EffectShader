Shader "Custom/Invert" {
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
			
			float4 frag(v2f_img i) : COLOR {
				half2 vUv = i.uv;
				
				float4 col = tex2D(_MainTex, vUv);
				col.r = 1.0 - col.r;
				col.g = 1.0 - col.g;
				col.b = 1.0 - col.b;
				
				return col;
			}
			
			ENDCG
		}
	}
}
