extends TileMap
class_name TileMapResource

var tile_size: Vector2i

func _ready():
	tile_size = tile_set.tile_size

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
	
func convert_cell(tile_id: int, coords: Vector2i):
	# Ground layer
	var tile_map_layer = 0
	
	# todo - If -1, -1 (default), will delete the cell. Get programmatically?
	var tile_map_atlas_coords = Vector2i(0,0)
	
	set_cell(tile_map_layer, coords, tile_id, tile_map_atlas_coords)

# Converts a specific tile on the ground layer of a TileMap to mycelium
func convert_tile_to_mycelium(coords: Vector2i):
	convert_cell(3, coords)

# Converts a specific tile on the ground layer of a TileMap to mycelium
func convert_tile_to_charred(coords: Vector2i):
	# todo - Get charred tile_id programmatically
	convert_cell(4, coords)

func get_ground_type(coords: Vector2i):
	var data = get_cell_tile_data(0, coords)
	if data:
		return data.get_custom_data("ground_type")
	else:
		return ""

# Converts a 2D vector representing a position in world space to tile coordinates.
func get_tile_from_vector(vector: Vector2):
	return Vector2i(vector.x / tile_size.x, vector.y / tile_size.y)

# Converts a 2D vector representing a position in world space to tile coordinates.
func get_vector_from_tile(vector2i: Vector2i):
	return Vector2i(vector2i.x * tile_size.x, vector2i.y * tile_size.y)
