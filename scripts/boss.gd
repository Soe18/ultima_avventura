extends Node2D

@onready var sprite = %DefaultSprite
@onready var healthbar = %HealthBar

# Informazioni generiche di un personaggio
@export var boss_info:Boss_Info

@onready var curr_hp = boss_info.base_hp
@onready var curr_atk = boss_info.base_atk
@onready var curr_def = boss_info.base_def
@onready var curr_spe = boss_info.base_spe
@onready var curr_eva = boss_info.base_eva

func _ready():
	# Assegna l'immagine allo sprite
	sprite.texture = boss_info.param_sprite
	# Centra l'immagine del boss nello schermo
	var size = boss_info.param_sprite.get_size()
	var viewport = get_viewport().size
	sprite.position.x = viewport.x/2
	sprite.position.y = viewport.y/2
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
