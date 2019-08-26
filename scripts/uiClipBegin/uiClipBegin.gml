/// @arg x
/// @arg y
/// @arg w
/// @arg h
shader_set(shClip);

shader_set_uniform_f(_Clip, argument0, argument1, argument0 + argument2, argument1 + argument3);
// Place this arguments in variables and 
// Set var = -1, in uiClipEnd
// In matrix_rect check if point inside of 
// Scissor rectangle, otherwise return false
// Also don't forget to make sure that variable 
// Is not equal to -1!

SV_ClipRectangle = [argument0, argument1, argument0 + argument2, argument1 + argument3];
