extends KeyPromptResource

@onready var animation_player = %AnimationPlayer

const directions = ['up', 'left', 'down', 'right']
var next_key_press = directions[0]
var keys_pressed : Dictionary = {}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Track which keys have been pressed
	if Input.is_action_pressed(directions[0]):
		keys_pressed[directions[0]] = true
	elif Input.is_action_pressed(directions[1]):
		keys_pressed[directions[1]] = true
	elif Input.is_action_pressed(directions[2]):
		keys_pressed[directions[2]] = true
	elif Input.is_action_pressed(directions[3]):
		keys_pressed[directions[3]] = true
	
	# Exit early if the player still has to press the next key
	if !keys_pressed.has(next_key_press):
		return
	
	# Give a new prompt as needed
	if !keys_pressed.has(directions[1]):
		$AnimationPlayer.play("a_press")
		next_key_press = directions[1]
		return
	elif !keys_pressed.has(directions[2]):
		$AnimationPlayer.play("s_press")
		next_key_press = directions[2]
		return
	elif !keys_pressed.has(directions[3]):
		$AnimationPlayer.play("d_press")
		next_key_press = directions[3]
		return
	
	# All of the prompts have been pressed, so free up this resource
	queue_free()
