extends Area2D

class_name ItemPickup

const PICKUP_BEAM: PackedScene = preload("res://Scenes/Pickups/pickup_beam.tscn")
const PICKUP_FLAMETHROWER: PackedScene = preload("res://Scenes/Pickups/pickup_flamethrower.tscn")
const PICKUP_HEALTH: PackedScene = preload("res://Scenes/Pickups/pickup_health.tscn")
const PICKUP_LEAFBLOWER: PackedScene = preload("res://Scenes/Pickups/pickup_leafblower.tscn")
const PICKUP_MACHETE: PackedScene = preload("res://Scenes/Pickups/pickup_machete.tscn")

signal item_pickup_body_entered(pickup_name: String)

@export var item_scene: PackedScene
var item: BasePickup

func _ready():
	if item_scene == null:
		item_scene = get_random_item()
	
	item = item_scene.instantiate()
	add_child(item)
	
func get_random_item() -> PackedScene:
	var item_scenes = [PICKUP_BEAM, PICKUP_FLAMETHROWER, PICKUP_HEALTH, PICKUP_LEAFBLOWER, PICKUP_MACHETE]
	item_scenes.shuffle()
	
	return item_scenes[0]

# todo Should handle pickups with signals??
func _on_body_entered(body):
	if body.name != "Player":
		return

	body._on_item_pickup_body_entered(item.pickup_name)
	queue_free()
