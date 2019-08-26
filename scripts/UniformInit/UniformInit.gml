/// @arg ShaderID
var shader = argument0;

_Far           [shader] = shader_get_uniform(shader, "_Far"           );
_LightMatrix   [shader] = shader_get_uniform(shader, "_LightMatrix"   );
_SunDir        [shader] = shader_get_uniform(shader, "_SunDir"        );
_CameraPos     [shader] = shader_get_uniform(shader, "_CameraPos"     );
_ShadowMapSize [shader] = shader_get_uniform(shader, "_ShadowMapSize" );
_ShadowMapTexel[shader] = shader_get_uniform(shader, "_ShadowMapTexel");

_CelShading  [shader] = shader_get_uniform(shader, "_CelShading"  );
_Tonemapping [shader] = shader_get_uniform(shader, "_Tonemapping" );
_Fog         [shader] = shader_get_uniform(shader, "_Fog"         );
_FogHeight   [shader] = shader_get_uniform(shader, "_FogHeight"   );
_FogDistant  [shader] = shader_get_uniform(shader, "_FogDistant"  );
_Shadows     [shader] = shader_get_uniform(shader, "_Shadows"     );
_RimLight    [shader] = shader_get_uniform(shader, "_RimLight"    );
_HFogNear    [shader] = shader_get_uniform(shader, "_HFogNear"    );
_HFogHeight  [shader] = shader_get_uniform(shader, "_HFogHeight"  );
_HFogFalloff [shader] = shader_get_uniform(shader, "_HFogFalloff" );
_DFogStart   [shader] = shader_get_uniform(shader, "_DFogStart"   );
_CSSteps     [shader] = shader_get_uniform(shader, "_CSSteps"     );
_CSStepsInv  [shader] = shader_get_uniform(shader, "_CSStepsInv"  );
_FogDensity  [shader] = shader_get_uniform(shader, "_FogDensity"  );
_RLLowBound  [shader] = shader_get_uniform(shader, "_RLLowBound"  );
_Exposure    [shader] = shader_get_uniform(shader, "_Exposure"    );

_SkyColor[shader] = shader_get_uniform(shader, "_SkyColor");
_FogColor[shader] = shader_get_uniform(shader, "_FogColor");
_SunColor[shader] = shader_get_uniform(shader, "_SunColor");

_Selection[shader] = shader_get_uniform(shader, "_Selection"); // Debug
_Selected [shader] = shader_get_uniform(shader, "_Selected" );

_Emission[shader] = shader_get_uniform(shader, "_Emission");

