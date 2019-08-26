/// @description
//Draw the level
shader_set(sh_world);
vbuff_draw(modLevel, sprite_get_texture(texDemoLevel, 0));
shader_reset();

//Draw sky
gpu_set_cullmode(cull_noculling);
matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, 10000, 10000, 10000));
vbuff_draw(modSphere, sprite_get_texture(texSky, 0));
matrix_set(matrix_world, matrix_build_identity());