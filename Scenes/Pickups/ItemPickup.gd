extends Area2D

const PICKUP_BEAM = preload("res://Scenes/Pickups/pickup_beam.tscn")
const PICKUP_FLAMETHROWER = preload("res://Scenes/Pickups/pickup_flamethrower.tscn")
const PICKUP_HEALTH = preload("res://Scenes/Pickups/pickup_health.tscn")
const PICKUP_LEAFBLOWER = preload("res://Scenes/Pickups/pickup_leafblower.tscn")
const PICKUP_MACHETE = preload("res://Scenes/Pickups/pickup_machete.tscn")
const PICKUP_OXYGEN = preload("res://Scenes/Pickups/pickup_oxygen.tscn")

signal item_pickup_body_entered(body: Node2D, pickup_name: String)

var item

func _ready():
	item = get_random_item()
	add_child(item)
	
	body_entered.connect(_emit_item_pickup_body_entered)
	
func get_random_item():
	var item_scenes = [PICKUP_BEAM, PICKUP_FLAMETHROWER, PICKUP_HEALTH, PICKUP_LEAFBLOWER, PICKUP_MACHETE, PICKUP_OXYGEN]
	item_scenes.shuffle()
	
	return item_scenes[0].instantiate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _emit_item_pickup_body_entered(body: Node2D):
	item_pickup_body_entered.emit(body, item.pickup_name)
	queue_free()
