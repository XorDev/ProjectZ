/// @description mbuff_save(mbuff, fname)
/// @param mbuff
/// @param fname
/*
	Saves the given model buffer to the given filename

	Script created by TheSnidr
	www.thesnidr.com
*/
var fname, mBuff, modelNum, saveBuff, i, buffSize;
var fname = argument0;
var mBuff = argument1;
modelNum = array_length_1d(mBuff);

saveBuff = buffer_create(1, buffer_grow, 1);

mbuff_write_to_buffer(saveBuff, mBuff);

buffer_resize(saveBuff, buffer_tell(saveBuff));
buffer_save(saveBuff, fname);
buffer_delete(saveBuff);