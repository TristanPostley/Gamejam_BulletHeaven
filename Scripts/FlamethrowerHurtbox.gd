extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	#print(body.name, "Enter")
	if body.name == "MycoGrunt":
		body.Burn()
	elif body.name == "MycoSpreader":
		body.Burn() 
	else:
		pass


func _on_body_exited(body):
	#print(body.name, "Exit")
	if body.name == "MycoGrunt":
		body.Burn()
	elif body.name == "MycoSpreader":
		body.Burn() 
	else:
		pass
