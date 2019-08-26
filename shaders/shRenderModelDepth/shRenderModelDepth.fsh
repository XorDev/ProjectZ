struct PS {
    float4 Position : SV_Position0;
    float2 Texcoord : TEXCOORD0;
    float1 Depth    : TEXCOORD1;
};

float4 pack(float z0) {
    int z = asuint(z0);// * (0xFFFFFFFF / _Far);
    
    return float4(
         z        & 0xFF, 
        (z >>  8) & 0xFF, 
        (z >> 16) & 0xFF, 
        (z >> 24) & 0xFF
    );
}

float unpack(float4 z0) {
    int z0x = z0.x * 0xFF;
    int z0y = z0.y * 0xFF;
    int z0z = z0.z * 0xFF;
    int z0w = z0.w * 0xFF;
    
    return z0x | (z0y << 8) | (z0z << 16) | (z0w << 24);
}

float Pack3PNForFP32(float3 channel)
{
    // layout of a 32-bit fp register
    // SEEEEEEEEMMMMMMMMMMMMMMMMMMMMMMM
    // 1 sign bit; 8 bits for the exponent and 23 bits for the mantissa
    uint uValue = 0;
    
    // pack x
    uValue = ((uint)(channel.x * 65535.0 + 0.5)); // goes from bit 0 to 15
    
    // pack y in EMMMMMMM
    uValue |= ((uint)(channel.y * 255.0 + 0.5)) << 16;
    
    // pack z in SEEEEEEE
    // the last E will never be 1b because the upper value is 254
    // max value is 11111110 == 254
    // this prevents the bits of the exponents to become all 1
    // range is 1.. 254
    // to prevent an exponent that is 0 we add 1.0
    uValue |= ((uint)(channel.z * 253.0 + 1.5)) << 24;
    
    return asfloat(uValue);
}

// unpack three positive normalized values from a 32-bit float
float3 Unpack3PNFromFP32(float fFloatFromFP32)
{
    float a, b, c, d;
    uint uValue = 0;
    
    uint uInputFloat = asuint(fFloatFromFP32);
    
    // unpack a
    // mask out all the stuff above 16-bit with 0xFFFF
    a = ((uInputFloat) & 0xFFFF) / 65535.0;
     
    b = ((uInputFloat >> 16) & 0xFF) / 255.0;
    
    // extract the 1..254 value range and subtract 1
    // ending up with 0..253
    c = (((uInputFloat >> 24) & 0xFF) - 1.0) / 253.0;
    
    return float3(a, b, c);
}

inline float vtof(float3 v) /*{ return v.r * 64000.; } //*/{ return v.r * 65536. + v.g * 256. + v.b; }
inline float3 ftov(float f) { return float3(floor(f / 256.) / 256., frac(f / 256.), frac(floor(f * 256.) / 256.)); }

float4 main(PS In) : SV_Target0 {
    return float4(ftov(In.Depth), 1.);
}
