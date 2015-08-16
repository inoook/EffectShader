Shader "Custom/Swill" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		rand ("rand", Float) = 0
		timer ("timer", Float) = 0
		frequency ("frequency", Float) = 1
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
			float timer;
			float frequency;
			
			float4 frag(v2f_img i) : COLOR {
				half2 pos = i.uv;
				
				half2 txCoord = half2(pos.x,pos.y);
				float4 col = tex2D(_MainTex, txCoord);
				//vec4 col_s = texture2DRect(image,texCoord + vec2(sin(pos.y*0.03+timer*20.0)*(6.0+12.0*rand),0));
				float4 col_s = tex2D(_MainTex, txCoord + float2(sin( float(pos.y*frequency+timer) )*(12.0*rand)*0.01, 0) );

				col = col_s;
				//    col.r = col.r * sin(rand);
				//	col.g = col.g * sin(rand*1.34+pos.y);
				//	col.b = col.b * cos(rand*1.56+pos.x*pos.y);
				
				return col.rgba;
			}
			
			ENDCG
		}
	}
}
