extends StaticBody2D

@onready var flame_die_timer = $flame_die_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	$flame_die_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_flame_die_timer_timeout():
	queue_free()
