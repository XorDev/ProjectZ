/// @description mbuff_init()
/*
	Initializes snidrs model buffer system.

	Script made by TheSnidr
	www.TheSnidr.com
*/
#macro mBuffMetaDataID 265168121 //Arbitrary four-bit integer

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_colour();
global.mBuffStaticFormat = vertex_format_end();
#macro mBuffStaticValues 12
#macro mBuffStaticBytesPerVert 36

//Create skinned format
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_color();
vertex_format_add_color();
vertex_format_add_color();
global.mBuffSkinnedFormat = vertex_format_end();
#macro mBuffSkinnedValues 20
#macro mBuffSkinnedBytesPerVert 44