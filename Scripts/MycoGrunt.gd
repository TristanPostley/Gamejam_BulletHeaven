extends CharacterBody2D

@export var speed = 125
const acceleration = 0.15

var alive = false
@onready var player := get_tree().get_root().get_node("Level/Player")
@onready var death_sprite := get_tree().get_root().get_node("Level/DeadMycoGrunt")
var pushedPosition
var pushing := false
var move_sound_max_distance := 700.0

func _ready():
	$AnimatedSprite2D.play("spawn")
	name = "MycoGrunt"
	
	# Reduces lag. Only play move sound if within this distance of player
	$Audio_Move.max_distance = move_sound_max_distance

func _physics_process(delta):
	if alive:
		handle_movement()
		check_collision_with_player()

	handle_pushing(delta)

func handle_movement():
	var direction := global_position.direction_to(player.global_position)
	velocity = velocity.lerp(direction * speed, acceleration)
	var distance_to_player = global_position.distance_to(player.global_position)
	if velocity.length() > 0:
		move_and_slide()
		
		if distance_to_player <= move_sound_max_distance and not $Audio_Move.playing:
			$Audio_Move.play()
	
	if distance_to_player > move_sound_max_distance:
		$Audio_Move.stop()

func check_collision_with_player():
	if get_last_slide_collision():
		if get_slide_collision(0).get_collider().name == "Player":
			Attack()

func handle_pushing(delta):
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

# Pushed by the leaf blower
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

