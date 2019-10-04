///@desc height()
///@arg x
///@arg y
/*
	Just a simple heightmap function for fun.
*/
var aX,aY;
aX = argument[0];
aY = argument[1];

var vH;
vH = 40*dcos(.3*aX+.5*aY)*dsin(.6*aX-.2*aY)*dcos(.02*aX+.03*aY)*cos(6*dsin(.1*aX-.1*aY)+8*dsin(.2*aX-.1*aY))+
	 20*dcos(.8*aX+.9*aY)*dsin(.7*aY-1.*aX)*dcos(.85*aX+.72*aY)*cos(6*dsin(.3*aX-.4*aY)+8*dsin(.4*aX+.2*aY))+
	 10*dcos(2.*aX+2.*aY)*dsin(1.*aX-3.*aY)*dcos(3.8*aX+5.3*aY)*cos(6*dsin(.2*aY-.3*aX)+8*dsin(.9*aX-.6*aY));
vH += (aX*aX+aY*aY)/2000;
return vH;