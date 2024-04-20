extends Node2D

enum MENU_STATES {NONE, SELECT_FIELD, SELECT_SUBFIELD, SELECT_TARGET, SELECT_ALLY}

var player_input = []
var menu_state = MENU_STATES.SELECT_FIELD

@onready var menu = %Menu
@onready var players_node = %Players
@onready var boss = %Boss

# Lista dei personaggi
@onready var players = []
# Lista del personaggio che sta scegliendo
@onready var current_player
# Lista del menu corrente
@onready var fields_to_be_shown

# Indice del player della lista dei personaggi (players)
var player_index = 0
var choosing = true
var processed_default_vars:bool = true

func _ready():
	# Dentro il nodo Players sono contenuti tutti i personaggi
	for player in players_node.get_children():
		players.append(player)
		player_input.append("")
	print(players)
	# TODO: Sorting via ordine giocatori,
	# Dai errore se overlappano le posizioni
	current_player = players[player_index]
	fields_to_be_shown = current_player.player_info.menu
	current_player.active_borders(true)
	
	# Get the boss info
	boss = %Boss.get_child(0)

func _process(delta):
	# Reading menu
	if choosing:
		processed_default_vars = true
		menu.visible = true
		menu.update_fields(fields_to_be_shown)
		if Input.is_action_just_pressed("left"):
			menu.move_left()
		if Input.is_action_just_pressed("right"):
			menu.move_right()
		if Input.is_action_just_pressed("up"):
			menu.move_up()
		if Input.is_action_just_pressed("down"):
			menu.move_down()
		if Input.is_action_just_pressed("confirm"):
			player_input[player_index] = menu.get_field()
			manage_next_move()
		if Input.is_action_just_pressed("deny"):
			previous_selection()
	else:
		# TODO:
		# - once
		# 1. Controlla ordine di movimento
		# 2. Salva array in ordine di mosse
		# - cycled
		# 1. Ad ogni confirm mostra animazione della mossa e via
		if processed_default_vars:
			menu.visible = false
			var all_attackers = players
			all_attackers.append(boss)
			for attacker in all_attackers:
				print(attacker.curr_spe)
			
			processed_default_vars = false
		if Input.is_action_just_pressed("confirm"):
			show_next_action()

# choosing methods
func manage_next_move():
	# If true, let's check if we do need to open a new menu
	if menu_state == MENU_STATES.SELECT_FIELD:
		if player_input[player_index] == "Combatti" or player_input[player_index] == "Memoria":
			menu_state = MENU_STATES.SELECT_SUBFIELD
			fields_to_be_shown = current_player.player_info.submenu.get(player_input[player_index])
		# CHECK RECUPERO E STRUMENTI
		if player_input[player_index] == "Recupero":
			next_player()
	# If true, let's see if selection is done or if we do need more informations
	elif menu_state == MENU_STATES.SELECT_SUBFIELD:
		next_player()
	elif menu_state == MENU_STATES.SELECT_TARGET:
		pass
	elif menu_state == MENU_STATES.SELECT_ALLY:
		pass
	menu.reset_posix()
	print(player_input)
	pass

func previous_selection():
	if menu_state == MENU_STATES.SELECT_SUBFIELD:
		menu_state = MENU_STATES.SELECT_FIELD
		fields_to_be_shown = current_player.player_info.menu
	elif menu_state == MENU_STATES.SELECT_FIELD:
		prev_player()
		fields_to_be_shown = current_player.player_info.menu
	menu.reset_posix()
	pass

func next_player():
	current_player.active_borders(false)
	player_index = (player_index+1)
	if player_index < players.size():
		current_player = players[player_index]
		menu_state = MENU_STATES.SELECT_FIELD
	else:
		choosing = false
	fields_to_be_shown = current_player.player_info.menu
	current_player.active_borders(true)

func prev_player():
	current_player.active_borders(false)
	# Controlliamo che ci sia un pg prima
	player_index = (player_index-1)
	if player_index < 0:
		player_index = 0
	current_player = players[player_index]
	menu_state = MENU_STATES.SELECT_FIELD
	fields_to_be_shown = current_player.menu
	current_player.active_borders(true)

# fighting methods
func show_next_action():
	boss.change_health(20)
