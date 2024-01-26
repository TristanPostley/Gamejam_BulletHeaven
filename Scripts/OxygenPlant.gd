extends CharacterBody2D

var alive = true

@export var startBurning = false

func _ready():
	if startBurning:
		$Burning.visible = true
		alive = false
		$OxygenBubble.visible = false

func _physics_process(delta):
	if alive:  # If dead, stop moving and let animation/sound play.
		$AnimatedSprite2D.play("idle")
		if !$Audio_Idle.playing: 
			$Audio_Idle.play()
	else:
		$Audio_Idle.stop()

func Die():
	alive = false
	$OxygenBubble.visible = false
	$Audio_Die.play()
	$AnimatedSprite2D.animation = "dead"

func Burn():
	if !alive:
		return
	alive = false
	$OxygenBubble.visible = false
	$Burning.visible = true
	$BurningAudio.play()
	$AnimatedSprite2D.stop()

	# Player has chance to put out the fire
	await get_tree().create_timer(1.8).timeout
	
	if $Burning.visible == true:
		$Burning.visible = false
		Die()
	
	#queue_free()
	
func Extinguish():
	if $Burning.visible:
		$Burning.visible = false
		alive = true
		$OxygenBubble.visible = true
		for child in get_children():
			if child.name == "PlantPrompt":
				child.visible = false
	

func _on_oxygen_timer_timeout():
	# Periodically spawn new items
	if alive:
		%ItemSpawner.spawn_items()
