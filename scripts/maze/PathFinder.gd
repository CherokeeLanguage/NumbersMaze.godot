extends AStar2D

class_name PathFinder

var width:int
var height:int
var cell_size:Vector2

func _init(mapWidth:int, mapHeight:int, cellSize:Vector2) -> void:
	width=mapWidth
	height=mapHeight
	cell_size=cellSize

func _id(x:int, y:int):
	return x + y * width

func add_position(position:Vector2, south:bool, west:bool, north:bool, east:bool)->void:
	var id:int = _id(position.x, position.y)
	add_point(id, position)
	var oid:int
	
	if south and position.y<height-1:
		oid = _id(position.x, position.y+1)
		if has_point(oid):
			connect_points(id, oid, true)
		
	if west and position.x>0:
		oid = _id(position.x-1, position.y)
		if has_point(oid):
			connect_points(id, oid, true)
	
	if north and position.y > 0:
		oid = _id(position.x, position.y-1)
		if has_point(oid):
			connect_points(id, oid, true)
	
	if east and position.x < width -1:
		oid = _id(position.x+1, position.y)
		if has_point(oid):
			connect_points(id, oid, true)
	
func get_path(start:Vector2, end:Vector2)->PoolVector2Array:
	var startId:int = start.y*width+start.x
	var endId:int = end.y*width+end.x
	return get_point_path(startId, endId)
	
func get_world_path(map:TileMap, world_start:Vector2, world_end:Vector2)->PoolVector2Array:
	var points:PoolVector2Array = PoolVector2Array()
	for tile_point in get_path(map.world_to_map(world_start), map.world_to_map(world_end)):
		var way_point:Vector2 = map.map_to_world(tile_point)
		way_point += (cell_size/2) # shift to middle of tile
		points.append(way_point)
	return points
	
