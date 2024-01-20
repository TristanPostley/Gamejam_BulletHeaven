extends KeyPromptResource

@onready var animation_player = %AnimationPlayer

var directions = ['up', 'left', 'down', 'right']
var last_pressed_direction = ''

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed(directions[0]) && last_pressed_direction == '':
		$AnimationPlayer.play("a_press")
		last_pressed_direction = directions[0]
	if Input.is_action_pressed(directions[1]) && last_pressed_direction == directions[0]:
		$AnimationPlayer.play("s_press")
		last_pressed_direction = directions[1]
	if Input.is_action_pressed(directions[2]) && last_pressed_direction == directions[1]:
		$AnimationPlayer.play("d_press")
		last_pressed_direction = directions[2]
	if Input.is_action_pressed(directions[3]) && last_pressed_direction == directions[2]:
		queue_free()
