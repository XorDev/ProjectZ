/// @arg x
/// @arg y
/// @arg z
/// @arg [mat]
var m = matrix_build(argument[0], argument[1], argument[2], 0, 0, 0, 1, 1, 1);
if( argument_count == 4 ) {
    return matrix_add(argument[3], m);
} else {
    matrix_add_world(m);
}
