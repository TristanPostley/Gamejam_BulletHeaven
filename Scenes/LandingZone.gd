extends Node2D

@onready var tile_map = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	# todo Spawn a flame for testing. Remove in production.
	tile_map.start_flame(Vector2i(1, 1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
