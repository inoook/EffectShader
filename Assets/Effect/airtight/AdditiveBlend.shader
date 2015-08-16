// http://www.airtightinteractive.com/demos/js/ledeffect/AdditiveBlendShader.js
/**
 * @author felixturner / http://airtight.cc/
 *
 * Simple additive buffer blending - makes things glowy
 *
 * based on @author Thibaut 'BKcore' Despoulain <http://bkcore.com>
 * from http://www.clicktorelease.com/code/perlin/lights.html
 *
 * tBase: base texture
 * tAdd: texture to add
 * amount: amount to add 2nd texture
 */
 
Shader "Custom/AdditiveBlend" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		tAdd ("tAdd (RGB)", 2D) = "white" {}
		amount ("amount", Float) = 1.0 
	}
	SubShader {
		Pass
	    {            
	        CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            
			uniform sampler2D _MainTex;
			uniform sampler2D tAdd;
			uniform float amount;
			
			float4 frag(v2f_img i) : COLOR {
				half2 vUv = i.uv;
				
				vec4 texel1 = tex2D( _MainTex, vUv );
				vec4 texel2 = tex2D( tAdd, vUv );
				vec4 fragColor = texel1 + texel2 * amount;
				
				return fragColor;
			}
			
			ENDCG
		}
	} 
	
}
