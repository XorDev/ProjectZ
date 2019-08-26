/// @description mbuff_delete(mBuff)
/// @param mBuff
/*
	Deletes an mbuff
	
	Script created by TheSnidr, 2019
	www.thesnidr.com
*/
var mBuff = argument0;
if is_array(mBuff)
{
	var n = array_length_1d(mBuff);
	for (var i = 0; i < n; i ++)
	{
		buffer_delete(mBuff[i]);
	}
}
else
{
	buffer_delete(mBuff);
}