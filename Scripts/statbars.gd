extends CanvasLayer

var health = 100
var stamina = 100
var mana = 100

const default_width = 100 / 100
const default_height = 10

@onready var _health_bar:ColorRect = $Health
@onready var _stamina_bar:ColorRect = $Stamina
@onready var _mana_bar:ColorRect = $Mana
@onready var _death_overlay = $DeathScreen
@onready var _num_villagers_text = $num_villagers

const STAMINA_NORMAL_COLOR: Color = Color(0.85882353782654, 0.91372549533844, 0.40392157435417)
const STAMINA_LOW_COLOR: Color = Color(0.85882353782654, 0.19215686619282, 0.40392157435417)
	
	
func _update_health(newHealth) :
	health = newHealth
	_health_bar.size = Vector2(default_width * health, default_height)
	

func _update_stamina(newStamina):
	stamina = newStamina
	if stamina > 20:
		_stamina_bar.color = STAMINA_NORMAL_COLOR
	else:
		_stamina_bar.color = STAMINA_LOW_COLOR
	_stamina_bar.size = Vector2(default_width * stamina, default_height)

func _update_mana(newMana):
	mana = newMana
	_mana_bar.size = Vector2(default_width * mana, default_height)
	


func _game_start():
	visible = true
	_death_overlay.visible = false
func _game_end():
	_death_overlay.visible = true


func _on_main_villagers_eaten(numVillagers, total):
	_num_villagers_text.text = str(numVillagers) + " / " + str(total)
