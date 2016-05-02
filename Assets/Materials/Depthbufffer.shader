Shader "Custom/DepthBufferTest" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
	}
		SubShader{
		Tags{ "RenderType" = "Transparent" "Queue" = "Transparent+10" }
		LOD 200
		Zwrite On
		Blend SrcAlpha OneMinusSrcAlpha
		Pass{
		CGPROGRAM
#pragma vertex vert_img
#pragma fragment frag

#include "UnityCG.cginc"

		uniform sampler2D _MainTex;
	float4 _Color;
	fixed4 frag(v2f_img i) : SV_Target{
		return tex2D(_MainTex, i.uv) * _Color;
	}
		ENDCG
	}
	}
		FallBack "Diffuse"
}
