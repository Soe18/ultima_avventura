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

var curr_sel = "-"
var is_boss = true

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
	sprite.position.y = 250
	
	# Load healthbar
	healthbar.max_value = boss_info.base_hp
	healthbar.value = boss_info.base_hp

func _process(delta):
	%HealthLabel.text = str(curr_hp)+"/"+str(boss_info.base_hp)

func choose_random_ability():
	# We could also define a cooldown time in the future
	curr_sel = boss_info.abilities.pick_random()

# diff identifica la differenza
# Se è un valore negativo, recupera vita
func receive_damage(diff):
	# Damage formula:
	curr_hp = curr_hp-diff
	if (curr_hp < 0):
		curr_hp = 0
	if (curr_hp > boss_info.base_hp):
		curr_hp = 0
	healthbar.value = curr_hp

func change_atk(modifier):
	curr_atk = curr_atk + modifier
	if curr_atk < 0:
		curr_atk = 0

func change_def(modifier):
	curr_def = curr_def + modifier
	if curr_def < 0:
		curr_def = 0

func change_spe(modifier):
	curr_spe = curr_spe + modifier
	if curr_spe < 0:
		curr_spe = 0

func change_eva(modifier):
	curr_eva = curr_eva + modifier
	if curr_eva < 0:
		curr_eva = 0
