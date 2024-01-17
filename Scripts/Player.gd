extends CharacterBody2D

@export var speed = 200
@export var friction = 0.1
@export var acceleration = 0.2

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
		$AnimationPlayer.play("right")
	if Input.is_action_pressed('left'):
		input.x -= 1
		$AnimationPlayer.play("left")		
	if Input.is_action_pressed('down'):
		input.y += 1
		$AnimationPlayer.play("down")		
	if Input.is_action_pressed('up'):
		input.y -= 1
		$AnimationPlayer.play("up")		
	return input

func _physics_process(delta):
	if Input.is_action_pressed('primary'):
		#if $FlamethrowerHurtbox.scale.x <= 1:
			#$FlamethrowerHurtbox.scale += Vector2(.05,.05)
		$AnimationPlayer.play("flamethrow")
	if($FlamethrowerHurtbox/CollisionPolygon2D.scale.x > 0 && !Input.is_action_pressed('primary')):
			#$FlamethrowerHurtbox.scale -= Vector2(.05,.05)		
		$AnimationPlayer.play("unflamethrow")
#Facing (For aiming weapons)
	look_at(get_global_mouse_position())
	
#Movement
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
		if !$AudioStreamPlayer2D.playing : 
			#$AudioStreamPlayer2D.pitch_scale = randf_range(.8, 1.2) Not sure, might be more effective being applied to individual footsteps
			$AudioStreamPlayer2D.play()
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		$AudioStreamPlayer2D.stop()
	move_and_slide()
