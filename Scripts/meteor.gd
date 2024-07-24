extends Node2D

@export var fall_speed = 200
@export var damage = 50

@onready var _rock: AnimatedSprite2D = $AnimatedSprite2D
@onready var _shadow: AnimatedSprite2D = $Shadow
@onready var _explosion: Area2D = $Explosion

var rock_pos

enum MeteorState { FALLING, EXPLODING }

var remove_timer = 0
var state:MeteorState = MeteorState.FALLING

# Called when the node enters the scene tree for the first time.
func _ready():
	_explosion.visible = false
	_explosion.monitorable = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rock_pos.y > 0:
		explode()
		state = MeteorState.EXPLODING
	if state == MeteorState.FALLING:
		rock_pos.y += fall_speed * delta
	if state == MeteorState.EXPLODING:		
		remove_timer += delta
		if remove_timer > 1:
			queue_free()
	_rock.position = rock_pos

func explode():
	_rock.visible = false
	_shadow.visible = false
	_explosion.visible = true
	_explosion.monitoring = true

func initialize(new_position):
	position = new_position
	rock_pos = Vector2(0, -500)
	$Explosion.monitoring = false
	
func get_damage():

	return damage
