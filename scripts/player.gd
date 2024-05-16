extends Node2D

# Informazioni generiche di un personaggio
@export var player_info:Player_Info

var curr_hp = -1
var curr_mana = -1
@onready var curr_atk = player_info.base_atk
@onready var curr_def = player_info.base_def
@onready var curr_spe = player_info.base_spe
@onready var curr_eva = player_info.base_eva

var curr_sel = ""
var menu_sel = ""
var is_boss = false

@onready var active_container = %ActiveContainer
@onready var chara_bg = %CharaBg
@onready var displayed_name = %DisplayedName

@onready var healthbar = %HealthBar
@onready var manabar = %ManaBar
@onready var chara_img = %CharaImg

func _ready():
	var halved_card_size = Vector2(45, 75)
	var height_helpbar = 15
	# Change position
	# TODO: adjust positions and create a whole method to implement this shit
	if player_info.card_position == player_info.CARD_POSITION.BOTTOM_LEFT:
		position.x = halved_card_size.x
		position.y = get_viewport_rect().size.y-halved_card_size.y
	if player_info.card_position == player_info.CARD_POSITION.BOTTOM_RIGHT:
		position.x = get_viewport_rect().size.x-halved_card_size.x
		position.y = get_viewport_rect().size.y-halved_card_size.y
	if player_info.card_position == player_info.CARD_POSITION.TOP_LEFT:
		position.x = halved_card_size.x
		position.y = halved_card_size.y+height_helpbar
	if player_info.card_position == player_info.CARD_POSITION.TOP_RIGHT:
		position.x = get_viewport_rect().size.x-halved_card_size.x
		position.y = halved_card_size.y+height_helpbar
	
	# Manage health
	if curr_hp == -1: # First game
		curr_hp = player_info.base_hp
	if curr_mana == -1: # First game
		curr_mana = player_info.base_mana
	
	chara_bg.play()
	
	# Let's show its image!
	chara_img.texture = player_info.image

	healthbar.max_value = player_info.base_hp
	healthbar.value = player_info.base_hp
	
	manabar.max_value = player_info.base_mana
	manabar.value = player_info.base_hp
	
	displayed_name.text = player_info.name

func _process(_delta):
	%HealthLabel.text = str(curr_hp)+"/"+str(player_info.base_hp)
	%ManaLabel.text = str(curr_mana)+"/"+str(player_info.base_mana)

func active_borders(visibility):
	active_container.visible = visibility

# diff identifica la differenza
# Se è un valore negativo, recupera vita
func receive_damage(diff):
	curr_hp = curr_hp-diff
	if (curr_hp < 0):
		curr_hp = 0
	if (curr_hp > player_info.base_hp):
		curr_hp = player_info.base_hp
	healthbar.value = curr_hp

# Se è un valore negativo, recupera mana
func use_mana(diff):
	curr_mana = curr_mana-diff
	if (curr_mana < 0):
		curr_mana = 0
	if (curr_mana > player_info.base_mana):
		curr_mana = player_info.base_mana
	manabar.value = curr_mana

# Positive modifier, buffed stats
# Negative modifier, nerfed stats
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

# Not a damage function
func set_health(health):
	curr_hp = health
	if (curr_hp<0):
		curr_hp = 0
		chara_bg.stop()
	healthbar.value = curr_hp

# Same as set_health()
func set_mana(mana):
	curr_mana = mana
	if (mana<0):
		mana = 0
	manabar.value = mana

func set_memories(memories):
	player_info.subselector["Memoria"] = memories

func forget_the_memory():
	player_info.subselector.get("Memoria").erase(curr_sel)
