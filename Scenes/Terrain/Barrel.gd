extends StaticBody2D

var destroyed = false

func _ready():
	%ItemSpawner.launch_speed = 400

func _on_barrel_hurt_box_area_entered(area):
	if destroyed:
		return
	
	# todo Should use signals/classes instead of looking for the hitbox with get_node
	var machete_box = area.get_node_or_null("MacheteBox")
	if !machete_box:
		return
	
	# The barrel was not hit by a machete, so exit early
	if machete_box.disabled:
		return
	
	destroyed = true

	# Drop the flamethrower
	%ItemSpawner.spawn_resource(Vector2(1, 0))
	$CollisionShape2D.set_deferred("disabled", true)

	# Change the look of the barrel
	%BarrelPrompt.queue_free()
	%Sprite2D.self_modulate = Color("323232")

