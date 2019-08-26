/// @arg x
/// @arg y
/// @arg z
/// @arg [mat]
var m = matrix_build(0, 0, 0, argument[0], argument[1], argument[2], 1, 1, 1);
if( argument_count == 4 ) {
    return matrix_add(argument[3], m);
} else {
    matrix_add_world(m);
}
