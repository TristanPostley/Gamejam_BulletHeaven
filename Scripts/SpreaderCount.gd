extends Label

var viewportWidth = 0
var viewportHeight = 0
var origin = 0
var zoom_level = 1
var camera

func _ready():
	camera = get_tree().get_root().get_node("Level").get_node("Camera2D")
	var initial_spreaders = get_tree().get_root().get_node("Level").get_spreaders()
	text = "Spreaders eradicated: 0/" + str(initial_spreaders) + "\nGrunts incinerated: 0"


func _process(_delta):
	viewportWidth = get_viewport().size.x
	viewportHeight = get_viewport().size.y
	zoom_level = camera.get_canvas_transform().x[0]
	origin = camera.get_canvas_transform().origin * (-1) / zoom_level
	position = origin
	position.x += 10
	scale = Vector2(1/zoom_level, 1/zoom_level)


func UpdateText(dead_spreaders, num_spreaders, dead_grunts):
	text = "Spreaders eradicated: " + str(dead_spreaders) + "/" + str(num_spreaders) + "\nGrunts incinerated: " + str(dead_grunts)

