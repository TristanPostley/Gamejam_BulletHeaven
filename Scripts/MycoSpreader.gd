extends CharacterBody2D

const speed = 75
const acceleration = 0.1
const convert_radius = 3

var walk_duration = 5
var alive = false
var xdirection = sign(randf_range(-1, 1))
var ydirection = sign(randf_range(-1, 1))
var init_delta = 0
var total_time = 0

var pushedPosition
var pushing = false
var death_sprite

func _ready():
	death_sprite = get_tree().get_root().get_node("Level").get_node("DeadMycoSpreader")
	$AnimatedSprite2D.play("move")
	name = "MycoSpreader"


func _process(_delta):
	pass


func _physics_process(delta):
	# Fetch player position.
	var Player = get_tree().get_root().get_node("Level").get_node("Player")
	var playerx = Player.position.x
	var playery = Player.position.y
	var dist = position.distance_to(Player.position)
	total_time += delta
	if dist > 1000:
		if total_time > init_delta + walk_duration:
			xdirection = sign(randf_range(-1, 1))
			ydirection = sign(randf_range(-1, 1))
			init_delta = total_time
		else:
			pass
	else:
		if position.x > playerx:
			xdirection = -1
		elif position.x < playerx:
			xdirection = 1
		else:
			xdirection = 0

		if position.y > playery:
			ydirection = -1
		elif position.y < playery:
			ydirection = 1
		else:
			ydirection = 0
	
	#print(xdirection, " ", ydirection)
	if xdirection:
		velocity.x = lerp(velocity.x, float(xdirection) * speed * (-1), acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if ydirection:
		velocity.y = lerp(velocity.y, float(ydirection) * speed * (-1), acceleration)
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

	if (xdirection or ydirection) and alive:  # If moving and not already playing, start footstep audio.
		if !$Audio_Move.playing: 
			$Audio_Move.play()
	else:
		$Audio_Move.stop()
		
	if pushing:
		alive = false
		position = position.lerp(pushedPosition, delta * 5)
		if position.is_equal_approx(pushedPosition):
			pushing = false
			alive = true

	if alive:  #Do stuff
		$AnimatedSprite2D.play("move")
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


func Die():
	alive = false
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("death")
	if !$Audio_Die.playing:
		$Audio_Die.play()
	get_tree().get_root().get_node("Level").CountDeadSpreader()
	
	var dead_spreader = Sprite2D.new()
	dead_spreader.texture = death_sprite.texture
	dead_spreader.scale = death_sprite.scale
	dead_spreader.z_index = death_sprite.z_index
	dead_spreader.position = position
	get_tree().get_root().get_node("Level").add_child.call_deferred(dead_spreader)


func Burn():
	Die()
	$Burning.visible = true
	$BurningAudio.play()
	await get_tree().create_timer(1.8).timeout
	queue_free()


func Push(playerPosition):
	if pushing:
		return
	var r = playerPosition.distance_to(position)
	var theta = playerPosition.angle_to_point(position)
	pushedPosition = Vector2(position.x + (1.0001 * r * cos(theta)), position.y + (1.0001 * r * sin(theta)))
	pushing = true


func Spawn():
	alive = true

