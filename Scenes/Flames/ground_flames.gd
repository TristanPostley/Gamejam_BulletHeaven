extends StaticBody2D

signal flame_spread_attempted(tile: Vector2i)
signal flame_extinguished(tile: Vector2i)

var tile_coords: Vector2i

func set_variables(coords):
	tile_coords = coords

func _on_flame_die_timer_timeout():
	flame_extinguished.emit(tile_coords)
	queue_free()

func _on_spread_timer_timeout():
	flame_spread_attempted.emit(tile_coords)
