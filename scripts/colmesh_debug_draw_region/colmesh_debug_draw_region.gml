/// @description smf_colmesh_debug_draw_region(colmesh, region, skipBleed)
/// @param colmesh
/// @param region
/// @param skipBleed
/*
Draws all triangles in the currently active region

Script made by TheSnidr
www.TheSnidr.com
*/
var colmesh, region, skipBleed, triList, format, vBuff, i, tri, col, alpha, n, triInd;
	
colmesh = argument0;
region = argument1;
skipBleed = argument2;

if region <= 0{exit;}

triList = colmesh[| eColMesh.TriangleList];

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_color();
vertex_format_add_texcoord();
var format = vertex_format_end();

var vBuff = vertex_create_buffer();
vertex_begin(vBuff, format);
n = ds_list_size(region);
for (i = 0; i < n; i ++)
{
	triInd = region[| i];
	if (skipBleed && triInd < 0){continue;}
	tri = triList[| abs(triInd)];
	alpha = 1 - (triInd < 0) * .5;
	col = make_color_hsv((abs(triInd) * 10) mod 255, 255, 255 * alpha);
	
	vertex_position_3d(vBuff, tri[0] + tri[9]*.5, tri[1] + tri[10]*.5, tri[2] + tri[11]*.5);
	vertex_normal(vBuff, 0, 0, 1);
	vertex_color(vBuff, col, alpha);
	vertex_texcoord(vBuff, 0, 0);
	
	vertex_position_3d(vBuff, tri[3] + tri[9]*.5, tri[4] + tri[10]*.5, tri[5] + tri[11]*.5);
	vertex_normal(vBuff, 0, 0, 1);
	vertex_color(vBuff, col, alpha);
	vertex_texcoord(vBuff, 0, 0);
	
	vertex_position_3d(vBuff, tri[6] + tri[9]*.5, tri[7] + tri[10]*.5, tri[8] + tri[11]*.5);
	vertex_normal(vBuff, 0, 0, 1);
	vertex_color(vBuff, col, alpha);
	vertex_texcoord(vBuff, 0, 0);
}
vertex_end(vBuff);
vertex_submit(vBuff, pr_trianglelist, -1);
vertex_delete_buffer(vBuff);
vertex_format_delete(format);