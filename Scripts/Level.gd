extends Node2D

const num_spreaders = 4

var grunt_scene = load("res://Scenes/myco_grunt.tscn")
var spreader_scene = load("res://Scenes/myco_spreader.tscn")
var spreader_array = []
var total_grunts = 1
var dead_spreaders = 0
var dead_grunts = 0


func _ready():
	Pause()
	#get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
	#hide()
	#remove_child($StartMenu)
	$TutorialTheme.volume_db=-20
	$TutorialTheme.play()
	$FightTheHorde.stop()
	$BurnThemAll.stop()
	#show()


func _process(_delta):
	#print(spreader_array)
	pass


func get_spreaders():
	return num_spreaders+1


func Pause():
	get_tree().paused = true


func UnPause():
	get_tree().paused = false


func StartGame():
	print("Tutorial exited, game starting!")
	$AnimationPlayer.play("StartTransition")
	$LandingZone.get_node("TileMap").start_game()  # Start grunt spawning.
	# Assuming square area for spawning:
	#print(%LandingZone.get_node("TileMap").tile_size.x)
	#print(%LandingZone.get_node("TileMap").get_used_cells_by_id(0).size())
	var tile_pixels = %LandingZone.get_node("TileMap").tile_size.x
	var total_tiles = %LandingZone.get_node("TileMap").get_used_cells_by_id(0).size()
	var axis_pixels = tile_pixels * sqrt(total_tiles)
	var r_pixels = axis_pixels/2
	
	var xbase = randf_range(r_pixels*0.95, r_pixels)
	var ybase = randf_range(r_pixels*0.95, r_pixels)
	var degbase = randf_range(PI/6, PI/3)
	#print(r_pixels, " ", xbase, " ", ybase, " ", degbase, " ", degbase*180/PI)

	for i in range(num_spreaders):  # Spawn n spreaders when player starts game
		spreader_array.append(spreader_scene.instantiate())
		spreader_array[i].position.x = (xbase * cos(degbase + PI/2 * i)) + r_pixels
		spreader_array[i].position.y = (ybase * sin(degbase + PI/2 * i)) + r_pixels
		#print(i, " ", spreader_array[i].position.x, " ", spreader_array[i].position.y)
		# Have to give unique name, or gets randomly assigned and then collision doesn't work.
		spreader_array[i].set_name("MycoSpreader"+str(i))
		spreader_array[i].Spawn()
		#print(spreader_array[i].name)
		add_child(spreader_array[i])


func _on_animation_player_animation_finished(StartTransition):
	$FightTheHorde.stop()
	$BurnThemAll.play()


func _on_burn_them_all_finished():
	$BurnThemAll.play()  # Loop audio.


func CountGruntSpawn():
	total_grunts += 1
	$SpreaderCount.UpdateText(dead_spreaders, num_spreaders+1, dead_grunts, total_grunts)


func CountDeadSpreader():
	dead_spreaders += 1
	$SpreaderCount.UpdateText(dead_spreaders, num_spreaders+1, dead_grunts, total_grunts)
	if dead_spreaders == num_spreaders+1:
		GameWon()


func CountDeadGrunt():
	total_grunts -= 1
	dead_grunts += 1
	$SpreaderCount.UpdateText(dead_spreaders, num_spreaders+1, dead_grunts, total_grunts)


func GameWon():
	$TutorialTheme.stop()
	$FightTheHorde.stop()
	$BurnThemAll.stop()
	$WinCard_Audio.play()
	Pause()
	$WinCard.WinGame()


func GameLost():
	$TutorialTheme.stop()
	$FightTheHorde.stop()
	$BurnThemAll.stop()
	$FailCard_Audio.play()
	Pause()
	$FailCard.LoseGame()


func Restart():
	print("Restarting game!")
	get_tree().reload_current_scene()
