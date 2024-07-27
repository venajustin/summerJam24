extends CharacterBody2D


@export var speed = 60.0
@onready var _demon = $"../Demon"
@onready var _player = $"../Player"

var direction: Vector2 = Vector2.ZERO
@onready var rays:Array[Node] = $Rays.get_children()
enum Target {EVADE, FORWARD}
var state:Target = Target.FORWARD

func _ready():
	direction = Vector2(1, 0).rotated(randf() * 2 * PI)
	for ray in rays:
		ray.add_exception(self)
		ray.add_exception(_player)
		ray.add_exception(_player.find_child("Hitbox", false))
		ray.add_exception(_demon)



func _physics_process(delta):
	
	for ray in rays:
		if ray.is_colliding():
			if ray.target_position.x != 0:
				direction.x = -direction.x
			else:
				direction.y = -direction.y
	
	if state == Target.EVADE:
		direction = (position - _demon.position).normalized()
	elif state == Target.FORWARD:
		pass
	
	velocity = speed * direction
	
	move_and_slide()




func _on_vision_area_entered(area):
	if area.name == "Demon":
		state = Target.EVADE


func _on_vision_area_exited(area):
	if area.name == "Demon":
		state = Target.FORWARD