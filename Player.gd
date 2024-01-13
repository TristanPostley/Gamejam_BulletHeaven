extends Node2D
func _physics_process(delta): position += Vector2(int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A)), int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W))) * $AnimatedSprite2D.speed_scale
func shoot(): add_child(load("res://Bullet.tscn").instantiate())
func spawn(): get_parent().add_child(load("res://Enemy.tscn").instantiate())
func enemyContact(enemyHitbox): get_tree().reload_current_scene() #$DeathAnimationPlayer.play("Death")


#extends CharacterBody2D
#
#@export var speed = 400
#
#func get_input():
	#var input_direction = Input.get_vector("left", "right", "up", "down")
	#velocity = input_direction * speed
#
#func _physics_process(delta):
	#get_input()
	#move_and_slide()
