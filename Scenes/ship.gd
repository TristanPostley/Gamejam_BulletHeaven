extends StaticBody2D

# How many safe tiles are present between the ship and the starting mycelium tiles
@export var mycelium_spawn_buffer: int = 10

# How many mycelium tiles are created on load
@export var mycelium_spawn_count: int = 1000

var landing_zone: Node2D
var tile_map: TileMap
var tile_size: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get references to parent node and TileMap
	landing_zone = get_parent()
	tile_map = landing_zone.get_node("TileMap")
	tile_size = tile_map.tile_set.tile_size
	
	# Initialize the starting mycelium conversion
	convert_starting_mycelium()

# Generates of mycelium tiles around the ship's position
func convert_starting_mycelium():
	# Get the tile coordinates of the ship's position
	var ship_tile: Vector2i = get_tile_from_vector(position)
	
	# Calculate the boundaries for mycelium spawning
	var spawn_left = ship_tile.x - mycelium_spawn_buffer
	var spawn_right = ship_tile.x + mycelium_spawn_buffer
	var spawn_top = ship_tile.y - mycelium_spawn_buffer
	var spawn_bottom = ship_tile.y + mycelium_spawn_buffer
	
	# Loop to spawn mycelium tiles within the specified boundaries
	# todo, imperfect algorithm. Leaves an empty square around ship
	# todo, does not account for existing mycelium, or skipped tiles
	# todo, does not account for ship size, only ship start location
	for n in mycelium_spawn_count:
		var rand_tile = get_random_tile()
		
		# Skip tiles that are too close to the ship
		if rand_tile.x > spawn_left && rand_tile.x < spawn_right:
			if rand_tile.y > spawn_top && rand_tile.y < spawn_bottom:
				continue
		
		convert_tile_to_mycelium(rand_tile)

# Converts a specific tile on the ground layer of a TileMap to mycelium
func convert_tile_to_mycelium(tile_map_coords: Vector2i):
	# Ground layer
	var tile_map_layer = 0
	
	# todo - Get Mycelium tile_id programmatically
	var tile_id = 3
	
	# todo - If -1, -1 (default), will delete the cell.
	var tile_map_atlas_coords = Vector2i(0,0)
	
	tile_map.set_cell(tile_map_layer, tile_map_coords, tile_id, tile_map_atlas_coords)

# Generates random tile coordinates within the bounds of the currently used area of the TileMap.
func get_random_tile():
	var tile_map_rect: Rect2i = tile_map.get_used_rect()
	
	var x_from = tile_map_rect.position.x
	var x_to = tile_map_rect.position.x + tile_map_rect.size.x - 1
	var rand_x = randi_range(x_from, x_to)
	
	var y_from = tile_map_rect.position.y
	var y_to = tile_map_rect.position.y + tile_map_rect.size.y - 1
	var rand_y = randi_range(y_from, y_to)
	
	return Vector2i(rand_x, rand_y)

# Converts a 2D vector representing a position in world space to tile coordinates.
func get_tile_from_vector(vector: Vector2):
	return Vector2i(vector.x / tile_size.x, vector.y / tile_size.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
