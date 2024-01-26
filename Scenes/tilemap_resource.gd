extends TileMap
class_name TileMapResource

const tile_map_layer = 0  # Ground layer
const spawn_factor = 0.0001  # % per tick for mycelium tile to spawn a grunt
const spawn_rate = 1 - spawn_factor  # to avoid doing math each tick

var tile_size: Vector2i
var num_tiles: int

var grunt_scene = load("res://Scenes/myco_grunt.tscn")
var game_started = false

func _ready():
	tile_size = tile_set.tile_size
	num_tiles = sqrt(self.get_used_cells_by_id(tile_map_layer).size())


func _process(_delta):
	if game_started:
		for i in range(num_tiles):
			for j in range(num_tiles):
				var tile_pos = Vector2i(i, j)
				var tile_id = self.get_cell_source_id(tile_map_layer, tile_pos)
				if tile_id == 3:  # Nested, so random number not generated on every tile.
					var spawn_chance = randf()
					if spawn_chance > spawn_rate:
						var new_grunt = grunt_scene.instantiate()
						new_grunt.position = tile_pos * tile_size
						get_tree().get_root().get_node("Level").add_child.call_deferred(new_grunt)
						get_tree().get_root().get_node("Level").CountGruntSpawn()
						# print("New grunt spawned: ", tile_pos, " ", new_grunt.position)

func start_game():
	game_started = true

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
	#print("charred ", coords)

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
