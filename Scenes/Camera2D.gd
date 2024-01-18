extends Camera2D

@onready var landing_zone = %LandingZone
@onready var camera_2d = %Camera2D

var tile_map: TileMapResource

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_map = landing_zone.get_node('TileMap')
	var tile_map_rect = tile_map.get_used_rect()
	
	# Set camera limits
	camera_2d.limit_left = tile_map_rect.position.x * tile_map.tile_size.x
	camera_2d.limit_right = tile_map_rect.end.x * tile_map.tile_size.x
	camera_2d.limit_top = tile_map_rect.position.y * tile_map.tile_size.y
	camera_2d.limit_bottom = tile_map_rect.end.y * tile_map.tile_size.y
