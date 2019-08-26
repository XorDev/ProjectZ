/// @arg shader
/// @arg {string} variable
gml_pragma("forceinline");
argument1 += "Sampl";
var v = shader_get_sampler_index(argument0, argument1);

if( variable_instance_exists(id, argument1) ) {
    var i = 1;
    while( variable_instance_exists(id, argument1 + string(i++)) ) {  };
    
    i--;
    argument1 += string( i ); // _DiffuseSampl, _DiffuseSampl1, _DiffuseSampl2 and etc...
}

variable_instance_set(id, argument1, v);
show_debug_message("[" + shader_get_name(argument0) + "]: SamplerState " + argument1
    + ( (v > -1) ? (" : register(s" + string(v) + ");") : ";"));
