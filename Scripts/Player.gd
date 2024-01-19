extends CharacterBody2D

@export var speed = 200
@export var friction = 0.1
@export var acceleration = 0.2

var flamethrowerSelected = true

var flamethrowing = false
@export var flameSpeed = 2

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
#Actions
	if Input.is_action_just_pressed('primary'):
		if !flamethrowing && flamethrowerSelected:
			$Weapons/Hurtbox/FlamethrowerCone.disabled = false
			$Weapons/Hurtbox/FlamethrowerParticles.emitting = true
			flamethrowing = true
			
	if(flamethrowing):
		$Weapons/Hurtbox/FlamethrowerCone.scale = $Weapons/Hurtbox/FlamethrowerCone.scale.lerp(Vector2(1,1), delta * flameSpeed)
		
	if(!flamethrowerSelected || flamethrowing && !Input.is_action_pressed('primary')):
		flamethrowing = false
		$Weapons/Hurtbox/FlamethrowerParticles.emitting = false
		$Weapons/Hurtbox/FlamethrowerCone.scale = Vector2.ZERO
		$Weapons/Hurtbox/FlamethrowerCone.disabled = true
		
	
	if Input.is_action_just_pressed("secondary"):
		$Weapons/Hurtbox/MacheteBox.disabled = false
		await get_tree().create_timer(.5).timeout
		$Weapons/Hurtbox/MacheteBox.disabled = true		

#Facing (for sprite, weapon aiming handled in Weapons Node)
	if(get_global_mouse_position().x < get_global_transform()[2].x):
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
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

