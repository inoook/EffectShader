/**
 * @author Felix Turner / www.airtight.cc / @felixturner
 *
 * Bad TV Shader
 * Simulates a bad TV via horizontal distortion and vertical roll
 * Uses Ashima WebGl Noise: https://github.com/ashima/webgl-noise
 *
 * time: steadily increasing float passed in
 * distortion: amount of thick distortion
 * distortion2: amount of fine grain distortion
 * speed: distortion vertical travel speed
 * rollSpeed: vertical roll speed
 * 
 * The MIT License
 * 
 * Copyright (c) 2014 Felix Turner
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */
Shader "Custom/BadTV" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		time ("time", Float) = 0.0
		distortion ("distortion", Float) = 3.0
		distortion2 ("distortion2", Float) = 5.0
		speed ("speed", Float) = 0.2
		rollSpeed ("rollSpeed", Float) = 0.1
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
			
			uniform float time;
			uniform float distortion;
			uniform float distortion2;
			uniform float speed;
			uniform float rollSpeed;
			//varying vec2 vUv;
			
			// Start Ashima 2D Simplex Noise

			half3 mod289(half3 x) {
				return x - floor(x * (1.0 / 289.0)) * 289.0;
			}
			half2 mod289(half2 x) {
				return x - floor(x * (1.0 / 289.0)) * 289.0;
			}
			half3 permute(half3 x) {
				return mod289(((x*34.0)+1.0)*x);
			}
			
			float snoise(half2 v)
			{
				const half4 C = half4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0",
								0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)",
								-0.577350269189626,  // -1.0 + 2.0 * C.x",
								0.024390243902439); // 1.0 / 41.0",
				half2 i  = floor(v + dot(v, C.yy) );
				half2 x0 = v -   i + dot(i, C.xx);

				half2 i1;
				i1 = (x0.x > x0.y) ? half2(1.0, 0.0) : half2(0.0, 1.0);
				half4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;

				i = mod289(i); // Avoid truncation effects in permutation",
				half3 p = permute( permute( i.y + half3(0.0, i1.y, 1.0 )) + i.x + half3(0.0, i1.x, 1.0 ));

				half3 m = max(0.5 - half3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
				m = m*m;
				m = m*m;

				//half3 x = 2.0 * fract(p * C.www) - 1.0;
				half3 x = 2.0 * frac(p * C.www) - 1.0;
				half3 h = abs(x) - 0.5;
				half3 ox = floor(x + 0.5);
				half3 a0 = x - ox;

				m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

				half3 g;
				g.x  = a0.x  * x0.x  + h.x  * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot(m, g);
			}

			// End Ashima 2D Simplex Noise

			float4 frag(v2f_img i) : COLOR {
				half2 p = i.uv;
				
				float ty = time*speed;
				float yt = p.y - ty;

				//smooth distortion
				float offset = snoise(half2(yt*3.0,0.0))*0.2;
				// boost distortion
				offset = pow( offset*distortion,3.0)/distortion;
				//add fine grain distortion
				offset += snoise(half2(yt*50.0,0.0))*distortion2*0.001;
				//combine distortion on X with roll on Y
				float4 fragColor = tex2D(_MainTex,  half2(frac(p.x + offset),frac(p.y-time*rollSpeed) ));
				return fragColor;
			}
			
			ENDCG
		}
	} 
}
