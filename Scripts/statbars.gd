extends CanvasLayer

var health = 100
var stamina = 100
var mana = 100

const default_width = 300 / 100
const default_height = 20

@onready var _health_bar = $Health
@onready var _stamina_bar = $Stamina
@onready var _mana_bar = $Mana
@onready var _death_overlay = $DeathScreen

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_health_bar.size = Vector2(default_width * health, default_height)
	_stamina_bar.size = Vector2(default_width * stamina, default_height)
	_mana_bar.size = Vector2(default_width * mana, default_height)
	print(default_width * health)
	print(default_height)
	
func _update_health(newHealth) :
	health = newHealth

func _update_stamina(newStamina):
	stamina = newStamina

func _update_mana(newMana):
	mana = newMana
	


func _game_start():
	visible = true
	_death_overlay.visible = false
func _game_end():
	_death_overlay.visible = true
