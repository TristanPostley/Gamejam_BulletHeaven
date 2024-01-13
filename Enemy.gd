extends CharacterBody2D
#func _ready(): position = get_parent().get_node("Player").position + Vector2(1000, 0).rotated(randf_range(0, 2*PI))
#set_velocity((get_parent().get_node("Player").position - position).normalized() * $AnimatedSprite2D.speed_scale / delta)
#move_and_slide()
#func _physics_process(delta): velocity

#extends KinematicBody2D

var speed: float = 200  # Adjust the speed as needed
var player: Node2D

func _ready():
	# Assume the player is a child node named "Player"
	# player = get_node("/root/Node2D/Player")
	player = get_parent().get_node("Player")

func _process(delta: float):
	# Move the enemy towards the player
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
