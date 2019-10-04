///@desc collider_begin
///@arg cells
///@arg cell_x1
///@arg cell_y1
///@arg cell_x2
///@arg cell_y2

var vCollider;
vCollider = [ds_grid_create(argument[0],argument[0]),argument[0],argument[1],argument[2],argument[3],argument[4]];

for( var lX = 0; lX<vCollider[1]; lX++)
for( var lY = 0; lY<vCollider[1]; lY++)
{
	ds_grid_add( vCollider[0], lX, lY, ds_list_create());
}

return vCollider;