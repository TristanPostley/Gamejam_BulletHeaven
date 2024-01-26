extends Control

var origin
var viewportWidth = 0
var viewportHeight = 0
var newScale = 0


func _ready():
	hide()


func _process(delta):
	pass


func LoseGame():
	viewportWidth = get_viewport().size.x
	viewportHeight = get_viewport().size.y
	var zoom_level = get_tree().get_root().get_node("Level").get_node("Camera2D").get_zoom().x
	origin = get_tree().get_root().get_node("Level").get_node("Camera2D").position
	origin = origin - Vector2(viewportWidth/2, viewportHeight/2)/zoom_level
	newScale = viewportHeight / $TextureRect.texture.get_size().y
	newScale = newScale / zoom_level
	
	$TextureRect.set_scale(Vector2(newScale, newScale))
	$TextureRect.position = origin

	$Button.set_scale(Vector2(0.5, 0.5))
	$Button.position = origin
	$Button.position.x += viewportWidth/2/zoom_level - $Button.get_size().x/2*0.5
	$Button.position.y += viewportWidth/2/zoom_level - $Button.get_size().y/2*0.5 - 50

	show()


func _on_button_pressed():
	get_tree().get_root().get_node("Level").Restart()
