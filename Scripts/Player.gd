extends CharacterBody2D

@export var speed = 400
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
@onready var flamepoints = [$Weapons/FlamePoint1, $Weapons/FlamePoint2, $Weapons/FlamePoint3, $Weapons/FlamePoint4, $Weapons/FlamePoint9, $Weapons/FlamePoint5, $Weapons/FlamePoint6, $Weapons/FlamePoint7, $Weapons/FlamePoint8, $Weapons/FlamePoint10, $Weapons/FlamePoint11]

# Intro signals
#@onready var start_area = $"../StartArea"

# Key Prompts
var overhead_marker

# Inventory
var inventory : Dictionary = { "beam": false, "flamethrower": false, "leafblower": false, "machete": false }

const INTRO_PROMPTS = preload("res://Scenes/Key Prompts/intro_prompts.tscn")
var prompt

@onready var tile_map = get_tree().get_root().get_node("Level").get_node("LandingZone").get_node("TileMap")

var shouldReduceOxygen = false
var oxygenAtHit
@export var oxygenConsumption = .001
var shouldIncreaseOxygen = false
var oxygenAtPickup
var oxygenTarget = .11

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
		if $AnimatedSprite2D.animation != "machete":
			$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = false
	if Input.is_action_pressed('left'):
		input.x -= 1
		if $AnimatedSprite2D.animation != "machete":
			$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = true
	if Input.is_action_pressed('down'):
		input.y += 1
		if $AnimatedSprite2D.animation != "machete":
			$AnimatedSprite2D.animation = "walk"
	if Input.is_action_pressed('up'):
		input.y -= 1
		if $AnimatedSprite2D.animation != "machete":
			$AnimatedSprite2D.animation = "walk"
	return input

func _physics_process(delta):
#Actions
	if inventory["flamethrower"] && Input.is_action_just_pressed('flamethrower') && !flamethrowing && flamethrowerAvailable:
		$Weapons/Hurtbox/FlamethrowerCone.disabled = false
		$Weapons/Hurtbox/FlamethrowerParticles.emitting = true
		$FlamethrowerIgnitionAudio.play()
		flamethrowing = true
		enableFlamePoints()
		$Weapons/Hurtbox.activeWeapon = "flamethrower"
		
			
	if(flamethrowing):
		$Weapons/Hurtbox/FlamethrowerCone.scale = $Weapons/Hurtbox/FlamethrowerCone.scale.lerp(Vector2(1,1), delta * flameSpeed)
		for point in flamepoints:
			if point.visible == true:
				#var tile: Vector2i = tile_map.get_tile_from_vector(point.global_position)
				#tile_map.convert_tile_to_charred(tile)
				$"../FlameController".start_flame(tile_map.get_tile_from_vector(point.global_position))
		if !$FlamethrowerAudio.playing:
			$FlamethrowerAudio.play()
			
	if(!flamethrowerAvailable || flamethrowing && !Input.is_action_pressed('flamethrower')):
		flamethrowing = false
		$FlamethrowerAudio.stop()
		$Weapons/Hurtbox/FlamethrowerParticles.emitting = false
		$Weapons/Hurtbox/FlamethrowerCone.scale = Vector2.ZERO
		$Weapons/Hurtbox/FlamethrowerCone.disabled = true
		for point in flamepoints:
			point.visible = false
		
	if inventory["leafblower"] && Input.is_action_just_pressed('leafblower') && !blowing && leafblowerAvailable:
		$Weapons/Hurtbox/LeafBlowerCone.disabled = false
		$Weapons/Hurtbox/LeafBlowerParticles.restart()
		$LeafblowerAudio.play()
		blowing = true
		$Weapons/Hurtbox.activeWeapon = "leafblower"		
			
	if(blowing):
		$Weapons/Hurtbox/LeafBlowerCone.scale = $Weapons/Hurtbox/LeafBlowerCone.scale.lerp(Vector2(1, 1), delta * blowerSpeed)
		handleLeafblower()
		blowerInProgress = true
	
	if inventory["machete"] && Input.is_action_just_pressed("machete"):
		$AnimatedSprite2D.animation = "machete"
		$AnimatedSprite2D.play()
		$Weapons/Hurtbox/MacheteBox.disabled = false
		$MacheteAudio.play()
		$Weapons/Hurtbox.activeWeapon = "machete"		
		await get_tree().create_timer(.25).timeout
		$Weapons/Hurtbox/MacheteBox.disabled = true
		$AnimatedSprite2D.animation = "default"

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
		if !$FootstepsLoopAudio.is_playing():
			$FootstepsLoopAudio.play()
	else:
		shouldPlayFootsteps = false
		velocity = velocity.lerp(Vector2.ZERO, friction)
		$FootstepsLoopAudio.stop()
		if !$AnimatedSprite2D.animation == "machete":
			$AnimatedSprite2D.animation = "default"		
	move_and_slide()
	
	oxygenTarget -= delta * oxygenConsumption
	if oxygenTarget >= .11:
		oxygenTarget = .11
	$OxygenBar/OxygenAmount.scale.x = lerp($OxygenBar/OxygenAmount.scale.x, oxygenTarget, delta * 1)
	if $OxygenBar/OxygenAmount.scale.x >= .11:
		$OxygenBar/OxygenAmount.scale.x = .11
	#Player ran out of oxygen
	if $OxygenBar/OxygenAmount.scale.x <= 0:
		end_game()
	

func enableFlamePoints():
	$Weapons/FlamePoint1.visible = true
	await get_tree().create_timer(.35).timeout
	$Weapons/FlamePoint2.visible = true
	$Weapons/FlamePoint10.visible = true
	$Weapons/FlamePoint11.visible = true
	await get_tree().create_timer(.35).timeout
	$Weapons/FlamePoint3.visible = true
	$Weapons/FlamePoint8.visible = true
	$Weapons/FlamePoint7.visible = true
	await get_tree().create_timer(.35).timeout
	$Weapons/FlamePoint4.visible = true
	$Weapons/FlamePoint5.visible = true
	$Weapons/FlamePoint6.visible = true
	$Weapons/FlamePoint9.visible = true
		

func handleLeafblower():
	if !blowerInProgress:
		await get_tree().create_timer(.7).timeout
		$Weapons/Hurtbox/LeafBlowerCone.scale = Vector2.ZERO
		$Weapons/Hurtbox/LeafBlowerCone.disabled = true
		blowing = false
		blowerInProgress = false

#Intro signals
func remove_intro_prompts():
	for node in get_tree().get_nodes_in_group("Intro_Prompts"):
		node.queue_free()

func _on_wasd_prompts_completed():
	%Camera2D.zoom(%Camera2D.zoom_levels[1])

#Inventory
func _on_item_pickup_body_entered(pickup_name: String):
	if pickup_name == "machete":
		inventory["machete"] = true
		remove_intro_prompts()
		if %Camera2D.get_zoom().x == %Camera2D.zoom_levels[0]: %Camera2D.zoom(%Camera2D.zoom_levels[1])
	elif pickup_name == "flamethrower":
		inventory["flamethrower"] = true
		inventory["leafblower"] = true
		remove_intro_prompts()
		if %Camera2D.get_zoom().x == %Camera2D.zoom_levels[0]: %Camera2D.zoom(%Camera2D.zoom_levels[1])
	elif pickup_name == "oxygen":
		oxygenAtPickup = $OxygenBar/OxygenAmount.scale.x
		shouldIncreaseOxygen = true
		oxygenTarget = oxygenAtPickup + .025

func _on_tutorial_exited():
	remove_intro_prompts()
	%Camera2D.zoom(%Camera2D.zoom_levels[3])
	$OxygenBar.scale *= 3
	get_tree().get_root().get_node("Level").StartGame()


func on_myco_grunt_touched_player():
	#TODO OXYGEN DAMAGE
#	Max oxygen = $OxygenBar/OxygenAmount.scale.x = .11
	oxygenAtHit = $OxygenBar/OxygenAmount.scale.x
	#print(oxygenAtHit)
	if oxygenAtHit > 0:
		shouldReduceOxygen = true
		oxygenTarget = oxygenAtHit - .025
		$DamageAudio.play()
	if oxygenAtHit <= 0:  # Die:
		end_game()
		
func end_game():
	get_tree().get_root().get_node("Level").GameLost()
	
	
