Shader "Custom/postprocess_effect"
{
	Properties
	{
	_MainTex("Base (RGB)", 2D) = "white" {}
	}
	SubShader
	{
		Stencil
		{
			Ref 2
			Comp Equal
		}

		Pass
		{
			ZTest Always Cull Off ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_TexelSize;
			uniform fixed4 _Color;

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata_img v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord.xy;

				return o;
			}

			half4 frag(v2f i) : SV_Target
			{
				return tex2D(_MainTex, i.uv) * float4(1,0,0,1);
			}
			ENDCG
		}
	}

	Fallback off
}