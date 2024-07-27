
extends CharacterBody2D

var health = 100
@export var health_max = 100
var stamina = 100
@export var stamina_max = 100
@export var stamina_loss_mult = 50
@export var stamina_gain_mult = 15
var can_sprint: bool = true
var mana = 100
@export var mana_max = 100

@export var hitstun_time = .5

var timer = 0
var hitstun = 0

signal update_health
signal update_stamina
signal update_mana
signal died


@export var walk_speed = 100
@export var run_speed = 200
@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _hit_box: Area2D = $Hitbox

@export var defaultColor:Color = Color.WHITE
@export var hitColor:Color = Color(1, 0.1803921610117, 0.20000000298023)

# Called when the node enters the scene tree for the first time.
func _ready():
	_animated_sprite.play("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	var speed = walk_speed
	
	if stamina > 20:
		can_sprint = true
	if Input.is_action_pressed("sprint") && stamina > 1 && can_sprint:
		_animated_sprite.play("run")
		speed = run_speed
		if stamina > 0:
			stamina -= delta * stamina_loss_mult
	else:
		_animated_sprite.play("walk")
		if stamina < 20:
			can_sprint = false
		if stamina < stamina_max:
			stamina += delta * stamina_gain_mult
	update_stamina.emit(stamina)
	

	
	var direction:Vector2
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	if direction:

		velocity = direction.normalized() * speed
		_animated_sprite.flip_h = direction.x < 0
	else:
		_animated_sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
	move_and_slide()
	
	var colliding_with = _hit_box.get_overlapping_areas()
	for area in colliding_with:
		if area.name == "Demon":
			health -= 100 * delta
			update_health.emit(health)
	
	if Input.is_action_just_pressed("dash"):
		pass
		
	if health <= 0:
		died.emit()
		set_physics_process(false)
	
	if hitstun > 0:
		hitstun += delta
		if hitstun < hitstun_time * .33 + 1:
			modulate = hitColor 
		elif hitstun < hitstun_time * .66 + 1:
			modulate = defaultColor
		elif hitstun < hitstun_time + 1:
			modulate = hitColor
		elif hitstun > hitstun_time + 1:
			hitstun = 0
			modulate = defaultColor
			

	
	timer += delta


func _game_start():
	set_physics_process(true)
	_hit_box.monitoring = true
	health = health_max
	stamina = stamina_max
	mana = mana_max
	update_health.emit(health)
	update_stamina.emit(stamina)
	update_mana.emit(mana)

func damage(val):
	if hitstun > 0:
		print ("damage negated from hitstun")
		return
	modulate = hitColor
	health -= val
	update_health.emit(health)
	hitstun = 1

func _on_hitbox_area_entered(area):
	if area.has_method("get_damage"):
		damage(area.get_damage())

