/// @description mbuff_load_obj_ext(fname)
/// @param fname
/*
	Loads an OBJ file and returns an array containing the following:
	[mBuff, mtlFname, mtlNameList]

	mBuff is an array containing model buffers
	mtlFname is the filename of the mtl file
	mtlNameList is an array containing the name of the material for each entry in the mBuff array
	
	Script created by TheSnidr, 2019
	www.thesnidr.com
*/
var fname = argument0;
var file = file_text_open_read(fname);
if file < 0
{
	show_debug_message("ERROR in script smf_mbuff_load_obj: Failed to load model " + string(fname)); 
	return -1;
}
show_debug_message("Script smf_mbuff_load_obj: Loading obj file " + string(fname));

var currentMaterial = "Default";
var materialList = ds_list_create();
var mtlFname = "";

//Create the necessary lists
var V, N, T, Fa, F, m, ind;
var V = ds_list_create();
var N = ds_list_create();
var T = ds_list_create();
Fa[0] = ds_list_create();

//Read .obj as textfile
var str;
while !file_text_eof(file)
{
	str = string_replace_all(file_text_read_string(file),"  "," ");
	//Different types of information in the .obj starts with different headers
	switch string_copy(str, 1, string_pos(" ", str)-1)
	{
		//Load name of MTL library
		case "mtllib":
			mtlFname = string_delete(str, 1, string_pos(" ", str));
			mtlFname = filename_name(mtlFname);
			while string_count(".", mtlFname){
				mtlFname = filename_change_ext(mtlFname, "");}
			mtlFname += ".mtl";
			break;
		//Load vertex positions
		case "v":
			ds_list_add(V, _mbuff_read_obj_line(str));
			break;
		//Load vertex normals
		case "vn":
			ds_list_add(N, _mbuff_read_obj_line(str));
			break;
		//Load vertex texture coordinates
		case "vt":
			ds_list_add(T, _mbuff_read_obj_line(str));
			break;
		//Load material name
		case "usemtl":
			currentMaterial = string_delete(str, 1, string_pos(" ", str));
			if ds_list_find_index(materialList, currentMaterial) == -1{
				ds_list_add(materialList, currentMaterial);
				ind = ds_list_find_index(materialList, currentMaterial);
				Fa[ind] = ds_list_create();}
			break;
		//Load faces
		case "f":
			m = max(ds_list_find_index(materialList, currentMaterial), 0);
			_mbuff_read_obj_face(Fa[m], str);
			break;
	}
	file_text_readln(file);
}
file_text_close(file);

//Loop through the loaded information and generate a model
var bytesPerVert, modelNum, vnt, vertNum, mBuff, v, n, t;
bytesPerVert = mBuffStaticBytesPerVert;
modelNum = array_length_1d(Fa);
mBuff = array_create(modelNum);
for (var m = 0; m < modelNum; m ++)
{
	F = Fa[m];
	vertNum = ds_list_size(F);
	mBuff[m] = buffer_create(vertNum * bytesPerVert, buffer_fixed, 1);
	repeat 3
	{
		buffer_write(mBuff[m], buffer_f32, 0); //x, must be 0
		buffer_write(mBuff[m], buffer_f32, 0); //y, must be 0
		buffer_write(mBuff[m], buffer_f32, 0); //z, must be 0

		//The rest of these can store metadata
		buffer_write(mBuff[m], buffer_f32, 0);
		buffer_write(mBuff[m], buffer_f32, 0);
		buffer_write(mBuff[m], buffer_f32, 0);

		buffer_write(mBuff[m], buffer_f32, 0);
		buffer_write(mBuff[m], buffer_f32, 0);
		buffer_write(mBuff[m], buffer_u32, 0);
	}
	for (var f = 0; f < vertNum; f ++)
	{
		vnt = F[| f];
		
		//Add the vertex to the model buffer
		v = V[| vnt[0]];
		if !is_array(v){v = [0, 0, 0];}
		buffer_write(mBuff[m], buffer_f32, v[0]);
		buffer_write(mBuff[m], buffer_f32, v[2]);
		buffer_write(mBuff[m], buffer_f32, v[1]);
		
		//Vertex normal
		n = N[| vnt[1]];
		if !is_array(n){n = [0, 0, 1];}
		buffer_write(mBuff[m], buffer_f32, n[0]);
		buffer_write(mBuff[m], buffer_f32, n[2]);
		buffer_write(mBuff[m], buffer_f32, n[1]);
		
		//Vertex UVs
		t = T[| vnt[2]];
		if !is_array(t){t = [0, 0];}
		buffer_write(mBuff[m], buffer_f32, t[0]);
		buffer_write(mBuff[m], buffer_f32, 1-t[1]);
			
		//Either flat normal or tangent
		buffer_write(mBuff[m], buffer_u8, 255);
		buffer_write(mBuff[m], buffer_u8, 255);
		buffer_write(mBuff[m], buffer_u8, 255);
		buffer_write(mBuff[m], buffer_u8, 255);
	}
}

//Copy the contents of the materialList over to an array
n = ds_list_size(materialList);
var mtlNames = array_create(n);
for (var i = 0; i < n; i ++)
{
	mtlNames = materialList[| i];
}

//Write metadata
mbuff_update_metadata(mBuff, false, false);

ds_list_destroy(F);
ds_list_destroy(V);
ds_list_destroy(N);
ds_list_destroy(T);
ds_list_destroy(materialList);
show_debug_message("Script smf_mbuff_load_obj: Successfully loaded obj " + string(fname));

//Return array containing the mBuff array, the name of the mtl file and the names of the materials of the submodels
return [mBuff, mtlFname, mtlNames];