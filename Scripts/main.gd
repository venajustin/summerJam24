extends Node

signal game_start
signal game_end
signal villagers_eaten
signal next_phase

var num_villagers_eaten = 0

var timer = 0

enum State {RUNNING, PAUSED, OVER}

var state: State = State.RUNNING
var window:Window

@onready var _player = $Player
var num_villagers = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.RUNNING
	game_start.emit()
	window = get_window()
	
	var children = get_children()
	
	for child in children:
		if child.name.contains("House"):
			num_villagers += 4
	
	villagers_eaten.emit(0, num_villagers)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#next phase cheat code
	if Input.is_key_pressed(KEY_F24):
		next_phase.emit()
	
	
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if Input.is_key_pressed(KEY_F11):
		
		if window.mode == Window.Mode.MODE_EXCLUSIVE_FULLSCREEN:
			window.borderless = false
			window.mode = Window.Mode.MODE_WINDOWED
		else:  
			window.borderless = true
			window.mode = Window.Mode.MODE_EXCLUSIVE_FULLSCREEN
	
	if state == State.OVER:
		if (timer < .5) :
			timer += delta
		elif (Input.is_key_pressed(KEY_SPACE)):
			state == State.RUNNING
			game_start.emit()
			get_tree().reload_current_scene()
			timer = 0

		


func _on_player_died():
	state = State.OVER
	game_end.emit()




func _on_demon_eat_villager():
	num_villagers_eaten += 1
	if num_villagers_eaten > 3:
		next_phase.emit()
	if num_villagers_eaten > 10:
		next_phase.emit()
	villagers_eaten.emit(num_villagers_eaten, num_villagers)
