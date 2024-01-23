extends Area2D

signal on_tutorial_exited()
var game_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_exited(body):
	if body.name != "Player":
		return
	# Added to avoid triggering every time the player walks through. Disabling CollisionShape2D does not overide this.
	elif !game_started:
		game_started = true
		on_tutorial_exited.emit()
