extends Area2D

@export var speed = 100
@export var meteor_scene: PackedScene
@export var meteor_zone_w = 1000

var direction:Vector2
enum Target { PLAYER, VILLAGER, CENTER, STILL }
var objective = Target.CENTER

var meteorstrike = 0
var nextmeteor = 0

@onready var _player = $"../Player"
@onready var _village_center = $"../Village_Center"
@onready var _world = $"../"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if objective == Target.STILL:
		direction = Vector2.ZERO
	elif objective == Target.PLAYER: 
		direction = (_player.position - position).normalized()
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
	
	
	if meteorstrike > 0:
		if nextmeteor > .1:
			nextmeteor = 0
			var meteor_location = position + Vector2(randf() * meteor_zone_w - (meteor_zone_w / 2), randf() * meteor_zone_w - (meteor_zone_w / 2))
			var meteor = meteor_scene.instantiate()
			meteor.initialize(meteor_location)
			_world.add_child(meteor)
			
		nextmeteor += delta
		meteorstrike -= delta
	



func _game_end():
	set_physics_process(false)


func _game_start():
	objective = Target.CENTER
	set_physics_process(true)

