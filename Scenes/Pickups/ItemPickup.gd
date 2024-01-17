extends Area2D

const PICKUP_BEAM = preload("res://Scenes/Pickups/pickup_beam.tscn")
const PICKUP_FLAMETHROWER = preload("res://Scenes/Pickups/pickup_flamethrower.tscn")
const PICKUP_HEALTH = preload("res://Scenes/Pickups/pickup_health.tscn")
const PICKUP_LEAFBLOWER = preload("res://Scenes/Pickups/pickup_leafblower.tscn")
const PICKUP_MACHETE = preload("res://Scenes/Pickups/pickup_machete.tscn")
const PICKUP_OXYGEN = preload("res://Scenes/Pickups/pickup_oxygen.tscn")

func _ready():
	add_child(get_random_item())
	
func get_random_item():
	var item_scenes = [PICKUP_BEAM, PICKUP_FLAMETHROWER, PICKUP_HEALTH, PICKUP_LEAFBLOWER, PICKUP_MACHETE, PICKUP_OXYGEN]
	item_scenes.shuffle()
	
	return item_scenes[0].instantiate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
