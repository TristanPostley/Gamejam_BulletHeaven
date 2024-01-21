extends CharacterBody2D

var alive = true


func _ready():
	# Function for spawning instances at game start goes here, unless handled as a signal.
	pass


func _process(delta):
	pass


func _physics_process(delta):
	if alive:  # If dead, stop moving and let animation/sound play.
		$AnimatedSprite2D.play("idle")
		if !$Audio_Idle.playing: 
			$Audio_Idle.play()
	else:
		$Audio_Idle.stop()


func Burn():
	alive = false
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.stop()

	if !$Audio_Die.playing:
		$Audio_Die.play()

	await get_tree().create_timer(1.8).timeout
	queue_free()
