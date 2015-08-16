Shader "Custom/Template" {
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
				half2 p = i.uv;
				
				float4 fragColor = tex2D(_MainTex, p);
				return fragColor;
			}
			
			ENDCG
		}
	}
	
}
