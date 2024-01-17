extends CharacterBody2D

const SPEED = 150

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
		velocity.x = xdirection * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var ydirection = round((playery - position.y) / abs(playery - position.y))
	# print("MycoGrunt Y: ", ydirection)
	if ydirection:
		velocity.y = ydirection * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
