extends Node2D
class_name BasePickup

var pickup_name : String

# Item movement
var launch_velocity: Vector2 = Vector2.ZERO
var move_duration: float = 0
var time_since_launch: float = 0
var launching: bool = false :
	set(is_launching):
		launching = is_launching

func _process_base_pickup(delta):
	if launching:
		position += launch_velocity * delta
		time_since_launch += delta
		
		if time_since_launch >= move_duration:
			launching = false

func launch(velocity: Vector2, duration: float):
	launch_velocity = velocity
	move_duration = duration
	time_since_launch = 0
	launching = true

# todo Should be emitted with signals?
func _on_base_pickup_body_entered(body):
	if body.name != "Player":
		return
	
	body._on_item_pickup_body_entered(pickup_name)
	queue_free()
