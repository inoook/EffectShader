// http://dev.delezu.net/js/shaders/DigitalGlitch.js
// http://dev.delezu.net/webgl_postprocessing_glitch.html
Shader "Custom/DigitalGlitch" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		tDisp ("tDisp (RGB)", 2D) = "white" {}
		colorDisp ("ColorDisp (RGB)", 2D) = "white" {}
		
		byp("byp", Int) = 0
		amount("amount", Float) = 0.08
		angle("angle", Float) = 0.02
		seed("seed", Float) = 0.02
		seed_x("seed_x", Float) = 0.02
		seed_y("seed_y", Float) = 0.02
		distortion_x("distortion_x", Float) = 0.5
		distortion_y("distortion_y", Float) = 0.6
		col_s("col_s", Float) = 0.05
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
			
			uniform int byp;//should we apply the glitch ?
		
		//uniform sampler2D tDiffuse;
		uniform sampler2D tDisp;
		uniform sampler2D colorDisp;
		
		uniform float amount;
		uniform float angle;
		uniform float seed;
		uniform float seed_x;
		uniform float seed_y;
		uniform float distortion_x;
		uniform float distortion_y;
		uniform float col_s;
		
		float rand(float2 co){
			return frac(sin(dot(co.xy , float2(12.9898,78.233))) * 43758.5453);
		}
			
			float4 frag(v2f_img i) : COLOR {
				half2 vUv = i.uv;
				float4 fragColor;
				
				if(byp < 1) {
				float2 p = vUv;
//				float xs = floor(gl_FragCoord.x / 0.5);
//				float ys = floor(gl_FragCoord.y / 0.5);
//				float xs = floor((p.x/_ScreenParams.x) / 0.5);
//				float ys = floor((p.y/_ScreenParams.y) / 0.5);
				float xs = floor((p.x) / 0.5);
				float ys = floor((p.y) / 0.5);
				//based on staffantans glitch shader for unity https://github.com/staffantan/unityglitch
				float4 normal = tex2D (tDisp, p*seed*seed);
				if(p.y < distortion_x + col_s && p.y > distortion_x - col_s*seed) {
//					if(seed_x > 0.){
//						p.y = 1. - (p.y + distortion_y);
//					} else {
//						p.y = distortion_y;
//					}
//
					p.y = 1. - (p.y + distortion_y);
				}
				if(p.x < distortion_y + col_s && p.x > distortion_y - col_s*seed) {
//					if(seed_y > 0.){
//						p.x = distortion_x;
//					} else {
//						p.x = 1. - (p.x + distortion_x);
//					}
//					
					p.x = 1. - (p.x + distortion_x);
				}
				
				p.x += normal.x*seed_x*(seed/5.);
				p.y += normal.y*seed_y*(seed/5.);
				
				//base from RGB shift shader
				float2 offset = amount * float2( cos(angle), sin(angle));
				float4 cr = tex2D(_MainTex, p + offset);
				float4 cga = tex2D(_MainTex, p);
				float4 cb = tex2D(_MainTex, p - offset);
				fragColor = float4(cr.r, cga.g, cb.b, cga.a);
				
				//add noise
				float sv = rand(float2(xs * seed,ys * seed*0.5))*0.02;
				float4 snow = 0.2*amount*float4(sv, sv, sv, sv);
				//float4 snow = 0.2*amount*float4(rand(float2(xs * seed,ys * seed*0.5))*0.02);
				
				float4 colorOffset = tex2D (colorDisp, p);
				snow.rgb = snow.rgb - colorOffset.rgb * 0.25;
				
				fragColor = fragColor + snow;
				
			}else {
				fragColor = tex2D (_MainTex, vUv);
			}
				
				return fragColor;
			}
			
			ENDCG
		}
	}
}
