extends StaticBody2D

# How many safe tiles are present between the ship and the starting mycelium tiles
@export var mycelium_spawn_buffer: int = 10

# How many mycelium tiles are created on load
@export var mycelium_spawn_count: int = 1000

@onready var tile_map = $"../TileMap"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize the starting mycelium conversion
	convert_starting_mycelium()

# Generates of mycelium tiles around the ship's position
func convert_starting_mycelium():
	# Get the tile coordinates of the ship's position
	var ship_tile: Vector2i = tile_map.get_tile_from_vector(position)
	
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
		var rand_tile = tile_map.get_random_tile()
		
		# Skip tiles that are too close to the ship
		if rand_tile.x > spawn_left && rand_tile.x < spawn_right:
			if rand_tile.y > spawn_top && rand_tile.y < spawn_bottom:
				continue
		
		tile_map.convert_tile_to_mycelium(rand_tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
