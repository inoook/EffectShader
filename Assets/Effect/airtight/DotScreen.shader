Shader "Custom/DotScreen" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
		tSize ("tSize (vec2)", Vector) = ( 256, 256, 0, 0 )
		center ("center (vec2)", Vector) = ( 0.5, 0.5, 0, 0 )
		angle ("angle", Float) = 1.57
		scale ("scale", Float) = 1.0
	}
	
	SubShader {

		Pass
	    {            
	        CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"
	
			uniform sampler2D _MainTex;
			
			uniform half2 center;
			uniform float angle;
			uniform float scale;
			uniform half2 tSize;
			
			float pattern(v2f_img i) {
				half2 vUv = i.uv;
				float s = sin( angle );
				float c = cos( angle );
				half2 tex = vUv * tSize - center;
				half2 pt = half2( c * tex.x - s * tex.y, s * tex.x + c * tex.y ) * scale;

				return ( sin( pt.x ) * sin( pt.y ) ) * 4.0;
			}

			float4 frag(v2f_img i) : COLOR {
				half2 vUv = i.uv;
				
				float4 col = tex2D( _MainTex, vUv );
				float average = ( col.r + col.g + col.b ) / 3.0;
				float newColor = average * 10.0 - 5.0 + pattern(i);
				float4 fragColor = float4( newColor, newColor, newColor, col.a );
				return fragColor;
			}                         
	        ENDCG        
	    }
	}
}
