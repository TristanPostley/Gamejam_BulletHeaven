extends TileMap

var tile_size: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_size = tile_set.tile_size
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

# Generates random tile coordinates within the bounds of the currently used area of the TileMap.
func get_random_tile():
	var tile_map_rect: Rect2i = get_used_rect()
	
	var x_from = tile_map_rect.position.x
	var x_to = tile_map_rect.position.x + tile_map_rect.size.x - 1
	var rand_x = randi_range(x_from, x_to)
	
	var y_from = tile_map_rect.position.y
	var y_to = tile_map_rect.position.y + tile_map_rect.size.y - 1
	var rand_y = randi_range(y_from, y_to)
	
	return Vector2i(rand_x, rand_y)
	
func convert_cell(tile_id: int, tile_map_coords: Vector2i):
	# Ground layer
	var tile_map_layer = 0
	
	# todo - If -1, -1 (default), will delete the cell. Get programmatically?
	var tile_map_atlas_coords = Vector2i(0,0)
	
	set_cell(tile_map_layer, tile_map_coords, tile_id, tile_map_atlas_coords)

# Converts a specific tile on the ground layer of a TileMap to mycelium
func convert_tile_to_mycelium(tile_map_coords: Vector2i):
	convert_cell(3, tile_map_coords)

# Converts a specific tile on the ground layer of a TileMap to mycelium
func convert_tile_to_charred(tile_map_coords: Vector2i):
	# todo - Get charred tile_id programmatically
	convert_cell(4, tile_map_coords)

# Converts a 2D vector representing a position in world space to tile coordinates.
func get_tile_from_vector(vector: Vector2):
	return Vector2i(vector.x / tile_size.x, vector.y / tile_size.y)
