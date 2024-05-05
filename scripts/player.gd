extends Node2D

# Informazioni generiche di un personaggio
@export var player_info:Player_Info

var curr_hp = -1
var curr_mana = -1
@onready var curr_atk = player_info.base_atk
@onready var curr_def = player_info.base_def
@onready var curr_spe = player_info.base_spe
@onready var curr_eva = player_info.base_eva

@onready var active_container = %ActiveContainer
@onready var player_card = %PlayerCard

@onready var healthbar = %HealthBar
@onready var manabar = %ManaBar

func _ready():
	# Change position
	# TODO: adjust positions and create a whole method to implement this shit
	if player_info.card_position == player_info.CARD_POSITION.BOTTOM_LEFT:
		player_card.position.x = 52
		player_card.position.y = 280
	if player_info.card_position == player_info.CARD_POSITION.BOTTOM_RIGHT:
		player_card.position.x = +437+150
		player_card.position.y = 280
	if player_info.card_position == player_info.CARD_POSITION.TOP_LEFT:
		player_card.position.x = 52
		player_card.position.y = 75
	if player_info.card_position == player_info.CARD_POSITION.TOP_RIGHT:
		player_card.position.x = +437+150
		player_card.position.y = +75
	
	# Manage health
	if curr_hp == -1: # First game
		curr_hp = player_info.base_hp
	if curr_mana == -1: # First game
		curr_mana = player_info.base_mana
	
	healthbar.max_value = player_info.base_hp
	healthbar.value = player_info.base_hp
	
	manabar.max_value = player_info.base_mana
	manabar.value = player_info.base_hp

func active_borders(visibility):
	active_container.visible = visibility

func _process(delta):
	pass

# diff identifica la differenza
# Se è un valore negativo, recupera vita
func change_health(diff):
	print(player_info.name)
	curr_hp = curr_hp-diff
	if (curr_hp<0):
		curr_hp = 0
	healthbar.value = curr_hp

# Not a damage function
func set_health(health):
	curr_hp = health
	if (curr_hp<0):
		curr_hp = 0
	healthbar.value = curr_hp

# Same as set_health()
func set_mana(mana):
	curr_mana = mana
	if (mana<0):
		mana = 0
	manabar.value = mana
