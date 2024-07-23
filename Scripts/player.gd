extends CharacterBody2D

var health = 100
@export var health_max = 100
var stamina = 100
@export var stamina_max = 100
var mana = 100
@export var mana_max = 100

var timer = 0

signal update_health
signal update_stamina
signal update_mana
signal died


@export var walk_speed = 100
@export var run_speed = 200
@onready var _animated_sprite = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	_animated_sprite.play("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	var speed = walk_speed
	if Input.is_action_pressed("sprint"):
		speed = run_speed
	
	var direction:Vector2
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	if direction:
		velocity = direction.normalized() * speed
		_animated_sprite.flip_h = direction.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
	move_and_slide()
	
	# Temporary pressing space lowers health
	if Input.is_action_just_pressed("dash"):
		health -= 10
		update_health.emit(health)
		
		
	
	if timer > 1: 
		if health < health_max:
			health += 10
		update_health.emit(health)
		timer = 0
		
	if health <= 0:
		died.emit()
		set_physics_process(false)
	
	timer += delta


func _game_start():
	set_physics_process(true)
	health = health_max
	stamina = stamina_max
	mana = mana_max
