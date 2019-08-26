/// @description

//Initialize Snidr's model buffer system
mbuff_init();

//Initialize Snidr's 3D collision mesh system
colmesh_init();

game_set_speed(100, gamespeed_fps)

//Load models
globalvar mbuffLevel, modLevel, modSphere;
mbuffLevel = mbuff_load_obj("TestWorld.obj"); //Load the level as a buffer rather than as a vertex buffer so that we can create a collision mesh from it
modLevel = vbuff_create_from_mbuff(mbuffLevel); //Create a vertex buffer from the level buffer
modSphere = vbuff_load_obj("Geosphere.obj"); //Load the level as a buffer rather than as a vertex buffer so that we can create a collision mesh from it

//Create collision mesh from level model
var mBuff = mbuffLevel; //<-- You need to supply a regular buffer
var bytes = mBuffStaticBytesPerVert; //<-- You need to know the number of bytes per vertex of your vertex format
var type = eColMeshSubdiv.SpatialHash; //<-- You need to define the type of subdivision for the collision mesh. There are a number to choose between, look at smf_colmesh_init for more info!
var regionSize = 120; //<-- You need to define the size of the subdivision regions. Play around with it and see what value fits your model best. This is a list that stores all the triangles in a region in space. A larger value makes colmesh generation faster, but slows down collision detection. A too low value increases memory usage and generation time.
var bleed = 20; //<-- The bleedover value. This defines how far outside a region a triangle can be, and still be included in the region. Typically, this should be the same as the radius of the largest unit that will perform collision checks on this colmesh.

globalvar levelColmesh;
levelColmesh = colmesh_create(mBuff, bytes, type, regionSize, bleed);

//Clean up
mbuff_delete(mBuff);

//Create necessary objects
instance_create_depth(0, 0, -10, o_colmesh_player);