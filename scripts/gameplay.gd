extends Node2D

@export_category("Describer")
@export var describer : Describer

enum SELECTOR_STATES {NONE, SELECT_FIELD, SELECT_SUBFIELD, SELECT_TARGET, SELECT_ALLY}

var player_input : Array
# Saves the input of the whole category, not just the value of it
var category_input : Array
var selector_state = SELECTOR_STATES.SELECT_FIELD
var itemlist : Itemlist

@onready var selector = %Selector
@onready var descriptor = %Descriptor
@onready var abilities = %Abilities

@onready var players_node
@onready var boss_node = %Boss
var boss_tres

# Lista dei personaggi
@onready var players : Array
@onready var boss
# Lista del personaggio che sta scegliendo
@onready var current_player
# Lista del selector corrente
@onready var fields_to_be_shown

# Indice del player della lista dei personaggi (players)
var player_index = 0
var choosing = true
var animation_playing = false
var processed_default_vars_start:bool = true
var processed_default_vars_action:bool = true
var check_end_of_game:bool = false
var all_attackers

@onready var scene_manager = get_tree().root.get_child(0)

func _ready():
	# Put boss in scene
	boss = boss_node.get_child(0)
	boss.boss_info = boss_tres
	boss.load_data()
	# Put players in scene
	add_child(players_node)

func _process(delta):
	
	# Reading selector
	if choosing:
		if processed_default_vars_start:
			# Dentro il nodo Players sono contenuti tutti i personaggi
			players = []
			player_input = []
			# Guardo i figli che ha il nodo players
			for player in players_node.get_children():
				# For each array of players, we need to
				# populate them, else finding with
				# player_index will throw an error
				if player.curr_hp>0:
					players.append(player)
					player_input.append("")
					category_input.append("")
			print_debug(players)
			# TODO: Dai errore se overlappano le posizioni
			# Si puo' fare anche da scene manager
			current_player = players[player_index]
			fields_to_be_shown = current_player.player_info.selector
			current_player.active_borders(true)
			selector_state = SELECTOR_STATES.SELECT_FIELD
			processed_default_vars_action = true
			processed_default_vars_start = false
		
		# Start the loop
		selector.visible = true
		selector.update_fields(fields_to_be_shown)
		if selector_state == SELECTOR_STATES.SELECT_SUBFIELD:
			descriptor.load_descr(selector.get_field())
		else:
			descriptor.default_dialogue(current_player.name)
		if Input.is_action_just_pressed("left"):
			selector.move_left()
		if Input.is_action_just_pressed("right"):
			selector.move_right()
		if Input.is_action_just_pressed("up"):
			selector.move_up()
		if Input.is_action_just_pressed("down"):
			selector.move_down()
		if Input.is_action_just_pressed("confirm"):
			if selector.get_field():
				category_input[player_index] = player_input[player_index]
				player_input[player_index] = selector.get_field()
				print_debug(category_input)
				manage_next_move()
		if Input.is_action_just_pressed("deny"):
			previous_selection()
	else:
		if processed_default_vars_action:
			descriptor.reset_text()
			player_index = 0
			processed_default_vars_action = false
			processed_default_vars_start = true
			selector.visible = false
			all_attackers = players.duplicate()
			var i = 0
			for attacker in all_attackers:
				attacker.curr_sel = player_input[i]
				i = i+1
			all_attackers.append(boss)
			all_attackers.sort_custom(func(a,b) : return a.curr_spe > b.curr_spe)
			# Everyone now has right orders... or not?
			# TODO: FUNC to check if move changes action time
		if Input.is_action_just_pressed("confirm") and player_index >= all_attackers.size():
			# Anyone who died shall return the items they took
			itemlist.return_items()
			# Set var to enable new turn
			choosing = true
			player_index = 0
		
		if Input.is_action_just_pressed("confirm") && !choosing and not animation_playing:
			descriptor.reset_text()
			if all_attackers[player_index].curr_hp > 0:
				if all_attackers[player_index].curr_sel != "-":
					# Now it's a player attacking
					if all_attackers[player_index].menu_sel == "Memoria":
						# Attacker used a memory
						# Delete the memory entry
						all_attackers[player_index].forget_the_memory()
					elif all_attackers[player_index].menu_sel == "Strumenti":
						itemlist.confirm_del_item(all_attackers[player_index].curr_sel)
					abilities.do_ability(all_attackers[player_index])
				else:
					# Now it's the boss attacking
					abilities.do_ability(all_attackers[player_index])
			else:
				print_debug("he's dead...")
			player_index = player_index+1
			check_end_of_game = true
		
		# Check end of game
		if check_end_of_game:
			if boss.curr_hp <= 0:
				scene_manager.inc_score()
				# Players in scene manager is a node, not an array
				scene_manager.update_player_status(players_node)
				scene_manager.load_between_cutscene()
				
				# Not used items (because fight finished earlier) returns
				itemlist.return_items()
			if all_players_are_dead():
				# change to gameover
				scene_manager.lose()
				scene_manager.update_player_status(players_node)
				scene_manager.load_between_cutscene()

# choosing methods
func manage_next_move():
	# If true, let's check if we do need to open a new selector
	if selector_state == SELECTOR_STATES.SELECT_FIELD:
		if player_input[player_index] == "Combatti" or player_input[player_index] == "Memoria":
			selector_state = SELECTOR_STATES.SELECT_SUBFIELD
			fields_to_be_shown = current_player.player_info.subselector.get(player_input[player_index])
		# recupero does not need to have further informations
		elif player_input[player_index] == "Recupero":
			next_player()
		# For strumenti we need to open another menu
		elif player_input[player_index] == "Strumenti":
			selector_state = SELECTOR_STATES.SELECT_SUBFIELD
			fields_to_be_shown = itemlist.arrify() # Returns a simple array from the resource
			
	# If true, let's see if selection is done or if we do need more informations
	elif selector_state == SELECTOR_STATES.SELECT_SUBFIELD:
		# Let's manage the deletion entry for strumenti
		if category_input[player_index] == "Strumenti":
			itemlist.del_item(player_input[player_index])
		players[player_index].menu_sel = category_input[player_index]
		next_player()
	elif selector_state == SELECTOR_STATES.SELECT_TARGET:
		pass
	elif selector_state == SELECTOR_STATES.SELECT_ALLY:
		pass
	selector.reset_posix()

func previous_selection():
	if selector_state == SELECTOR_STATES.SELECT_SUBFIELD:
		selector_state = SELECTOR_STATES.SELECT_FIELD
		fields_to_be_shown = current_player.player_info.selector
	elif selector_state == SELECTOR_STATES.SELECT_FIELD:
		prev_player()
		fields_to_be_shown = current_player.player_info.selector
	selector.reset_posix()
	pass

func next_player():
	current_player.active_borders(false)
	player_index = (player_index+1)
	if player_index < players.size():
		current_player = players[player_index]
		selector_state = SELECTOR_STATES.SELECT_FIELD
		fields_to_be_shown = current_player.player_info.selector
		current_player.active_borders(true)
	else:
		choosing = false
		# Put everything in default state
		selector_state = SELECTOR_STATES.SELECT_FIELD

func prev_player():
	current_player.active_borders(false)
	# Controlliamo che ci sia un pg prima
	player_index = (player_index-1)
	if player_index < 0:
		player_index = 0
	# if item selected, put it back
	if category_input[player_index] == "Strumenti":
		# Means we have selected an item
		# It might not be the case, but
		# this method will check it for us
		itemlist.restore_just_last_item()
	current_player = players[player_index]
	selector_state = SELECTOR_STATES.SELECT_FIELD
	fields_to_be_shown = current_player.player_info.selector
	current_player.active_borders(true)

func is_boss(entity):
	if entity.get_parent() == %Boss:
		return true
	return false

# If someone is alive, not all players are dead
func all_players_are_dead():
	for player in players:
		if player.curr_hp > 0:
			return false
	return true
