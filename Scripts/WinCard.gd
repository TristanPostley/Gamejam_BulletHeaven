extends Control

var active = false
var viewportWidth = 0
var viewportHeight = 0
var newScale = 0
var zoom_level = 1
var origin
var camera
var credits


func _ready():
	camera = get_tree().get_root().get_node("Level").get_node("Camera2D")
	credits = get_tree().get_root().get_node("Level").get_node("Credits") 
	hide()


func _process(_delta):
	if active:
		if Input.is_action_pressed("machete"):
			active = false
			get_tree().get_root().get_node("Level").Restart()


func WinGame():
	viewportWidth = get_viewport().size.x
	viewportHeight = get_viewport().size.y
	zoom_level = camera.get_canvas_transform().x[0]
	origin = camera.get_canvas_transform().origin * (-1) / zoom_level
	#origin = origin - Vector2(viewportWidth/2, viewportHeight/2)/zoom_level
	newScale = viewportHeight / $TextureRect.texture.get_size().y / zoom_level

	$TextureRect.set_scale(Vector2(newScale, newScale))
	$TextureRect.position = origin

	$Button.set_scale(Vector2(0.5, 0.5))
	$Button.position = origin
	$Button.position.x += viewportWidth/2/zoom_level - $Button.get_size().x/2*0.5
	$Button.position.y += viewportWidth/2/zoom_level - $Button.get_size().y/2*0.5 - 50

	show()
	credits.position =  origin + Vector2((viewportWidth/2/zoom_level)+980, 10/zoom_level)
	credits.scale = Vector2(1/zoom_level/1.25, 1/zoom_level/1.25)
	credits.show()
	active = true

func _on_button_pressed():
	active = false
	get_tree().get_root().get_node("Level").Restart()

