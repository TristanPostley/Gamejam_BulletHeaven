extends StaticBody2D

var landing_zone: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	landing_zone = get_parent()
	var tile_map: TileMap = landing_zone.get_node("TileMap")
	
	# Ground layer
	var tile_map_layer = 0
	
	# todo - Get cell locations programmatically/randomly
	var tile_map_coords = Vector2i(4,4) 
	
	# todo - Get Mycelium tile_id programmatically
	var tile_id = 3
	
	# todo - If -1, -1 (default), will delete the cell.
	var tile_map_atlas_coords = Vector2i(0,0) 
	
	tile_map.set_cell(tile_map_layer, tile_map_coords, tile_id, tile_map_atlas_coords)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _ready():
	#animated_sprite_2d.play("default")
	#player = get_parent().get_node("Player")
	#
	## Starting position of the enemy
	#position = player.position + Vector2(700, 0).rotated(randf_range(0, 2*PI))
