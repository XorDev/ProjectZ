Texture2D gm_BaseTextureObject : register(t0);
SamplerState gm_BaseTexture    : register(s0);

Texture2D _HDR_HighBitsTexture  : register(t1);
SamplerState _HDR_HiBitsSampler : register(s1);

struct PS {
    float4 Position : SV_Position0;
    float2 Texcoord : TEXCOORD0;
};

#region ACES
//=================================================================================================
//
//  Baking Lab
//  by MJP and David Neubelt
//  http://mynameismjp.wordpress.com/
//
//  All code licensed under the MIT license
//
//=================================================================================================

// The code in this file was originally written by Stephen Hill (@self_shadow), who deserves all
// credit for coming up with this fit and implementing it. Buy him a beer next time you see him. :)

// sRGB => XYZ => D65_2_D60 => AP1 => RRT_SAT
static const float3x3 ACESInputMat =
{
    {0.59719, 0.35458, 0.04823},
    {0.07600, 0.90834, 0.01566},
    {0.02840, 0.13383, 0.83777}
};

// ODT_SAT => XYZ => D60_2_D65 => sRGB
static const float3x3 ACESOutputMat =
{
    { 1.60475, -0.53108, -0.07367},
    {-0.10208,  1.10813, -0.00605},
    {-0.00327, -0.07276,  1.07602}
};

float3 RRTAndODTFit(float3 v)
{
    float3 a = v * (v + 0.0245786f) - 0.000090537f;
    float3 b = v * (0.983729f * v + 0.4329510f) + 0.238081f;
    return a / b;
}

float3 ACESFitted(float3 color)
{
    color = mul(ACESInputMat, color);

    // Apply RRT and ODT
    color = RRTAndODTFit(color);

    color = mul(ACESOutputMat, color);

    // Clamp to [0, 1]
    color = saturate(color);

    return color;
}
#endregion

bool _ACES;

float4 main(PS In) : SV_Target0 {
    float4 Low  = gm_BaseTextureObject.Sample(gm_BaseTexture    , In.Texcoord);
    float4 High = _HDR_HighBitsTexture.Sample(_HDR_HiBitsSampler, In.Texcoord);
    
    float4 Out = float4(Low.rgb + High.rgb, 1.);
    
    [branch] if( _ACES ) Out.rgb = ACESFitted(Out.rgb);
    
    return Out;
}
