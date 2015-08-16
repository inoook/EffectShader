Shader "Custom/Blur" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		useBlur ("useBlur", Int) = 1
		v ("v", Float) = 1
	}
	SubShader {
		
		Pass
	    {            
	        CGPROGRAM
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
			uniform bool useBlur;
			uniform half v;
			
			float4 frag(v2f i) : COLOR {
				half2 vUv = i.uv;
				
				float2 screenUV = i.screenPos.xy / i.screenPos.w;
				float2 fragCoord_xy = ((screenUV.xy + 1) * 0.5) * _ScreenParams.xy;   // I need 0 to 1
				//half2 fragCoord = i.uv;
//				float4 p = UNITY_MATRIX_MVP[3];
//				// get screen coords from clip space coords:
//				p.xy /= p.w;
//				half2 fragCoord_xy = 0.5*(p.xy+1.0) * _ScreenParams.xy;
				//half2 fragCoord = i.uv;
				// _ScreenParams
				
				float tFragV = 1.0 / _ScreenParams.y;
				float2 tFrag = float2(tFragV, tFragV);
			    float4 destColor = tex2D(_MainTex, fragCoord_xy * tFrag);
			    if(useBlur){
			        destColor *= 0.36;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2(-1.0,  1.0)) * tFrag * v) * 0.04;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2( 0.0,  1.0)) * tFrag * v) * 0.04;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2( 1.0,  1.0)) * tFrag * v) * 0.04;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2(-1.0,  0.0)) * tFrag * v) * 0.04;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2( 1.0,  0.0)) * tFrag * v) * 0.04;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2(-1.0, -1.0)) * tFrag * v) * 0.04;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2( 0.0, -1.0)) * tFrag * v) * 0.04;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2( 1.0, -1.0)) * tFrag * v) * 0.04;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2(-2.0,  2.0)) * tFrag * v) * 0.02;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2(-1.0,  2.0)) * tFrag * v) * 0.02;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2( 0.0,  2.0)) * tFrag * v) * 0.02;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2( 1.0,  2.0)) * tFrag * v) * 0.02;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2( 2.0,  2.0)) * tFrag * v) * 0.02;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2(-2.0,  1.0)) * tFrag * v) * 0.02;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2( 2.0,  1.0)) * tFrag * v) * 0.02;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2(-2.0,  0.0)) * tFrag * v) * 0.02;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2( 2.0,  0.0)) * tFrag * v) * 0.02;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2(-2.0, -1.0)) * tFrag * v) * 0.02;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2( 2.0, -1.0)) * tFrag * v) * 0.02;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2(-2.0, -2.0)) * tFrag * v) * 0.02;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2(-1.0, -2.0)) * tFrag * v) * 0.02;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2( 0.0, -2.0)) * tFrag * v) * 0.02;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2( 1.0, -2.0)) * tFrag * v) * 0.02;
			        destColor += tex2D(_MainTex, (fragCoord_xy + float2( 2.0, -2.0)) * tFrag * v) * 0.02;
			    }
				
				float4 fragColor = destColor;
				return fragColor;
			}
			
			ENDCG
		}

	}
	
}
