/// @description mbuff_load_obj(fname)
/// @param fname
/*
	Loads an OBJ file and returns an array of buffers.
	
	Script created by TheSnidr, 2019
	www.thesnidr.com
*/
var fname = argument0;

var model = mbuff_load_obj_ext(fname);
var mBuff = model[0];
var mtlPath = model[1];
var mtlNames = model[2];

return mBuff;