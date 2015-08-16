
Shader "Hidden/EdgeOutline" { 
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
		_Color ("Color", Color) = (1,1,1,1)
	}

	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	struct v2f {
		float4 pos : SV_POSITION;
		float2 uv[5] : TEXCOORD0;
	};
	

	sampler2D _MainTex;
	uniform float4 _MainTex_TexelSize;
	
	float4 _Color;

	sampler2D _CameraDepthNormalsTexture;
	sampler2D_float _CameraDepthTexture;

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
	
	half4 fragThin (v2f i) : SV_Target
	{
		half sampleDist = _SampleDistance*2.4;
		half4 colSample1 = tex2D(_MainTex, i.uv[0] + float2(0, -_MainTex_TexelSize.y) * sampleDist);
		half4 colSample2 = tex2D(_MainTex, i.uv[0] + float2(0, +_MainTex_TexelSize.y) * sampleDist );
		half4 colSample3 = tex2D(_MainTex, i.uv[0] + float2(-_MainTex_TexelSize.x, 0) * sampleDist );
		half4 colSample4 = tex2D(_MainTex, i.uv[0] + float2(+_MainTex_TexelSize.x, 0) * sampleDist );
		
		half4 center = tex2D (_CameraDepthNormalsTexture, i.uv[1]);
		half4 sample1 = tex2D (_CameraDepthNormalsTexture, i.uv[2]);
		half4 sample2 = tex2D (_CameraDepthNormalsTexture, i.uv[3]);
		
		// encoded normal
		half2 centerNormal = center.xy;
		// decoded depth
		float centerDepth = DecodeFloatRG (center.zw);
		
		half edge = 1.0;
		
		half4 lineColor = half4(0., 0., 0., 1.0);
		
		edge *= CheckSame(centerNormal, centerDepth, sample1);
		edge *= CheckSame(centerNormal, centerDepth, sample2);
		//edge = saturate(edge);
		
		float dst = 1.0 - edge;
		//if( edge < 0.9){
			half v1 = (colSample1.r + colSample1.g + colSample1.b) / 3.0f;
			half v2 = (colSample2.r + colSample2.g + colSample2.b) / 3.0f;
			half v3 = (colSample3.r + colSample3.g + colSample3.b) / 3.0f;
			half v4 = (colSample4.r + colSample4.g + colSample4.b) / 3.0f;
			half avg = (v1 + v2 + v3 + v4)/4.0;
			
			if(avg < 0.4){
				lineColor = _Color;
				//dst = 0.0;
			}
		//}
		
		half4 c = lineColor;

		c.a = dst * 0.8;
		return c;
	}
	
	ENDCG 
	
Subshader {
 Pass {
	  ZTest Always Cull Off ZWrite Off
	  Fog { Mode off }      

      CGPROGRAM
      #pragma vertex vertThin
      #pragma fragment fragThin
      #pragma target 3.0 
      ENDCG
  }
}

Fallback off
	
} // shader