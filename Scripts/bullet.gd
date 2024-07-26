extends Area2D

@export var speed = 200
@export var damage = 25

@export var max_lifetime:float = 100
var lifetime:float = 0
@export var max_bounces:float = 5
var bounces = 0

var direction:Vector2 = Vector2.ZERO
@onready var _sprite:AnimatedSprite2D = $AnimatedSprite2D

@onready var rays:Array[Node] = $Rays.get_children()

var player:CharacterBody2D = null
var demon:Area2D = null


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()
	for ray in rays:
		ray.add_exception(self)
		ray.add_exception(player)
		ray.add_exception(player.find_child("Hitbox", false))
		ray.add_exception(demon)


func get_damage():
	return damage

func _physics_process(delta):
	for ray in rays:
		if ray.is_colliding():
			bounces += 1
			if ray.target_position.x != 0:
				direction.x = -direction.x
			else:
				direction.y = -direction.y
	
	position += direction * speed * delta
	_sprite.rotation = direction.angle()
	lifetime += delta
	
	if lifetime > max_lifetime || bounces > max_bounces:
		queue_free()


#  bullet.initialize(position + bulletorigin, (_player.position - position).normalized())
func initialize(location, newdirection, player_reference, demon_reference):
	direction = newdirection
	position = location
	player = player_reference
	demon = demon_reference
