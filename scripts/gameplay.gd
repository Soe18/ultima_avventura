extends Node2D

enum MENU_STATES {NONE, SELECT_FIELD, SELECT_SUBFIELD, SELECT_TARGET, SELECT_ALLY}

var player_input : Array
var menu_state = MENU_STATES.SELECT_FIELD

@onready var menu = %Menu
@onready var players_node
@onready var boss_node = %Boss

# Lista dei personaggi
@onready var players : Array
@onready var boss
# Lista del personaggio che sta scegliendo
@onready var current_player
# Lista del menu corrente
@onready var fields_to_be_shown

# Indice del player della lista dei personaggi (players)
var player_index = 0
var choosing = true
var processed_default_vars_start:bool = true
var processed_default_vars_action:bool = true
var check_end_of_game:bool = false
var all_attackers

@onready var scene_manager = get_tree().root.get_child(0)

func _ready():
	# Put boss in scene
	boss = boss_node.get_child(0)
	# Put players in scene
	add_child(players_node)

func _process(delta):
	# Reading menu
	if choosing:
		if processed_default_vars_start:
			# Dentro il nodo Players sono contenuti tutti i personaggi
			players = []
			player_input = []
			# Guardo i figli che ha il nodo players
			for player in players_node.get_children():
				# Se è vivo, lo tengo conto per
				# l'azione di questo turno
				if player.curr_hp>0:
					players.append(player)
					player_input.append("")
			print_debug(players)
			# TODO: Sorting via ordine giocatori,
			# Dai errore se overlappano le posizioni
			current_player = players[player_index]
			fields_to_be_shown = current_player.player_info.menu
			current_player.active_borders(true)
			menu_state = MENU_STATES.SELECT_FIELD
			processed_default_vars_action = true
			processed_default_vars_start = false
		
		# Start the loop
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
			print_debug(player_input)
			player_input[player_index] = menu.get_field()
			manage_next_move()
		if Input.is_action_just_pressed("deny"):
			previous_selection()
	else:
		if processed_default_vars_action:
			player_index = 0
			processed_default_vars_action = false
			processed_default_vars_start = true
			menu.visible = false
			all_attackers = players.duplicate()
			all_attackers.append(boss)
			all_attackers.sort_custom(func(a,b) : return a.curr_spe > b.curr_spe)
			# Everyone now has right orders... or not?
			# TODO: FUNC to check if move changes action time
		
		if player_index >= all_attackers.size():
			choosing = true
			player_index = 0
		
		# Will do a caller
		if Input.is_action_just_pressed("confirm") && !choosing:
			general_damage(all_attackers[player_index])
			player_index = player_index+1
			check_end_of_game = true
		
		# Check end of game
		if check_end_of_game:
			if boss.curr_hp <= 0:
				scene_manager.inc_score()
				# Players in scene manager is a node, not an array
				scene_manager.update_player_status(players_node)
				scene_manager.load_between_cutscene()
			if all_players_are_dead():
				# change to gameover
				scene_manager.lose()
				scene_manager.update_player_status(players_node)
				scene_manager.load_between_cutscene()

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
		fields_to_be_shown = current_player.player_info.menu
		current_player.active_borders(true)
	else:
		choosing = false
		# Put everything in default state
		menu_state = MENU_STATES.SELECT_FIELD

func prev_player():
	current_player.active_borders(false)
	# Controlliamo che ci sia un pg prima
	player_index = (player_index-1)
	if player_index < 0:
		player_index = 0
	current_player = players[player_index]
	menu_state = MENU_STATES.SELECT_FIELD
	fields_to_be_shown = current_player.player_info.menu
	current_player.active_borders(true)

func is_boss(entity):
	if entity.get_parent() == %Boss:
		return true
	return false

# fighting methods
func general_damage(entity):
	if (!is_boss(entity)):
		boss.change_health(entity.curr_atk)
	else:
		var lucky_one = players.pick_random()
		lucky_one.change_health(entity.curr_atk)

# If someone is alive, not all players are dead
func all_players_are_dead():
	for player in players:
		if player.curr_hp > 0:
			return false
	return true
