﻿//http://www.shaderslab.com/index.php?post/VHS-tape-effect

Shader "Hidden/VHSeffect"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_SecondaryTex("Secondary Texture", 2D) = "white" {}
		_OffsetNoiseX("Offset Noise X", float) = 0
		_OffsetNoiseY("Offset Noise Y", float) = 0
		_OffsetPosY("Offset position Y", float) = 0.0
		_OffsetColor("Offset Color", Range(0.005, 0.1)) = 0.001
		//_OffsetDistortion("Offset Distortion", float) = 2000
		_OffsetDistortion("Offset Distortion", float) = 900000
		_Intensity("Mask Intensity", Range(0.0, 1)) = 0.64
		_Opacity("Secondary Texture Opacity", Range(0.0, 1)) = 0.2
		_OffsetDirectionX("Offset Direction X", Float) = 1
		_OffsetDirectionY("Offset Direction Y", Float) = 1
	}
		SubShader
	{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
	{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

	struct v2f
	{
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
		float2 uv2 : TEXCOORD1;
	};

	half _OffsetNoiseX;
	half _OffsetNoiseY;

	v2f vert(appdata_base v)
	{
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord;
		o.uv2 = v.texcoord + float2(_OffsetNoiseX - 0.2f, _OffsetNoiseY);
		return o;
	}

	sampler2D _MainTex;
	sampler2D _SecondaryTex;

	fixed _Intensity;
	float _OffsetColor;
	half _OffsetPosY;
	half _OffsetDistortion;
	float _Opacity;
	float _OffsetDirectionX;
	float _OffsetDirectionY;

	fixed4 frag(v2f i) : SV_Target
	{
		i.uv = float2(frac(i.uv.x + cos((i.uv.y + _CosTime.y) * 100) / _OffsetDistortion), frac(i.uv.y + _OffsetPosY));

		fixed4 col = tex2D(_MainTex, i.uv);
		col.g = tex2D(_MainTex, i.uv + float2(_OffsetColor * _OffsetDirectionX, _OffsetColor * _OffsetDirectionY)).g;
		col.b = tex2D(_MainTex, i.uv + float2(-_OffsetColor * _OffsetDirectionX, -_OffsetColor * _OffsetDirectionY)).b;
		col.a = tex2D(_MainTex, i.uv + float2(-_OffsetColor * _OffsetDirectionX, -_OffsetColor * _OffsetDirectionY)).a;

		fixed4 col2 = tex2D(_SecondaryTex, i.uv2);
		col2.a = _Opacity;

		fixed4 ret = lerp(col, col2, ceil(col2.r - _Intensity)) * (1 - ceil(saturate(abs(i.uv.y - 0.5) - 0.49)));
		return ret;
	}
		ENDCG
	}
	}
}