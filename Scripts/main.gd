extends Node

signal game_start
signal game_end


var timer = 0

@onready var _player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	game_start.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (timer < .5) :
		timer += delta
	elif (Input.is_key_pressed(KEY_SPACE)):
		game_start.emit()
		timer = 0
		set_process(false)
		


func _on_player_died():
	set_process(true)
	game_end.emit()


