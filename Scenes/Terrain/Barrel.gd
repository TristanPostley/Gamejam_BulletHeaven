extends Area2D

signal barrel_body_entered()

func _on_body_entered(body):
	# todo, barrel should be destroyed by machete
	if body.name != "Player":
		return
	
	barrel_body_entered.emit()
	queue_free()
