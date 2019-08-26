/// MaterialCreate([diffuse color, ambient color, reflectivity color, alpha, reflectivity value, diffuse map]);
if( argument_count == 0 ) {
    // Default one
    return [
        c_white, // Diffuse      //vec(255, 255, 255), 
        c_white, // Ambient      //vec(255, 255, 255), 
        c_black, // Reflect
        1,       // Alpha
        0,       // Reflect val [0 - 1000]
        -1,      // Diffuse map
        -1,      // Normal
        -1,      // Mask
        -1,      // Emission
        -1,      // Metallic AO Rougness
    ];
}

return [
    argument[0], //vec(colour_get_red(argument[0]), colour_get_green(argument[0]), colour_get_blue(argument[0])), 
    argument[1], //vec(colour_get_red(argument[1]), colour_get_green(argument[1]), colour_get_blue(argument[1])), 
    argument[2], 
    argument[3], 
    argument[4], 
    argument[5], 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    
];

