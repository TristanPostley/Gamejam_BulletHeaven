extends Camera2D

@onready var landing_zone = %LandingZone
@onready var camera_2d = %Camera2D

# Arbitrarily picked zoom levels, close to far
@export var zoom_levels: PackedFloat32Array = [1, .75, .5, .3]

var tile_map: TileMapResource
var current_zoom = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_map = landing_zone.get_node('TileMap')
	var tile_map_rect = tile_map.get_used_rect()
	
	# Set camera limits
	camera_2d.limit_left = tile_map_rect.position.x * tile_map.tile_size.x
	camera_2d.limit_right = tile_map_rect.end.x * tile_map.tile_size.x
	camera_2d.limit_top = tile_map_rect.position.y * tile_map.tile_size.y
	camera_2d.limit_bottom = tile_map_rect.end.y * tile_map.tile_size.y


func _process(_delta):
	pass


func zoom(zoom_level: float):
	set_zoom(Vector2(zoom_level, zoom_level))

