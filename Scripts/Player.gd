extends CharacterBody2D

@export var speed = 200
@export var friction = 0.1
@export var acceleration = 0.2

var flamethrowerSelected = true

var flamethrowing = false
@export var flameSpeed = 2

# Intro signals
@onready var start_area = $"../StartArea"
@onready var intro_area_1 = $"../IntroArea1"

# Key Prompts
var overhead_marker

const INTRO_PROMPTS = preload("res://Scenes/Key Prompts/intro_prompts.tscn")
var prompt

func _ready():
	overhead_marker = $OverheadMarker
	prompt = INTRO_PROMPTS.instantiate()
	prompt.position = overhead_marker.position
	add_child(prompt)

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

#Intro signals
func _on_start_area_body_entered(body):
	if body.name != "Player":
		return
	
	for node in get_tree().get_nodes_in_group("Intro"):
		node.queue_free()
	%Camera2D.zoom(%Camera2D.zoom_levels[3])

func _on_intro_area_1_body_entered(body):
	if body.name != "Player":
		return
	
	start_area.queue_free()
	intro_area_1.queue_free()
	if prompt != null: remove_child(prompt)
	%Camera2D.zoom(%Camera2D.zoom_levels[1])
