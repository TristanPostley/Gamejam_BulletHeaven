extends Node2D

# todo don't hardcode the item drop
const PICKUP_OXYGEN: PackedScene = preload("res://Scenes/Pickups/pickup_oxygen.tscn")

# todo hardcoded to oxygen drops
var launch_speed: float = 200
var launch_duration: float = .5
var drop_count: int = 20

func _ready():
	spawn_items()

# Instantiate instances of the ItemPickup scene and spawn them
func spawn_resource():
	var pickup_instance: BasePickup = PICKUP_OXYGEN.instantiate()
	add_child(pickup_instance)
	pickup_instance.position = position
	
	var direction: Vector2 = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()
	
	pickup_instance.launch(direction * launch_speed, launch_duration)

# Periodically spawn new items
func _on_timer_timeout():
	spawn_items()

func spawn_items():
	for x in drop_count:
		spawn_resource() 
