extends CharacterBody2D

@export var speed = 200
@export var friction = 0.1
@export var acceleration = 0.2

var shouldPlayFootsteps

@export var flamethrowerAvailable = false
@export var leafblowerAvailable = true

var flamethrowing = false
var blowing = false
var blowerInProgress = false
@export var flameSpeed = 2
@export var blowerSpeed = 4

# Intro signals
@onready var start_area = $"../StartArea"

# Key Prompts
var overhead_marker

# Inventory
var inventory : Dictionary = { "beam": false, "flamethrower": false, "leafblower": false, "machete": false }

const INTRO_PROMPTS = preload("res://Scenes/Key Prompts/intro_prompts.tscn")
var prompt

func _ready():
	overhead_marker = $OverheadMarker
	prompt = INTRO_PROMPTS.instantiate()
	prompt.position = overhead_marker.position
	prompt.wasd_prompts_completed.connect(_on_wasd_prompts_completed)
	add_child(prompt)

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
		#$AnimationPlayer.play("right")
		$AnimatedSprite2D.animation = "right"
		$AnimatedSprite2D.flip_h = false
	if Input.is_action_pressed('left'):
		input.x -= 1
		#$AnimationPlayer.play("left")
		$AnimatedSprite2D.animation = "left"
		$AnimatedSprite2D.flip_h = true
	if Input.is_action_pressed('down'):
		input.y += 1
		#$AnimationPlayer.play("down")
	if Input.is_action_pressed('up'):
		input.y -= 1
		#$AnimationPlayer.play("up")	
	return input

func _physics_process(delta):
#Actions
	if Input.is_action_just_pressed('flamethrower') && !flamethrowing && flamethrowerAvailable:
		$Weapons/Hurtbox/FlamethrowerCone.disabled = false
		$Weapons/Hurtbox/FlamethrowerParticles.emitting = true
		$FlamethrowerIgnitionAudio.play()
		flamethrowing = true
			
	if(flamethrowing):
		$Weapons/Hurtbox/FlamethrowerCone.scale = $Weapons/Hurtbox/FlamethrowerCone.scale.lerp(Vector2(1,1), delta * flameSpeed)
		#print($Weapons/Hurtbox/FlamethrowerCone.scale)
		if !$FlamethrowerAudio.playing:
			$FlamethrowerAudio.play()
			
	if(!flamethrowerAvailable || flamethrowing && !Input.is_action_pressed('flamethrower')):
		flamethrowing = false
		$FlamethrowerAudio.stop()
		$Weapons/Hurtbox/FlamethrowerParticles.emitting = false
		$Weapons/Hurtbox/FlamethrowerCone.scale = Vector2.ZERO
		$Weapons/Hurtbox/FlamethrowerCone.disabled = true
		
	if Input.is_action_just_pressed('leafblower') && !blowing && leafblowerAvailable:
		$Weapons/Hurtbox/LeafBlowerCone.disabled = false
		$Weapons/Hurtbox/LeafBlowerParticles.restart()
		blowing = true
			
	if(blowing):
		$Weapons/Hurtbox/LeafBlowerCone.scale = $Weapons/Hurtbox/LeafBlowerCone.scale.lerp(Vector2(1, 1), delta * blowerSpeed)
		handleLeafblower()
		blowerInProgress = true
	
	if Input.is_action_just_pressed("machete"):
		$Weapons/Hurtbox/MacheteBox.disabled = false
		$MacheteAudio.play()
		await get_tree().create_timer(.25).timeout
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
		$AnimatedSprite2D.play()
		if !shouldPlayFootsteps:
			shouldPlayFootsteps = true
			handleFootsteps()
	else:
		shouldPlayFootsteps = false
		velocity = velocity.lerp(Vector2.ZERO, friction)
		$AnimatedSprite2D.stop()
		#$FootstepsAudio.stop()
	move_and_slide()

func handleLeafblower():
	if !blowerInProgress:
		await get_tree().create_timer(.7).timeout
		$Weapons/Hurtbox/LeafBlowerCone.scale = Vector2.ZERO
		$Weapons/Hurtbox/LeafBlowerCone.disabled = true
		blowing = false
		blowerInProgress = false

func handleFootsteps():
	if shouldPlayFootsteps:
		$FootstepsAudio.pitch_scale = randf_range(.8, 1.2)
		$FootstepsAudio.play()
		await get_tree().create_timer(.3).timeout
		$FootstepsAudio2.pitch_scale = randf_range(.8, 1.2)
		$FootstepsAudio2.play()
		await get_tree().create_timer(.3).timeout		
		handleFootsteps()


#Intro signals
func remove_intro_prompts():
	for node in get_tree().get_nodes_in_group("Intro_Prompts"):
		node.queue_free()

func _on_wasd_prompts_completed():
	%Camera2D.zoom(%Camera2D.zoom_levels[1])

#Inventory
func _on_item_pickup_body_entered(pickup_name: String):
	print("Picked up item: " + pickup_name + "!")
	
	if pickup_name == "machete":
		inventory["machete"] = true
		remove_intro_prompts()
		if %Camera2D.get_zoom().x == %Camera2D.zoom_levels[0]: %Camera2D.zoom(%Camera2D.zoom_levels[1])
	elif pickup_name == "flamethrower":
		inventory["flamethrower"] = true
		remove_intro_prompts()
		if %Camera2D.get_zoom().x == %Camera2D.zoom_levels[0]: %Camera2D.zoom(%Camera2D.zoom_levels[1])
	#elif pickup_name == "leafblower":
		#inventory["leafblower"] = true

func _on_barrel_body_entered():
	_on_item_pickup_body_entered("flamethrower")

func _on_tutorial_exited():
	remove_intro_prompts()
	%Camera2D.zoom(%Camera2D.zoom_levels[3])
	get_tree().get_root().get_node("Level").StartGame()


func _on_myco_grunt_touched_player():
	#TODO OXYGEN DAMAGE
	$DamageAudio.play()
