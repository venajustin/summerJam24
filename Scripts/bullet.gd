extends Area2D

@export var speed = 200

var direction:Vector2 = Vector2.ZERO
@onready var _sprite:AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()



func _physics_process(delta):
	position += direction * speed * delta
	_sprite.rotation = direction.angle()

#  bullet.initialize(position + bulletorigin, (_player.position - position).normalized())
func initialize(location, newdirection):
	direction = newdirection
	position = location
	
