/// @description mbuff_get_skinned(mBuff)
/// @param mBuff
/*
	Returns whether or not the given model buffer is skinned.

	If the buffer does not contain metadata, -1 is returned
*/
var mBuff = argument0;
if is_array(mBuff){mBuff = mBuff[0];}

if (!mbuff_get_metadata(mBuff))
{
	return -1;
}
var skinned = buffer_peek(mBuff, 4 * 4, buffer_u8);

return skinned;