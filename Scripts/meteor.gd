extends Area2D

@export var fall_speed = 200

@onready var _rock = $AnimatedSprite2D

var rock_pos

enum MeteorState { FALLING, EXPLODING }

var remove_timer = 0
var state = MeteorState.FALLING

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rock_pos.y > 0:
		explode()
		state = MeteorState.EXPLODING
	if state == MeteorState.FALLING:
		rock_pos.y += fall_speed * delta
	if state == MeteorState.EXPLODING:
		# set animation
		remove_timer += delta
		if remove_timer > 1:
			$"../".remove_child(self)
	_rock.position = rock_pos
	

func explode():
	# hit things
	pass

func initialize(new_position):
	position = new_position
	rock_pos = Vector2(0, -500)
	
	
