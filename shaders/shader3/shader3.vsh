Texture2D gm_BaseTextureObject : register(t0);
SamplerState gm_BaseTexture    : register(s0);

cbuffer gm_PSMaterialConstantBuffer
{
	bool   gm_PS_FogEnabled;
	float4 gm_FogColour;
	bool   gm_AlphaTestEnabled;
	float4 gm_AlphaRefValue;
};
