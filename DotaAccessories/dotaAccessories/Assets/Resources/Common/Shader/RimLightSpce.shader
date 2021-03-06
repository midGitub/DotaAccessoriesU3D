Shader "Hidden/RimLightSpce" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	_RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
    _RimPower ("Rim Power", Range(0.5,8.0)) = 2.0
    _Strength ("Rim Strength", Range(0, 100.0)) = 1.0
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 300
	
CGPROGRAM
#pragma surface surf BlinnPhong

sampler2D _MainTex;
fixed4 _Color;
half _Shininess;
float4 _RimColor;
float _RimPower;
float _Strength;

struct Input {
	float2 uv_MainTex;
	float3 viewDir;
	float3 worldNormal; 
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = tex.rgb * _Color.rgb;
	o.Gloss = tex.a;
	o.Alpha = tex.a * _Color.a;
	o.Specular = _Shininess;
	half rim = 1.0 - saturate(dot (normalize(IN.viewDir), IN.worldNormal));
    o.Emission = _RimColor.rgb * pow (rim, _RimPower) * _Strength;
}
ENDCG
}

Fallback "VertexLit"
}
