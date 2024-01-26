extends Node2D

@export var pickup: PackedScene
@export var launch_speed: float = 200
@export var launch_duration: float = 1
@export var drop_count: int = 1

func spawn_resource(direction = null):
	var pickup_instance: BasePickup = pickup.instantiate()
	pickup_instance.position = position
	call_deferred("add_child", pickup_instance)
	
	# The direction is random by default, but is overridden by param
	var _direction: Vector2
	if direction != null:
		_direction = direction
	else:
		_direction = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		).normalized()

	pickup_instance.launch(_direction * launch_speed, launch_duration)

func spawn_items():
	for x in drop_count:
		spawn_resource()
