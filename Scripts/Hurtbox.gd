extends Area2D

var selectedWeapon

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	#print("Name: ", body.name, " Position: ", body)
	#print("Entered ", body.name, " Flame off: ", get_children()[0].disabled, " Machete off: ", get_children()[2].disabled)
#Detect weapon being used
	var activeWeapon
#Check which weapon is currently enabled in hierarchy order
	if(get_children()[0].disabled == false):
		activeWeapon = "flamethrower"
	elif(get_children()[2].disabled == false):
		activeWeapon = "machete"
	elif(get_children()[3].disabled == false):
		activeWeapon = "leafblower"
			
	#print("Weapon ", activeWeapon)

#Damage touched enemy
	#print(body.name, "Entered")
	if body.name.begins_with("MycoGrunt"):
		body.Burn()
	elif body.name.begins_with("MycoSpreader"):
		body.Burn()
	elif body.name.begins_with("OxygenPlant"):
		body.Burn()
	else:
		pass


func _on_body_exited(body):
	#print(body.name, "Exit")
	if body.name.begins_with("MycoGrunt"):
		body.Burn()
	elif body.name.begins_with("MycoSpreader"):
		body.Burn()
	elif body.name.begins_with("OxygenPlant"):
		body.Burn()
	else:
		pass
