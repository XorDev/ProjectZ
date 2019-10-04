///@desc Draw FPS

gpu_set_state(State2D);

draw_text(8,8,"Toggle gravity with 'G'");

var t = (vGravity)?"on":"off";
draw_text(8,24,"Gravity "+t);