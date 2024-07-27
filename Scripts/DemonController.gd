extends Area2D

signal eat_villager

@export var base_speed:int = 75
@export var lunge_mult:float = 3
@export var house_mult:float = .25
var house_speed:float = 1
@export var lunge_duration:float = 1
@export var base_lunge_time:float = 2
@export var lunge_time_variation:float = 4
@export var side_step_variation:float = .5 * PI
var speed:int = 100
@export var meteor_scene: PackedScene
@export var meteor_zone_w:int = 1000
@export var bullet_scene: PackedScene
@export var bullet_spray_duration:float = .5
@export var bullet_spray_time:float = 1
@export var bullet_spray_angle:float = .25 * PI
@export var bullet_spray_frequency:float = .1
var between_bullets_time:float = 0

@export var bullet_splash_frequency:float = .2
@export var bullet_splash_duration:float = .5
@export var bullet_splash_time_between:float = 2
var bullet_splash_time:float = 0
var last_splash:float = 0

var direction:Vector2
enum Target { PLAYER, VILLAGER, CENTER, STILL }
var objective = Target.VILLAGER

var phase:int = 0

var villagerTarget:Node2D = null

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
@onready var _tentacle_animation_controller: AnimatedSprite2D = $"AnimatedSprite2D2"

# Called when the node enters the scene tree for the first time.
func _ready():
	_animation_controller.play()
	_animation_controller.frame = 0
	_tentacle_animation_controller.play("Idle")
	_tentacle_animation_controller.frame = 0
	bulletorigin = $BulletOrigin.position
	_tentacle_animation_controller.visible = false



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
		

	
	if objective == Target.PLAYER:
		
		attackcooldown += delta
		if attackcooldown < bullet_spray_time:
			pass
		elif attackcooldown < bullet_spray_time + bullet_spray_duration:
			if between_bullets_time > bullet_spray_frequency:
				between_bullets_time = 0
				var dirOffset:float = randf() * bullet_spray_angle - (bullet_spray_angle / 2.0)
				attack(dirOffset)
			else:
				between_bullets_time += delta
		else:
			attackcooldown = 0
		
		if phase > 0:
			print(bullet_splash_time)
			bullet_splash_time += delta
			if bullet_splash_time > bullet_splash_time_between:
				if bullet_splash_time - last_splash > bullet_splash_frequency:
					last_splash = bullet_splash_time
					for i in 8:
						attack(PI / 4 * i)
			if bullet_splash_time > bullet_splash_time_between + bullet_splash_duration:
				bullet_splash_time = 0
				last_splash = 0
	
	if meteorstrike > 0:
		if nextmeteor > .1:
			nextmeteor = 0
			var meteor_location = position + Vector2(randf() * meteor_zone_w - (meteor_zone_w / 2), randf() * meteor_zone_w - (meteor_zone_w / 2))
			var meteor = meteor_scene.instantiate()
			meteor.initialize(meteor_location)
			_world.add_child(meteor)
			
		nextmeteor += delta
		meteorstrike -= delta
	
	if objective == Target.VILLAGER:
		direction = (villagerTarget.position - position).normalized()
		
	if direction.x < 0:
		_animation_controller.flip_h = true
		_tentacle_animation_controller.flip_h = true
	else:
		_animation_controller.flip_h = false
		_tentacle_animation_controller.flip_h = false
	position += delta * speed * direction * house_speed
		

func attack(offset: float):
	var bullet = bullet_scene.instantiate()
	bullet.initialize(position + bulletorigin, (_player.position - (position + bulletorigin)).normalized().rotated(offset), _player, self)
	_world.add_child(bullet)

func _game_end():
	set_physics_process(false)


func _game_start():
	objective = Target.PLAYER
	set_physics_process(true)



func _on_area_entered(area):
	if area.name == "HouseArea":
		house_speed = house_mult


func _on_area_exited(area):
	if area.name == "HouseArea":
		house_speed = 1


func _on_body_entered(body):
	if body.has_method("stun"):
		print("villager eaten")
		body.queue_free()
		eat_villager.emit()
		objective = Target.PLAYER


func _on_vision_body_entered(body):
	if objective == Target.PLAYER:
		if body.has_method("stun"):
			objective = Target.VILLAGER
			villagerTarget = body


func _on_main_next_phase():
	phase += 1
	if phase > 0:
		_tentacle_animation_controller.visible = true
