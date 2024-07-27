extends Node2D

@export var fall_speed = 200
@export var damage = 50

@onready var _rock: Node2D = $"Rock"
@onready var _rock_sprite:AnimatedSprite2D =  $"Rock/AnimatedSprite2D"
@onready var _shadow: AnimatedSprite2D = $Shadow
@onready var _explosion: Area2D = $"Rock/Explosion"
@onready var _explosion_sprite:AnimatedSprite2D = $"Rock/Explosion/AnimatedSprite2D"

var rock_pos

enum MeteorState { FALLING, EXPLODING }

var remove_timer = 0
var state:MeteorState = MeteorState.FALLING

# Called when the node enters the scene tree for the first time.
func _ready():
	_explosion_sprite.visible = false
	_explosion.monitorable = true
	_rock_sprite.play()
	_shadow.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rock_pos.y > 0:
		explode()
		state = MeteorState.EXPLODING
	if state == MeteorState.FALLING:
		rock_pos.y += fall_speed * delta
	if state == MeteorState.EXPLODING:
		remove_timer += delta
		if remove_timer > .72:
			queue_free()
	_rock.position = rock_pos
	_shadow.frame = 5 - ((-rock_pos.y)/100 - 1)

func explode():
	_rock_sprite.visible = false
	_shadow.visible = false
	_explosion_sprite.visible = true
	_explosion_sprite.play()
	var intersecting = _explosion.get_overlapping_bodies()
	for body in intersecting:
		if body.has_method("damage"):
			body.damage(damage)

func initialize(new_position):
	position = new_position
	rock_pos = Vector2(0, -500)

	

