Shader "Custom/DepthTest" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Pass
	    {            
	        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            
			uniform sampler2D _MainTex;
			
			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			
			v2f vert( appdata_base v )
			{
				v2f o;
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord.xy;
				
				return o;
			}
			
			float4 frag(v2f i) : COLOR {
				half2 p = i.uv;
				
				float4 fragColor = tex2D(_MainTex, p);
				return fragColor;
			}
			
			ENDCG
		}
	}
}
