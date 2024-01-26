extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_at(get_global_mouse_position())
	if Input.get_joy_axis(0, JOY_AXIS_RIGHT_X) > .1 || Input.get_joy_axis(0 ,JOY_AXIS_RIGHT_Y) > .1 || Input.get_joy_axis(0, JOY_AXIS_RIGHT_X) < -.1 || Input.get_joy_axis(0 ,JOY_AXIS_RIGHT_Y) < -.1:
		rotation = Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), Input.get_joy_axis(0 ,JOY_AXIS_RIGHT_Y)).angle()
		
