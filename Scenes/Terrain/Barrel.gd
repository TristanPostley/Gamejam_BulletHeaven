extends Area2D

signal barrel_body_entered(body: Node2D)

func _on_body_entered(body):
	# todo, barrel should be destroyed by machete
	if body.name != "Player":
		return
	
	queue_free()
