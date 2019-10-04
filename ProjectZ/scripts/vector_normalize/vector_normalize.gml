///@desc vector_normalize
///@arg v

var vV;
vV = argument[0];

var vL;
vL = sqrt(sqr(vV[0])+sqr(vV[1])+sqr(vV[2]));

return [vV[0]/vL,vV[1]/vL,vV[2]/vL];