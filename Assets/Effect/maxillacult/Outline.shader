// https://github.com/maxillacult/ofxPostGlitch/blob/master/Shaders/outline.frag
Shader "Custom/Outline" {
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
				half2 resolution = _ScreenParams.xy;
				
//				int pixstep = 5;
//				float4 cols[25];
				int pixstep = 2;
				float4 cols[4];
			    //float2 texCoord = float2(pos.x,pos.y);//vec2(min(max(0.0,pos.x),1.0),min(max(0.0,pos.y),1.0));

				for (int i = 0; i < pixstep; i++){
					for (int j = 0;j < pixstep; j++){
						cols[i*pixstep+j] = tex2D(_MainTex, float2((pos.x+float(j)/resolution.x), (pos.y+float(i)/resolution.y)) );
						cols[i*pixstep+j].r = (cols[i*pixstep+j].r + cols[i*pixstep+j].g + cols[i*pixstep+j].b) / 3.0;
					}
				}
				float mn = 1.0, mx = 0.0;
				for (int i = 0;i < pixstep*pixstep;i++){
					mn = min(cols[i].r, mn);
					mx = max(cols[i].r, mx);
				}
				float dst = abs(1.0 - (mx-mn));
				float4 fragColor = float4(1.0, 1.0, 1.0, 1.0);
				fragColor.a = 1.0;
			    //fragColor.rgb = float3(dst,dst,dst)+cols[12].rgb;
			    if(dst < 0.9){
			    	dst *= 0.01;
			    }
			    fragColor.rgb = float3(dst,dst,dst);
				
				return fragColor;
			}
			
			ENDCG
		}
	}
	
}
