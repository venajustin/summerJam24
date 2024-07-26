extends Area2D

@export var base_speed = 25
@export var lunge_mult = 3
@export var lunge_duration = 1
@export var base_lunge_time = 2
@export var lunge_time_variation = 4
@export var side_step_variation = .25
var speed = 100
@export var meteor_scene: PackedScene
@export var meteor_zone_w = 1000
@export var bullet_scene: PackedScene

var direction:Vector2
enum Target { PLAYER, VILLAGER, CENTER, STILL }
var objective = Target.PLAYER

var meteorstrike = 0
var nextmeteor = 0

var attackcooldown = 0
var bulletorigin:Vector2 = Vector2.ZERO

var lungeTime: float = 0
var nextLunge: float = 2.5
var sideStepTheta: float = 0.0

@onready var _player:CharacterBody2D = $"../Player"
@onready var _village_center:Node2D = $"../Village_Center"
@onready var _world = $"../"
@onready var _animation_controller: AnimatedSprite2D = $"AnimatedSprite2D"

# Called when the node enters the scene tree for the first time.
func _ready():
	_animation_controller.play()
	bulletorigin = $BulletOrigin.position



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if objective == Target.STILL:
		direction = Vector2.ZERO
	elif objective == Target.PLAYER: 
		speed = base_speed
		if lungeTime < 0:
			speed = base_speed * lunge_mult
		elif lungeTime > nextLunge:
			lungeTime = 0 - lunge_duration
			nextLunge = base_lunge_time + (randf() * lunge_time_variation)
			
			# SideStep is a randomly generated offset angle so that the movement isn't always perfect
			var variation = randf() * side_step_variation
			sideStepTheta = variation - (side_step_variation / 2)
		lungeTime += delta
		
		
		
		direction = (_player.position - position).normalized().rotated(sideStepTheta)
	elif objective == Target.CENTER:
		direction = (_village_center.position - position)
		if direction.length() < 10:
			direction = Vector2.ZERO
			meteorstrike = 4
			objective = Target.STILL
		else:
			direction = direction.normalized()
	elif objective == Target.VILLAGER:
		pass # implement going to the villager that triggered this and eat them
		
	position += delta * speed * direction
	
	if attackcooldown < 2:
		attackcooldown += delta
	elif objective == Target.PLAYER:
		attack()
		attackcooldown = 0
	
	if meteorstrike > 0:
		if nextmeteor > .1:
			nextmeteor = 0
			var meteor_location = position + Vector2(randf() * meteor_zone_w - (meteor_zone_w / 2), randf() * meteor_zone_w - (meteor_zone_w / 2))
			var meteor = meteor_scene.instantiate()
			meteor.initialize(meteor_location)
			_world.add_child(meteor)
			
		nextmeteor += delta
		meteorstrike -= delta
	

func attack():
	var bullet = bullet_scene.instantiate()
	bullet.initialize(position + bulletorigin, (_player.position - position).normalized())
	_world.add_child(bullet)

func _game_end():
	set_physics_process(false)


func _game_start():
	objective = Target.PLAYER
	set_physics_process(true)

