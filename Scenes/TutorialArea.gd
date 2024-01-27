extends Area2D

signal on_tutorial_exited()
var game_started = false


func _ready():
	pass


func _process(_delta):
	pass


func _on_body_exited(body):
	if body.name != "Player":
		return
	# Added to avoid triggering every time the player walks through. Disabling CollisionShape2D does not overide this.
	elif !game_started:
		game_started = true
		on_tutorial_exited.emit()

