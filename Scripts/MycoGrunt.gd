extends CharacterBody2D

const speed = 100
var alive = true

func _ready():
	pass

func _process(delta):
	# Roll for a chance to spawn every tick.
	# Mainly testing spawning new enemies here. Keep commented out as it causes issues.
	"""
	if randf() > 0.99:
		print("Spawning additional MycoGrunt!")
		var NewMycoGrunt = get_parent().get_node("MycoGrunt").duplicate()
		NewMycoGrunt.position = position
		get_parent().add_child(NewMycoGrunt)
	"""
	pass

func _physics_process(delta):
	# Fetch player position.
	var playerx = get_parent().get_node("Player").position.x
	var playery = get_parent().get_node("Player").position.y

	# Determine relative direction to player and move.
	var xdirection = round((playerx - position.x) / abs(playerx - position.x))
	# print("MycoGrunt X: ", xdirection)
	if xdirection:
		velocity.x = xdirection * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	var ydirection = round((playery - position.y) / abs(playery - position.y))
	# print("MycoGrunt Y: ", ydirection)
	if ydirection:
		velocity.y = ydirection * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

	if (xdirection or ydirection) and alive:  # If moving and not already playing, start footstep audio.
		if !$Audio_Move.playing: 
			$Audio_Move.play()
	else:
		$Audio_Move.stop()

	if alive == true:  # If dead, stop moving and let animation/sound play.
		$AnimatedSprite2D.play("move")
		move_and_slide()

func Burn():
	alive = false
	if !$Audio_Die.playing:
		$Audio_Die.play()
	await get_tree().create_timer(1.5).timeout
	queue_free()
