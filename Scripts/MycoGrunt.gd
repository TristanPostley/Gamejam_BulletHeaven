extends CharacterBody2D

@export var speed = 125
const acceleration = 0.15

var alive = false
@onready var Player = get_tree().get_root().get_node("Level").get_node("Player")

var pushedPosition
var pushing = false
@onready var death_sprite = get_tree().get_root().get_node("Level").get_node("DeadMycoGrunt")

func _ready():
	$AnimatedSprite2D.play("spawn")
	name = "MycoGrunt"


func _process(_delta):
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
	var direction = global_position.direction_to(Player.global_position)
	velocity = velocity.lerp(direction * speed, acceleration)
	
	if velocity and alive:  # If moving and not already playing, start footstep audio.
		if !$Audio_Move.playing: 
			$Audio_Move.play()
	else:
		$Audio_Move.stop()
	
	if alive:
		move_and_slide()
		if get_last_slide_collision():
			if get_slide_collision(0).get_collider().name == "Player":
				Attack()
				
	if pushing:
		alive = false
		position = position.lerp(pushedPosition, delta * 5)
		if position.is_equal_approx(pushedPosition):
			pushing = false
			alive = true


func Die():
	alive = false
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("death")
	if !$Audio_Die.playing:
		$Audio_Die.play()
	get_tree().get_root().get_node("Level").CountDeadGrunt()

	var dead_grunt = Sprite2D.new()
	dead_grunt.texture = death_sprite.texture
	dead_grunt.scale = death_sprite.scale
	dead_grunt.z_index = death_sprite.z_index
	dead_grunt.position = position
	get_tree().get_root().get_node("Level").add_child.call_deferred(dead_grunt)
	
	await get_tree().create_timer(1.5).timeout	
	queue_free()	


func Burn():
	Die()
	$Burning.visible = true
	$BurningAudio.play()
	await get_tree().create_timer(1.5).timeout
	$BurningAudio.stop()
	$Burning.visible = false
	queue_free()


func Attack():
	Die()
	# Had to change, signal doesn't work for child instances because of node structure.
	get_tree().get_root().get_node("Level").get_node("Player").on_myco_grunt_touched_player()
	#await get_tree().create_timer(0.5).timeout
	#queue_free()


func Push(playerPosition):
	if pushing:
		return
	var r = playerPosition.distance_to(position)
	var theta = playerPosition.angle_to_point(position)
	pushedPosition = Vector2(position.x + (1.001 * r * cos(theta)), position.y + (1.001 * r * sin(theta)))
	pushing = true


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "spawn":
		$AnimatedSprite2D.play("move")
		alive = true

