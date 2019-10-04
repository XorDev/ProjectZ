///@desc collider_delete
///@arg collider

var vCollider;
vCollider = argument[0];

for( var lX = 0; lX<vCollider[1]; lX++)
for( var lY = 0; lY<vCollider[1]; lY++)
{
	ds_list_destroy( ds_grid_get(vCollider[0], lX, lY));
}
ds_grid_destroy(vCollider[0]);