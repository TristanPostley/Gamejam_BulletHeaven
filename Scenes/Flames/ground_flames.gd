extends StaticBody2D

@onready var tile_map = $"../TileMap"

@export var random_spread_delay = .75

signal flame_spread_attempted(tile: Vector2i)
signal flame_extinguished(tile: Vector2i)

var tile_coords: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_coords = tile_map.get_tile_from_vector(position)

func _on_flame_die_timer_timeout():
	flame_extinguished.emit(tile_coords)
	queue_free()

func _on_spread_timer_timeout():
	var surrounding_cells = tile_map.get_surrounding_cells(tile_coords)
	
	for tile in surrounding_cells:
		# Callback after the timer completes
		var spread_to_tile = func(): flame_spread_attempted.emit(tile)
		
		# Async timer that will emit a signal on callback
		get_tree().create_timer(randf_range(0, random_spread_delay)).timeout.connect(spread_to_tile)
