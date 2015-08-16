// http://sugi.cc/post/78562863840/squareeffect
Shader "Custom/Squres" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Scale ("scale", Float) = 100
		_Size ("size", Range(0,0.5)) = 0.4
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
		half _Scale, _Size;
		
		float rand( float2 co ){
			return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
		}
		float3 rand3( float2 seed ){
			float t = sin(seed.x + seed.y * 1e3);
			return float3(frac(t*1e4), frac(t*1e6), frac(t*1e5));
		}
		
		half4 square(half2 pos, half2 pos2, half size, half h, sampler2D tex, half scale){
			half t = _Time.y + rand(pos2+h);
			half4 c = 0;
			half2 center = pos2 + rand3(pos2 + half2(floor(t)/h*0.3,h)*pos2).xy;
			half2 center2 = center / scale;
			center2.x /= _MainTex_TexelSize.y/_MainTex_TexelSize.x;
			
			t = frac(t);
			c = tex2D(tex, center2);
			size *= t * length(c);
			c *= saturate(size - abs(pos.x - center.x)) * saturate(size - abs(pos.y - center.y)) > 0;
			
			return c * (1-t)*4;
		}
		
		
		half4 squares(half2 pos, sampler2D tex, half scale, half size, fixed num){
			half4 c = 0;
			pos.x *= _MainTex_TexelSize.y/_MainTex_TexelSize.x;
			pos *= scale;
			half2
				fl = floor(pos),
				cl = ceil(pos),
				p1 = fl,
				p2 = half2(fl.x, cl.y),
				p3 = half2(cl.x, fl.y),
				p4 = cl,
				
				p5 = p1 + half2(-1,0),
				p6 = p1 + half2(0,-1),
				p7 = p1 + half2(-1,-1);
			
			for(fixed i = 0; i < 1; i = i + 1/num){
				c += square(pos, p1, size, i, tex, scale);
				c += square(pos, p2, size, i, tex, scale);
				c += square(pos, p3, size, i, tex, scale);
				c += square(pos, p4, size, i, tex, scale);
				
				c += square(pos, p5, size, i, tex, scale);
				c += square(pos, p6, size, i, tex, scale);
				c += square(pos, p7, size, i, tex, scale);
			}
			return c*1/num;
		}
			
		fixed4 frag(v2f_img i) : COLOR{
			return squares(i.uv, _MainTex, _Scale, _Size, 3.4);
		}
	ENDCG
	
	SubShader {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }  
		ColorMask RGB
 
		pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma target 3.0
			#pragma glsl
			ENDCG
		}
	} 
}