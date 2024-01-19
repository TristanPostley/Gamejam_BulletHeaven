extends CharacterBody2D

const speed = 25
const acceleration = 0.1
var alive = true


func _ready():
	# Function for spawning instances at game start goes here, unless handled as a signal.
	pass


func _process(delta):
	pass


func _physics_process(delta):
	# Fetch player position.
	var playerx = get_parent().get_node("Player").position.x
	var playery = get_parent().get_node("Player").position.y

	# Determine relative direction to player and move.
	var xdirection = round((playerx - position.x) / abs(playerx - position.x))
	# print("MycoGrunt X: ", xdirection)
	if xdirection:
		velocity.x = lerp(velocity.x, xdirection * speed * (-1), acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	var ydirection = round((playery - position.y) / abs(playery - position.y))
	# print("MycoGrunt Y: ", ydirection)
	if ydirection:
		velocity.y = lerp(velocity.y, ydirection * speed * (-1), acceleration)
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
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.stop()

	if !$Audio_Die.playing:
		$Audio_Die.play()

	await get_tree().create_timer(1.8).timeout
	queue_free()
