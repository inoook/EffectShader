// http://docs-jp.unity3d.com/Documentation/Components/SL-VertexProgramInputs.html
Shader "Custom/Convergence" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		rand ("rand", Float) = 0.0
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
			float rand;
			
			float4 frag(v2f_img i) : COLOR {
				half2 pos = i.uv;
				
				half4 col = tex2D(_MainTex, pos);
			    half4 col_r = tex2D(_MainTex, pos + half2(-0.35*rand,0));
			    half4 col_l = tex2D(_MainTex, pos + half2( 0.35*rand,0));
			    half4 col_g = tex2D(_MainTex, pos + half2( -0.75*rand,0));
			    
			    col.b = col.b + col_r.b * max(1.0, sin(pos.y*1.2)*2.5)*rand*10;
			    col.r = col.r + col_l.r * max(1.0, sin(pos.y*1.2)*2.5)*rand*10;
			    col.g = col.g + col_g.g * max(1.0 ,sin(pos.y*1.2)*2.5)*rand*10;
				
				float4 fragColor = col.rgba;
				return fragColor;
			}
			
			ENDCG
		}
	}
}
