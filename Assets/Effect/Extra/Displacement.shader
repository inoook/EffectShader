Shader "Custom/Displacement" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_DispTex ("DisplacementMat (RG)", 2D) = "white" {}
		vx ("valueX (R)", Float) = 0.1
		vy ("valueY (G)", Float) = 0.1
		scale ("scale", Float) = 0.1
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
			sampler2D _DispTex;
			float vx;
			float vy;
			float scale;
			
			float4 frag(v2f_img i) : COLOR {
				half2 p = i.uv;
				
				float4 norm = tex2D(_DispTex, p * scale);
				p.x = p.x + norm.r * vx;
				p.y = p.y + norm.g * vy;
				
				float4 fragColor = tex2D(_MainTex, p);
				
				return fragColor;
			}
			
			ENDCG
		}
	} 
}
