extends StaticBody2D

@onready var flame_die_timer = $flame_die_timer
@onready var tile_map = $"../TileMap"

var tile_coords: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	$flame_die_timer.start()
	
	tile_coords = tile_map.get_tile_from_vector(position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_flame_die_timer_timeout():
	tile_map.convert_tile_to_charred(tile_coords)
	queue_free()
