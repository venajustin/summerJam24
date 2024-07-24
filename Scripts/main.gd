extends Node

signal game_start
signal game_end


var timer = 0

enum State {RUNNING, PAUSED, OVER}

var state: State = State.RUNNING

@onready var _player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.RUNNING
	game_start.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if Input.is_key_pressed(KEY_F11):
		var window:Window = get_window()
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


