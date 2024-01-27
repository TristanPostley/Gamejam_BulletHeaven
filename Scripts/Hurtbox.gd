extends Area2D

var selectedWeapon
var activeWeapon


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
#Damage touched enemy
	#print(body)
	if body.name.begins_with("MycoGrunt"):
		if activeWeapon == "flamethrower":
			body.Burn()
		elif activeWeapon == "leafblower":
			body.Push(global_position)
		else:
			body.Die()
	elif body.name.begins_with("MycoSpreader"):
		if activeWeapon == "flamethrower":
			body.Burn()
		elif activeWeapon == "leafblower":
			body.Push(global_position)
		else:
			body.Die()
	elif body.name.begins_with("OxygenPlant"):
		if activeWeapon == "flamethrower":
			body.Burn()
		elif activeWeapon == "leafblower":
			body.Extinguish()
		else:
			body.Die()
	else:
		pass


#func _on_body_exited(body):
	#print(body.name, "Exit")
	#if body.name.begins_with("MycoGrunt"):
		#body.Burn()
	#elif body.name.begins_with("MycoSpreader"):
		#body.Burn()
	#elif body.name.begins_with("OxygenPlant"):
		#body.Burn()
	#else:
		#pass
