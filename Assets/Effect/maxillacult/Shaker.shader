Shader "Custom/Shaker" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		blur_vec_x ("blur_vec_x", Float) = 1
		blur_vec_y ("blur_vec_y", Float) = 1
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
			float blur_vec_x;
			float blur_vec_y;
			//float pix_w, pix_h;
			
			float4 frag(v2f_img i) : COLOR {
				half2 pos = i.uv;
				
				float pix_w = 1.0;
			    float pix_h = 1.0;
			    
			    //vec2 texCoord = vec2(pos.x, pos.y);

			    half4 col = tex2D(_MainTex,pos);
				
			    half4 col_s[5], col_s2[5];
			    for (int i = 0;i < 5; i++){
			        col_s[i] = tex2D(_MainTex, pos +  float2(-pix_w*float(i)*blur_vec_x ,-pix_h*float(i)*blur_vec_y)* 0.01);
			        col_s2[i] = tex2D(_MainTex, pos + float2( pix_w*float(i)*blur_vec_x , pix_h*float(i)*blur_vec_y)* 0.01);
			    }
			    col_s[0] = (col_s[0] + col_s[1] + col_s[2] + col_s[3] + col_s[4])/5.0;
			    col_s2[0]= (col_s2[0]+ col_s2[1]+ col_s2[2]+ col_s2[3]+ col_s2[4])/5.0;
			    col = (col_s[0] + col_s2[0]) / 2.0;
			    
				float4 fragColor = col.rgba;
				return fragColor;
			}
			
			ENDCG
		}
	}
	
}