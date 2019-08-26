/// @arg shader
/// @arg {string} variable
gml_pragma("forceinline");
var v = shader_get_uniform(argument0, argument1);

if( variable_instance_exists(id, argument1) ) {
    var i = 1;
    while( variable_instance_exists(id, argument1 + string(i++)) ) {  };
    
    i--;
    argument1 += string( i ); // _Far, _Far1, _Far2 and etc...
}

variable_instance_set(id, argument1, v);
show_debug_message("[" + shader_get_name(argument0) + "]: uniform " + argument1
    + ( (v > -1) ? (" : register(c" + string(v) + ");") : ";"));
