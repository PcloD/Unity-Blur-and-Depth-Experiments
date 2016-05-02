Shader "Test/RenderMotionVector" {
	Properties{
	}
	SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		Pass{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"

		// the model*view matrix of the last frame
		float4x4 _Previous_MV;

	struct v2f {
		float4 position : SV_POSITION;
		float4 curPos : TEXCOORD0;
		float4 lastPos : TEXCOORD1;
	};


	v2f vert(appdata_full v)
	{
		v2f o;

		o.position = mul(UNITY_MATRIX_MVP, v.vertex);
		o.curPos = o.position;
		o.lastPos = mul(UNITY_MATRIX_P, mul(_Previous_MV, v.vertex));

		return o;
	}

	float4 frag(v2f i) : COLOR
	{
		float2 a = (i.curPos.xy / i.curPos.w) * 0.5 + 0.5;
		float2 b = (i.lastPos.xy / i.lastPos.w) * 0.5 + 0.5;
		float2 oVelocity = a - b;
		return float4(oVelocity.x, -oVelocity.y, 0, 1);
	}

		ENDCG
	}
	}
		SubShader{
		Tags{ "RenderType" = "TreeBark" }
		LOD 200

		Pass{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"
#include "TerrainEngine.cginc"

		// the model*view matrix of the last frame
		float4x4 _Previous_MV;

	struct v2f {
		float4 position : SV_POSITION;
		float4 curPos : TEXCOORD0;
		float4 lastPos : TEXCOORD1;
	};

	v2f vert(appdata_full v)
	{
		v2f o;

		//v.vertex.xyz *= _Scale.xyz;
		v.vertex = AnimateVertex(v.vertex, v.normal, float4(v.color.xyz, v.texcoord1.xy));
		v.vertex = Squash(v.vertex);

		o.position = mul(UNITY_MATRIX_MVP, v.vertex);
		o.curPos = o.position;
		o.lastPos = mul(UNITY_MATRIX_P, mul(_Previous_MV, v.vertex));

		return o;
	}

	float4 frag(v2f i) : COLOR
	{
		float2 a = (i.curPos.xy / i.curPos.w) * 0.5 + 0.5;
		float2 b = (i.lastPos.xy / i.lastPos.w) * 0.5 + 0.5;
		float2 oVelocity = a - b;
		return float4(oVelocity.x, -oVelocity.y, 0, 1);
	}

		ENDCG
	}
	}
		SubShader{
		Tags{ "RenderType" = "TransparentCutout" }
		LOD 200

		Pass{
		ZWrite Off
		AlphaTest Greater[_Cutoff]
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"

		sampler2D _MainTex;

	// the model*view matrix of the last frame
	float4x4 _Previous_MV;

	struct v2f {
		float4 position : SV_POSITION;
		float4 curPos : TEXCOORD0;
		float4 lastPos : TEXCOORD1;
		float4 tex : TEXCOORD2;
	};

	v2f vert(appdata_base v)
	{
		v2f o;

		o.position = mul(UNITY_MATRIX_MVP, v.vertex);
		o.curPos = o.position;
		o.lastPos = mul(UNITY_MATRIX_P, mul(_Previous_MV, v.vertex));
		o.tex = v.texcoord;

		return o;
	}

	float4 frag(v2f i) : COLOR
	{
		float2 a = (i.curPos.xy / i.curPos.w) * 0.5 + 0.5;
		float2 b = (i.lastPos.xy / i.lastPos.w) * 0.5 + 0.5;
		float2 oVelocity = a - b;
		return float4(oVelocity.x, -oVelocity.y, 0, tex2D(_MainTex, i.tex.xy).a);
	}

		ENDCG
	}
	}
		SubShader{
		Tags{ "RenderType" = "TreeLeaf" }
		LOD 200

		Pass{
		ZWrite Off
		AlphaTest Greater[_Cutoff]
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"
#include "TerrainEngine.cginc"

		sampler2D _MainTex;

	// the model*view matrix of the last frame
	float4x4 _Previous_MV;

	struct v2f {
		float4 position : SV_POSITION;
		float4 curPos : TEXCOORD0;
		float4 lastPos : TEXCOORD1;
		float4 tex : TEXCOORD2;
	};

	v2f vert(appdata_full v)
	{
		v2f o;

		ExpandBillboard(UNITY_MATRIX_IT_MV, v.vertex, v.normal, v.tangent);
		//v.vertex.xyz *= _Scale.xyz;
		v.vertex = AnimateVertex(v.vertex, v.normal, float4(v.color.xyz, v.texcoord1.xy));
		v.vertex = Squash(v.vertex);

		o.position = mul(UNITY_MATRIX_MVP, v.vertex);
		o.curPos = o.position;
		o.lastPos = mul(UNITY_MATRIX_P, mul(_Previous_MV, v.vertex));
		o.tex = v.texcoord;

		return o;
	}

	float4 frag(v2f i) : COLOR
	{
		float2 a = (i.curPos.xy / i.curPos.w) * 0.5 + 0.5;
		float2 b = (i.lastPos.xy / i.lastPos.w) * 0.5 + 0.5;
		float2 oVelocity = a - b;
		return float4(oVelocity.x, -oVelocity.y, 0, tex2D(_MainTex, i.tex.xy).a);
	}

		ENDCG
	}
	}
}