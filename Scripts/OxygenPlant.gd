extends CharacterBody2D

var alive = true

func _physics_process(delta):
	if alive:  # If dead, stop moving and let animation/sound play.
		$AnimatedSprite2D.play("idle")
		if !$Audio_Idle.playing: 
			$Audio_Idle.play()
	else:
		$Audio_Idle.stop()


func Burn():
	if !alive:
		return
	
	alive = false
	$OxygenBubble.visible = false
	$Burning.visible = true
	$BurningAudio.play()
	$AnimatedSprite2D.stop()

	await get_tree().create_timer(1.8).timeout
	
	if $Burning.visible == true:
		$Audio_Die.play()
		$Burning.visible = false
		$AnimatedSprite2D.animation = "dead"
	
	#queue_free()
	
func Extinguish():
	print('test')
	$Burning.visible = false
	alive = true
	$OxygenBubble.visible = true
	

func _on_oxygen_timer_timeout():
	# Periodically spawn new items
	if alive:
		%ItemSpawner.spawn_items()
