// https://github.com/maxillacult/ofxPostGlitch/blob/master/Shaders/outline.frag
Shader "Custom/OutlineMod" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		
		tSize ("tSize (vec2)", Vector) = ( 256, 256, 0, 0 )
		center ("center (vec2)", Vector) = ( 0.5, 0.5, 0, 0 )
		angle ("angle", Float) = 1.57
		scale ("scale", Float) = 1.0
	}
	
	CGINCLUDE

	#include "UnityCG.cginc"
	#pragma target 3.0
	
	sampler2D _MainTex;
	float4 _Color;
	
	uniform half2 center;
	uniform float angle;
	uniform float scale;
	
	float pattern(v2f_img i) {
		half2 vUv = i.uv;
		float s = sin( angle );
		float c = cos( angle );
		half2 tSize = _ScreenParams.xy;
		half2 tex = vUv * tSize - center;
		half2 pt = half2( c * tex.x - s * tex.y, s * tex.x + c * tex.y ) * scale;
		
		//return ( sin( pt.x ) * cos( pt.y ) ) * 3.0;
		return ( sin( pt.x ) * cos( pt.y ) ) * 2.0;
	}
	
	
			
	float4 frag_dot(v2f_img i) : COLOR {
		half2 pos = i.uv;
		
    	float4 col = tex2D( _MainTex, pos );
    	float average = ( col.r + col.g + col.b ) / 3.0;
		//float average = dst;
		float dst;
		if(average < 0.001){
			dst = 0.0;
		}else if(average > 0.45){
			dst = 1.0;
		}else{
			dst = average * 10.0 - 2.0 + pattern(i);
		}
	    float4 fragColor = _Color;
		
	    if(dst < 1.0){
	    	// 0 or 1
	    	dst = 0.2;
	    }
	    dst = clamp(dst, 0.2, 1.0);
		
	    fragColor.rgb = _Color * dst;
		fragColor.a = dst;
		return fragColor;
	}
	

	float4 frag_outline(v2f_img i) : COLOR {
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
		float avg = 0.0;
		for (int i = 0;i < pixstep*pixstep;i++){
			mn = min(cols[i].r, mn);
			mx = max(cols[i].r, mx);
			avg += cols[i].r;
		}
		avg = avg / pixstep*pixstep;
		
		float dst = abs(1.0 - (mx-mn));
		
		float4 fragColor = float4(0, 0, 0, 0);
		
	    if(dst < 0.9){
	    	dst *= 0.01;
	    }
		
		dst = 1.0 - dst;// invert
		dst = saturate(dst);
		
	    //fragColor.rgb = float3(dst,dst,dst);
	    fragColor.rgb = _Color * dst;
		fragColor.a = dst;
		
		return fragColor;
	}
	
	
	ENDCG
	
	SubShader {
		Pass
	    {
	        CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag_dot
            #pragma target 3.0

			ENDCG
		}// end Pass
		
		Pass
	    {
	        CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag_outline
            #pragma target 3.0

			ENDCG
		}// end Pass
		
		
	}
	
}
