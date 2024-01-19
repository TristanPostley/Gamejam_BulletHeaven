extends Node2D

@onready var landing_zone = %LandingZone
var tile_map: TileMapResource

@export var random_spread_delay = .75

const GROUND_FLAMES = preload("res://Scenes/Flames/ground_flames.tscn")

var active_flames : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_map = landing_zone.get_node('TileMap')
	
	# todo Spawn a flame for testing. Remove in production.
	start_flame(Vector2i(45, 51))

func start_flame(coords: Vector2i):
	if is_burnable_tile(coords) != true:
		return
	
	active_flames[coords] = true
	var new_flame = GROUND_FLAMES.instantiate()
	new_flame.set_variables(coords)
	new_flame.position = tile_map.get_vector_from_tile(coords)
	
	# Connect signals
	new_flame.flame_spread_attempted.connect(_on_flame_spread_attempted)
	new_flame.flame_extinguished.connect(_on_flame_extinguished)
	
	tile_map.get_parent().add_child(new_flame)
	
func is_burnable_tile(coords: Vector2i):
	return tile_map.get_ground_type(coords) == "mycelium" && is_tile_burning(coords) == false

func is_tile_burning(coords: Vector2i):
	if active_flames.has(coords):
		return active_flames[coords]
	
	return false

func extinguish_flame(coords: Vector2i):
	active_flames[coords] = false
	tile_map.convert_tile_to_charred(coords)

func _on_flame_spread_attempted(tile: Vector2i):
	var surrounding_tiles = tile_map.get_surrounding_cells(tile)
	
	for surrounding_tile in surrounding_tiles:
		# Callback after the timer completes
		var spread_to_tile = func(): start_flame(surrounding_tile)
		
		# Async timer that will emit a signal on callback
		get_tree().create_timer(randf_range(0, random_spread_delay)).timeout.connect(spread_to_tile)

func _on_flame_extinguished(tile: Vector2i):
	extinguish_flame(tile)
