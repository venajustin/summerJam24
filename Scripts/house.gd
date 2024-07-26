extends StaticBody2D

@export var hitstun_time:float = 1
var health: int  = 3
var hit_tick = -1

@export var _villager_scene:PackedScene

@onready var animation_controller: AnimatedSprite2D = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_controller.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if health == 0:
		pass
	elif hit_tick > -1:
		if hit_tick > hitstun_time:
			hit_tick = 0
			health -= 1
			if health == 0:
				process_mode = 4
				spawnvillagers()
			animation_controller.frame = 3 - health
		else:
			hit_tick += delta
	


func spawnvillagers():
	var villagers = [_villager_scene.instantiate(), _villager_scene.instantiate(), _villager_scene.instantiate(), _villager_scene.instantiate()]
	var i = -48
	for villager in villagers:
		get_parent().add_child(villager)
		villager.position = position + Vector2(i, 0)
		i += 32
	

func _on_area_entered(area):
	if area.name == "Demon":
		hit_tick = hitstun_time



func _on_area_exited(area):
	if area.name == "Demon":
		hit_tick = -1
