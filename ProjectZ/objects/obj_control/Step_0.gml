///@desc Handle interactive

vGravity = keyboard_check_released(ord("G")) ? !vGravity : vGravity;

var vW,vH;
vW = window_get_width()/2; vH = window_get_height()/2;
window_mouse_set(vW,vH);

aX = (aX+(window_mouse_get_x()-vW)/8 + 360) % 360;
aY = clamp(aY+(window_mouse_get_y()-vH)/8,-89,89);

var kX,kY,kZ,kS,kJ;
kX = keyboard_check(ord("D"))-keyboard_check(ord("A"));
kY = keyboard_check(ord("W"))-keyboard_check(ord("S"));
kZ = keyboard_check(ord("Q"))-keyboard_check(ord("E"));
kS = keyboard_check(vk_shift)*4+1;
kJ = keyboard_check(vk_space);


var vP;
vP = vZ;
vX = vX*.8+.2*(dcos(aX)*kY-dsin(aX)*kX)*kS;
vY = vY*.8+.2*(dsin(aX)*kY+dcos(aX)*kX)*kS;
vZ = vZ*.8+.2*kZ*kS;


var C = collider_move(cTest,[pX,pY,pZ],[vX,vY,vZ],4);
vZ += (vZ>C[2]) ? .01*vGravity-4*kJ : vZ*.2+.2*vGravity;
pX += C[0]; pY += C[1]; pZ += C[2];