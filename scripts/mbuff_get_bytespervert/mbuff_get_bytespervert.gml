/// @description mbuff_get_bytespervert(mBuff)
/// @param mBuff
/*
Returns number of bytes per vert for the given model buffer

If the buffer does not contain metadata, -1 is returned
*/
var mBuff = argument0;
if is_array(mBuff){mBuff = mBuff[0];}
if (!mbuff_get_metadata(mBuff))
{
	show_debug_message("ERROR in mbuff_get_bytespervert: The given model buffer does not contain metadata");
	return -1;
}
var bytesPerVert = buffer_peek(mBuff, 4 * 4 + 1, buffer_u8);

return bytesPerVert;