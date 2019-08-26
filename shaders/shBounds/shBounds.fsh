struct PS {
    float4 Position : SV_Position0;
};

float4 main(PS In) : SV_Target0 {
    return float4(1., 0., 0., 1.);
}
