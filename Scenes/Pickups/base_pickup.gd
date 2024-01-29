extends Area2D
class_name BasePickup

@onready var collision_shape: CollisionShape2D = %CollisionShape2D
@export var pickup_name : String:
	set(value):
		pickup_name = value
		# update_configuration_warnings()

# Item movement
var launch_velocity: Vector2 = Vector2.ZERO
var move_duration: float = 0
var time_since_launch: float = 0
var launching: bool = false :
	set(is_launching):
		launching = is_launching

# Editor warnings - TODO not working
#func _get_configuration_warnings() -> PackedStringArray:
	#var warnings: PackedStringArray = []
	#
	#if pickup_name.is_empty():
		#warnings.append("Property pickup_name can't be empty")
	#
	#return warnings

func _process(delta):
	if launching:
		position += launch_velocity * delta
		time_since_launch += delta
		
		# TODO refactor into launch timer?
		if time_since_launch >= move_duration:
			launching = false
			
			# The item can be picked up
			collision_shape.disabled = false

func launch(velocity: Vector2, duration: float):
	launch_velocity = velocity
	move_duration = duration
	time_since_launch = 0
	launching = true

func _on_body_entered(body):
	if !body.has_method("pickup_item"): return
	
	body.pickup_item(pickup_name)
	queue_free()

func _on_expiration_timer_timeout():
	queue_free()
