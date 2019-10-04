///@desc Draw scene

gpu_set_state(State3D);
View = matrix_build_lookat(pX,pY,pZ,pX+dcos(aX)*dcos(aY),pY+dsin(aX)*dcos(aY),pZ+dsin(aY),0,0,1);
camera_set_view_mat(view_camera[0],View);

shader_set(shd_test);
vertex_submit(mTest,pr_trianglelist,-1);
shader_reset();