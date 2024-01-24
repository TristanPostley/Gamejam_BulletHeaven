extends CharacterBody2D

const speed = 25
const acceleration = 0.1
const convert_radius = 2

var alive = true


func _ready():
	# Function for spawning instances at game start goes here, unless handled as a signal.
	pass


func _process(_delta):
	pass


func _physics_process(_delta):
	# Fetch player position.
	var Player = get_tree().get_root().get_node("Level").get_node("Player")
	var playerx = Player.position.x
	var playery = Player.position.y

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

	if alive:  #Do stuff
		$AnimatedSprite2D.play()
		var tile_map = get_tree().get_root().get_node("Level").get_node("LandingZone").get_node("TileMap")
		var tile: Vector2i = tile_map.get_tile_from_vector(position)
		for i in range(-convert_radius, convert_radius, 1):
			for j in range(-convert_radius, convert_radius, 1):
				var temptile = tile
				temptile.x = tile.x + i
				temptile.y = tile.y + j
				tile_map.convert_tile_to_mycelium(temptile)
		#print(tile, " ", tile.x, " ", tile.y)
		move_and_slide()
	else: # If dead, stop moving and let animation/sound play in Burn()
		pass


func Burn():
	alive = false
	$Burning.visible = true
	$BurningAudio.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.stop()

	await get_tree().create_timer(1.8).timeout
	if !$Audio_Die.playing:
		$Audio_Die.play()
	queue_free()
