extends StaticBody2D

@onready var flame_die_timer = $flame_die_timer
@onready var tile_map = $"../TileMap"

@export var random_spread_delay = .75

var tile_coords: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_coords = tile_map.get_tile_from_vector(position)

func _on_flame_die_timer_timeout():
	tile_map.extinguish_flame(tile_coords)
	queue_free()

func spread_flame(tile):
	await get_tree().create_timer(randf_range(0, random_spread_delay)).timeout
	if tile_map.is_burnable_tile(tile):
		tile_map.start_flame(tile)

func _on_spread_above_timer_timeout():
	spread_flame(tile_map.get_neighbor_cell(tile_coords, TileSet.CELL_NEIGHBOR_TOP_SIDE))

func _on_spread_below_timer_timeout():
	spread_flame(tile_map.get_neighbor_cell(tile_coords, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE))

func _on_spread_left_timer_timeout():
	spread_flame(tile_map.get_neighbor_cell(tile_coords, TileSet.CELL_NEIGHBOR_LEFT_SIDE))

func _on_spread_right_timer_timeout():
	spread_flame(tile_map.get_neighbor_cell(tile_coords, TileSet.CELL_NEIGHBOR_RIGHT_SIDE))
