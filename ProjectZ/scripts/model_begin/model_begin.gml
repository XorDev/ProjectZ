///@desc model_begin
/*
	Create a new model (this returns the buffer id). 
*/

var vBuff = vertex_create_buffer();
vertex_begin(vBuff,Format);
return vBuff;