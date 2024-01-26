extends Control

var origin
var viewportWidth = 0
var viewportHeight = 0
var newScale = 0
var camera


func _ready():
	camera = get_tree().get_root().get_node("Level").get_node("Camera2D")
	viewportWidth = get_viewport().size.x
	viewportHeight = get_viewport().size.y
	origin = get_tree().get_root().get_node("Level").get_node("Camera2D").position
	origin = origin - Vector2(viewportWidth/2, viewportHeight/2)

	$ColorRect.size.x = viewportWidth
	$ColorRect.size.y = viewportHeight
	$ColorRect.position = origin

	newScale = viewportHeight / $TextureRect.texture.get_size().y
	#print(viewportWidth, " ", viewportHeight, " ", newScaleX, " ", newScaleY)
	#$TextureRect.set_position(Vector2(viewportWidth/2, viewportHeight/2))
	$TextureRect.set_scale(Vector2(newScale, newScale))
	$TextureRect.position = origin
	$TextureRect.position.x += 50
	print($TextureRect.position)
	$Button.set_scale(Vector2(newScale, newScale))
	$Button.position.x = origin.x + $TextureRect.get_size().x*newScale + 100
	$Button.position.y = origin.y + $Button.get_size().y*newScale/2
	#get_tree().get_root().get_node("Level").get_node("TutorialTheme").play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print("aaaaa")
	pass

func _on_button_pressed():
	print("Starting tutorial!")
	#get_tree().change_scene_to_node("res://Scenes/Level.tscn")
	hide()
	get_tree().get_root().get_node("Level").UnPause()
