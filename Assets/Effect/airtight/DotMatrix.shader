// http://www.airtightinteractive.com/demos/js/ledeffect/DotMatrixShader.js
/**
 * @author felixturner / http://airtight.cc/
 *
 * Renders texture as a grid of dots like an LED display.
 * Pass in the webgl canvas dimensions to give accurate pixelization.
 *
 * spacing: distance between dots in px
 * size: radius of dots in px
 * blur: blur radius of dots in px
 * resolution: width and height of webgl canvas
 */
 
Shader "Custom/DotMatrix" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		spacing("spacing", Float) = 10.0
		size("size", Float) = 4.0
		blur("blur", Float) = 4.0
		//resolution("resolution (vec2)", Vector) = ( 800, 600, 0, 0)
	}
	SubShader {
//		ZTest Always Cull Off ZWrite Off
//		Fog { Mode off }  
//		ColorMask RGB
		
		Pass
	    {
	      
	        CGPROGRAM
	        #pragma fragmentoption ARB_precision_hint_fastest
            //#pragma vertex vert_img
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            
            struct v2f {
			    float4 position : POSITION;
			    float4 screenPos : TEXCOORD0;
			    float2 uv : TEXCOORD2;
			};
			
			v2f vert(appdata_base v){
				v2f o;
				o.position = mul (UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord.xy;
				o.screenPos = o.position;
				
				return o;
			}
			
			uniform sampler2D _MainTex;
			
			uniform float spacing;
			uniform float size;
			uniform float blur;
			//uniform half2 resolution;
			
			float4 frag(v2f i) : COLOR {
				float2 vUv = i.uv;
				float4 screenPos = i.screenPos;
				float2 screenUV = screenPos.xy / screenPos.w;
				float2 fragCoord_xy = (screenUV.xy + 1) * 0.5;   // I need 0 to 1
				
				half2 resolution = _ScreenParams.xy;
				
				float2 count = float2(resolution/spacing);
				float2 p = floor(vUv*count)/count;

				float4 t_color = tex2D(_MainTex, p);

				//vec2 pos = mod(gl_FragCoord.xy, vec2(spacing)) - vec2(spacing/2.0);
				float2 pos = fmod(fragCoord_xy * _ScreenParams.xy, float2(spacing, spacing)) - float2(spacing/2.0, spacing/2.0);
				
				float dist_squared = dot(pos, pos);
				
				float4 fragColor = lerp(t_color, float4(0.0, 0.0, 0.0, 0.0), smoothstep(size, size + blur, dist_squared) );
				
				return fragColor;
			}
			
			ENDCG
		}
	} 
	
}
