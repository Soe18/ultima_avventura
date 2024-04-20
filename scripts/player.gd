extends Node2D

# Informazioni generiche di un personaggio
@export var player_info:Player_Info

@onready var curr_hp = player_info.base_hp
@onready var curr_mana = player_info.base_mana
@onready var curr_atk = player_info.base_atk
@onready var curr_def = player_info.base_def
@onready var curr_spe = player_info.base_spe
@onready var curr_eva = player_info.base_eva

@onready var active_container = %ActiveContainer
@onready var player_card = %PlayerCard
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

func active_borders(visibility):
	active_container.visible = visibility

func _process(delta):
	pass
