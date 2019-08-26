/// @description mbuff_get_metadata(mBuff)
/// @param mBuff
/*
	Returns whether or not the given model contains metadata
*/
var mBuff = argument0;
if is_array(mBuff){mBuff = mBuff[0];}

if (buffer_peek(mBuff, 3 * 4, buffer_u32) == mBuffMetaDataID)
{
	return true;
}
return false;