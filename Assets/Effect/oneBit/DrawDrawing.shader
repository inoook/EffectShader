Shader "Custom/DrawDrawing" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		rand ("Rand", Float) = 1.0
		_Step ("Step", Float) = 3
		_LineNoise ("LineNoize", Float) = 1.2
		_TextureNoise ("TextureNoise", Float) = 0.15
		_TextureV ("_TextureV", Float) = 1
		
	}
	SubShader {
		Pass
	    {            
	        CGPROGRAM
            #pragma vertex vertThin
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            #include "../Libs/Noise.cginc"
            
			uniform sampler2D _MainTex;
			uniform sampler2D _CameraDepthNormalsTexture;
			uniform float4 _MainTex_TexelSize;
			
			float rand;
			float _Step;
			
			float4 _Color;
			float4 _LineColor;
			float _LineNoise;
			float _TextureNoise;
			float _TextureV;
			
			uniform half4 _Sensitivity; 
			uniform half _SampleDistance;

			inline half CheckSame (half2 centerNormal, float centerDepth, half4 theSample)
			{
				// difference in normals
				// do not bother decoding normals - there's no need here
				half2 diff = abs(centerNormal - theSample.xy) * _Sensitivity.y;
				half isSameNormal = (diff.x + diff.y) * _Sensitivity.y < 0.1;
				// difference in depth
				float sampleDepth = DecodeFloatRG (theSample.zw);
				float zdiff = abs(centerDepth-sampleDepth);
				// scale the required threshold by the distance
				half isSameDepth = zdiff * _Sensitivity.x < 0.09 * centerDepth;
			
				// return:
				// 1 - if normals and depth are similar enough
				// 0 - otherwise
				
				return isSameNormal * isSameDepth;
			}
			
			float stepColor(float c) {
				return floor(saturate(c)*(_Step*2)/2)/(_Step*2)*2;
			}
			
			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv[5] : TEXCOORD0;
			};
			
		v2f vertThin( appdata_img v )
		{
			v2f o;
			o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			
			float2 uv = v.texcoord.xy;
			o.uv[0] = uv;
			
			#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0)
				uv.y = 1-uv.y;
			#endif
			
			o.uv[1] = uv;
			o.uv[4] = uv;
					
			// offsets for two additional samples
	//		o.uv[2] = uv + float2(-_MainTex_TexelSize.x, -_MainTex_TexelSize.y) * _SampleDistance;
	//		o.uv[3] = uv + float2(+_MainTex_TexelSize.x, -_MainTex_TexelSize.y) * _SampleDistance;
			o.uv[2] = uv + float2(0, +_MainTex_TexelSize.y) * _SampleDistance;
			o.uv[3] = uv + float2(+_MainTex_TexelSize.x, 0) * _SampleDistance;
			
			return o;
		}	  
	
		float drawline (v2f i)
		{
			half sampleDist = _SampleDistance*2.4;
			
			half4 center = tex2D (_CameraDepthNormalsTexture, i.uv[1]);
			//half4 sample1 = tex2D (_CameraDepthNormalsTexture, i.uv[2]);
			//half4 sample2 = tex2D (_CameraDepthNormalsTexture, i.uv[3]);
			
//			half4 sample1 = tex2D(_CameraDepthNormalsTexture, i.uv[0] + float2(0, +_MainTex_TexelSize.y) * _SampleDistance );
//			half4 sample2 = tex2D(_CameraDepthNormalsTexture, i.uv[0] + float2(+_MainTex_TexelSize.x, 0) * _SampleDistance );
//			half4 sample3 = tex2D(_CameraDepthNormalsTexture, i.uv[0] + float2(0, -_MainTex_TexelSize.y) * _SampleDistance );
//			half4 sample4 = tex2D(_CameraDepthNormalsTexture, i.uv[0] + float2(-_MainTex_TexelSize.x, 0) * _SampleDistance );
			
			half4 sample1 = tex2D(_CameraDepthNormalsTexture, i.uv[0] + float2(-_MainTex_TexelSize.x, +_MainTex_TexelSize.y) * _SampleDistance );
			half4 sample2 = tex2D(_CameraDepthNormalsTexture, i.uv[0] + float2(+_MainTex_TexelSize.x, -_MainTex_TexelSize.y) * _SampleDistance );
			half4 sample3 = tex2D(_CameraDepthNormalsTexture, i.uv[0] + float2(+_MainTex_TexelSize.x, +_MainTex_TexelSize.y) * _SampleDistance );
			half4 sample4 = tex2D(_CameraDepthNormalsTexture, i.uv[0] + float2(-_MainTex_TexelSize.x, -_MainTex_TexelSize.y) * _SampleDistance );
			
			// encoded normal
			half2 centerNormal = center.xy;
			// decoded depth
			float centerDepth = DecodeFloatRG (center.zw);
			
			half edge = 1.0;
			
			half4 lineColor = half4(0., 0., 0., 1.0);
			
			edge *= CheckSame(centerNormal, centerDepth, sample1);
			edge *= CheckSame(centerNormal, centerDepth, sample2);
			edge *= CheckSame(centerNormal, centerDepth, sample3);
			edge *= CheckSame(centerNormal, centerDepth, sample4);
		
			//edge *= (CheckSame(centerNormal, centerDepth, sample1) + CheckSame(centerNormal, centerDepth, sample2) + CheckSame(centerNormal, centerDepth, sample3) + CheckSame(centerNormal, centerDepth, sample4))/4.0;
			
			float dst = saturate(edge);
			if( dst < 0.9){
				half4 colSample1 = tex2D(_MainTex, i.uv[0] + float2(0, -_MainTex_TexelSize.y) * sampleDist );
				half4 colSample2 = tex2D(_MainTex, i.uv[0] + float2(0, +_MainTex_TexelSize.y) * sampleDist );
				half4 colSample3 = tex2D(_MainTex, i.uv[0] + float2(-_MainTex_TexelSize.x, 0) * sampleDist );
				half4 colSample4 = tex2D(_MainTex, i.uv[0] + float2(+_MainTex_TexelSize.x, 0) * sampleDist );
				
				half v1 = (colSample1.r + colSample1.g + colSample1.b) / 3.0f;
				half v2 = (colSample2.r + colSample2.g + colSample2.b) / 3.0f;
				half v3 = (colSample3.r + colSample3.g + colSample3.b) / 3.0f;
				half v4 = (colSample4.r + colSample4.g + colSample4.b) / 3.0f;
				half avg = (v1 + v2 + v3 + v4)/4.0;
				
				if(avg < 0.4){
					dst = -dst;
				}
			}
			return dst;
			// drawline(i);  0 ( < 1): draw line color / ==1: no draw / 
		}
			
			half4 frag(v2f i) : COLOR
			{
				half2 vUv = i.uv[0];
				half2 pos = vUv * _ScreenParams;
				
				//深度に対して薄くする
				half4 dnPix = tex2D (_CameraDepthNormalsTexture, i.uv[0]);
				float depth = DecodeFloatRG (dnPix.zw);
								
//				half4 sample1 = tex2D(_CameraDepthNormalsTexture, i.uv[0] + float2(0, +_MainTex_TexelSize.y) * _SampleDistance );
//				half4 sample2 = tex2D(_CameraDepthNormalsTexture, i.uv[0] + float2(+_MainTex_TexelSize.x, 0) * _SampleDistance );
//				half4 sample3 = tex2D(_CameraDepthNormalsTexture, i.uv[0] + float2(0, -_MainTex_TexelSize.y) * _SampleDistance );
//				half4 sample4 = tex2D(_CameraDepthNormalsTexture, i.uv[0] + float2(-_MainTex_TexelSize.x, 0) * _SampleDistance );
				
				half4 sample1 = tex2D(_CameraDepthNormalsTexture, i.uv[0] + float2(-_MainTex_TexelSize.x, +_MainTex_TexelSize.y) * _SampleDistance );
				half4 sample2 = tex2D(_CameraDepthNormalsTexture, i.uv[0] + float2(+_MainTex_TexelSize.x, -_MainTex_TexelSize.y) * _SampleDistance );
				half4 sample3 = tex2D(_CameraDepthNormalsTexture, i.uv[0] + float2(+_MainTex_TexelSize.x, +_MainTex_TexelSize.y) * _SampleDistance );
				half4 sample4 = tex2D(_CameraDepthNormalsTexture, i.uv[0] + float2(-_MainTex_TexelSize.x, -_MainTex_TexelSize.y) * _SampleDistance );
				
				float depth1 = DecodeFloatRG (sample1.zw);
				float depth2 = DecodeFloatRG (sample2.zw);
				float depth3 = DecodeFloatRG (sample3.zw);
				float depth4 = DecodeFloatRG (sample4.zw);
				//float avgDepth = (depth + depth1 + depth2 + depth3 + depth4)/5;
				float avgDepth = 1.0;
				avgDepth = min(avgDepth, depth1);
				avgDepth = min(avgDepth, depth2);
				avgDepth = min(avgDepth, depth3);
				avgDepth = min(avgDepth, depth4);
				
				float4 col = tex2D( _MainTex, vUv );
				float average = ( col.r + col.g + col.b ) / 3.0;
				float nz = snoise(half2(pos.x*pos.y+rand , pos.x+pos.y-rand));
				
				float newColor = average - (_TextureV - 1.0);
				
				half lineNoizeV = _LineNoise;
				if(average < 1){
					//白でないときノイズを入れる
					newColor += (nz*_TextureNoise); // add noize
				}
				newColor = stepColor( saturate(newColor) ); // 階調化
				
				float4 fragColor = _Color + float4( newColor, newColor, newColor, col.a );
				
				// drawLine
				float lineV = drawline(i);
				float4 lineColor = _LineColor;
				if(lineV < 0.9){
					//fragColor = lineColor + abs(nz)*lineNoizeV;
					
					float4 nzColor = fragColor * abs(nz)*lineNoizeV;
					fragColor = lineColor + nzColor;

					//fragColor = lerp(fragColor, lineColor, abs(nz)*lineNoizeV);
					
				}
				//newColor += -(1-saturate(abs(lineV) + abs(nz)*lineNoizeV)); // ラインカラーのみ
				//newColor *= (saturate(abs(lineV) + abs(nz)*lineNoizeV)); // ラインカラーのみ
				//newColor += -sign(lineV)*(1-saturate(abs(lineV) + abs(nz)*lineNoizeV));// l背景が濃い時は白色
				
				//深度に対して薄くする
				if(avgDepth < 1.0){
					//newColor = saturate(newColor) + avgDepth*1.75;
					fragColor = saturate(fragColor) + avgDepth*1.75;
				}
				return fragColor;
			}
			
			ENDCG
		}
	}
	
}
