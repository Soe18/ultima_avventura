extends Node2D

@onready var sprite = %DefaultSprite
@onready var healthbar = %HealthBar

# Informazioni generiche di un personaggio
@export var boss_info:Boss_Info

var curr_hp
var curr_atk
var curr_def
var curr_spe
var curr_eva

func load_data():
	curr_hp = boss_info.base_hp
	curr_atk = boss_info.base_atk
	curr_def = boss_info.base_def
	curr_spe = boss_info.base_spe
	curr_eva = boss_info.base_eva
	
	# Assegna l'immagine allo sprite
	sprite.texture = boss_info.param_sprite
	# Centra l'immagine del boss nello schermo
	sprite.position.x = 320
	sprite.position.y = 180
	
	# Load healthbar
	healthbar.max_value = boss_info.base_hp
	healthbar.value = boss_info.base_hp

func _process(delta):
	pass

# diff identifica la differenza
# Se è un valore negativo, recupera vita
func change_health(diff):
	curr_hp = curr_hp-diff
	if (curr_hp<0):
		curr_hp = 0
	healthbar.value = curr_hp
