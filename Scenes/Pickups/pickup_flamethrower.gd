extends BasePickup

func _ready():
	pickup_name = "flamethrower"

func _process(delta):
	# todo should this be handled at the BasePickup level?
	_process_base_pickup(delta)
	#%CollisionShape2D.disabled = launching

func _on_area_2d_body_entered(body):
	_on_base_pickup_body_entered(body)
