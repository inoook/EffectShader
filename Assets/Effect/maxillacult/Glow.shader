Shader "Custom/Glow" {
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
				half2 pos = i.uv;
			
				float e = 2.718281828459045235360287471352;
				half2 txCoord = half2(pos.x , pos.y);
				float4 col = tex2D(_MainTex, txCoord);

				int blur_w = 8;
				float pi = 3.1415926535;
				half4 gws = half4(0.0, 0.0, 0.0, 1.0);
				float weight;
				float k = 1.0;

				weight = 1.0/(float(blur_w)*2.0+1.0)/(float(blur_w)*2.0+1.0);

				// This algorithm doesn't support Intel HD graphics...

//				    for (int i = -blur_w;i < blur_w;i++){
//				       for (int j = -blur_w;j < blur_w;j++){
//				            weight = pow(1.0/2.0*pi*k*k,-((float(i*i)+float(j*j))/2.0*k*k))/(float(blur_w)+1.0);//ガウシアンフィルタの重み係数を計算
//				            gws = gws + tex2D(_MainTex, vec2(pos.x+float(j), pos.y+float(i)))*weight*1.3;
//				       }
//				    }
//
				float v = 0.005;
				float weightAmp = 1.5;
				for (int i = 0;i < blur_w*blur_w;i++){
					gws = gws + tex2D(_MainTex, float2(pos.x+float(fmod(float(i), float(blur_w))*v ), pos.y+float(i/blur_w)*v )) * weight*weightAmp;
					gws = gws + tex2D(_MainTex, float2(pos.x-float(fmod(float(i), float(blur_w))*v ), pos.y+float(i/blur_w)*v )) * weight*weightAmp;
					gws = gws + tex2D(_MainTex, float2(pos.x+float(fmod(float(i), float(blur_w))*v ), pos.y-float(i/blur_w)*v )) * weight*weightAmp;
					gws = gws + tex2D(_MainTex, float2(pos.x-float(fmod(float(i), float(blur_w))*v ), pos.y-float(i/blur_w)*v )) * weight*weightAmp;
				}

				
				float4 fragColor = col + gws;
				return fragColor;
			}
			
			ENDCG
		}
	} 
	
}
