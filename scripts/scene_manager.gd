extends Node

@export var base_itemlist : Itemlist
var itemlist : Itemlist

@export var reset_memories_rate : int = 10
var current_scene = null
# Set your parameter here
var informer : String
var players : Node
var bosses : Array
var index_boss : int = -1
var score := 0
var players_status = {}
# Memories (for some reasons) won't be saved on the single
# player... so here we are...
var default_memories = {}
var paused = false
var ongame = false
@onready var menu = %Menu
@onready var saver_loader = %SaverLoader
@onready var jukebox = %Jukebox

const main_menu := "res://scenes/main_menu.tscn"
const players_route := "res://scenes/players.tscn"
const bosses_route := "res://scenes/bosses.tscn"
const gameplay_route := "res://scenes/gameplay.tscn"
const cutscenes_route := "res://scenes/between_cutscenes.tscn"

func _ready():
	full_main_menu_load(true)
	
	# We're saving here the default memories, because anywhere else it would break
	for player in players.get_children():
		default_memories[player.name] = player.player_info.subselector.get("Memoria").duplicate()

func load_next_game():
	# Let's reset memories each reset_memories_rate rounds
	if score % reset_memories_rate == 0:
		# Let's go with index, I can't get the name
		for player_status in players_status:
			players_status[player_status]["memories"] = default_memories[player_status].duplicate()
	
	ongame = true
	current_scene.queue_free()
	players = preload(players_route).instantiate()
	current_scene = preload(gameplay_route).instantiate()
	current_scene.players_node = players
	var boss_tres = get_boss_tres()
	current_scene.boss_tres = boss_tres
	current_scene.itemlist = itemlist
	add_child(current_scene)
	move_child(current_scene, 0)
	
	for p in current_scene.players_node.get_children():
		p.set_health(players_status[p.name]["hp"])
		p.set_mana(players_status[p.name]["mana"])
		p.set_memories(players_status[p.name]["memories"])

# It's better to call signals for it
func load_between_cutscene():
	#print_debug()
	ongame = false
	current_scene.queue_free()
	players = preload(players_route).instantiate()
	current_scene = preload(cutscenes_route).instantiate()
	add_child(current_scene)
	move_child(current_scene, 0)
	# The boss is already to be selected and there's 
	# no need to know the previous boss now
	index_boss = -1

# Manage pause when playing
func _process(_delta):
	if Input.is_action_just_pressed("escape") and ongame:
		jukebox.sfx_menu.play()
		if not paused:
			pause_game()
		else:
			continue_game()

func pause_game():
	current_scene.process_mode = Node.PROCESS_MODE_DISABLED
	# Show and enable menu
	menu.visible = true
	menu.process_mode = Node.PROCESS_MODE_ALWAYS
	paused = true
	# So we can move it with the keyboards
	menu.set_focus()

func continue_game():
	current_scene.process_mode = Node.PROCESS_MODE_ALWAYS
	# Hide and disable menu
	menu.visible = false
	menu.process_mode = Node.PROCESS_MODE_DISABLED
	paused = false

func inc_score():
	#print_debug()
	score = score + 1
	jukebox.sfx_won.play()

func lose():
	#print_debug()
	score = -1
	jukebox.sfx_lose.play()

func get_score() -> int:
	#print_debug()
	return score

func update_player_status(players_node):
	self.players = players_node.duplicate()
	var index := 0
	for player in players_node.get_children():
		# Save on dictionary
		players_status[player.name]["hp"] = player.curr_hp
		players_status[player.name]["mana"] = player.curr_mana
		players_status[player.name]["memories"] = player.player_info.subselector.get("Memoria")
		#print_debug(players_status)
		index = index + 1
	#print_debug(self.players.get_children())

func get_boss_tres():
	const multiplier = 5
	if index_boss == -1:
		index_boss = RandomNumberGenerator.new().randi_range(0, len(bosses)*multiplier)
		index_boss = index_boss%len(bosses)
	return bosses[index_boss]

func redirect_to_main_menu():
	# No more in pause
	paused = false
	current_scene.queue_free()
	# Hide and disable menu
	menu.visible = false
	menu.process_mode = Node.PROCESS_MODE_DISABLED
	full_main_menu_load(false)

# Called in _ready func
func full_main_menu_load(first_load):
	ongame = false
	score = 0
	# Initialize players
	players = preload(players_route).instantiate()
	# Need to add as a child to load its _ready func
	add_child(players)
	if not first_load: # Let's load onto each player their default memories
		# Let's load the default memories
		for player in players.get_children():
			player.player_info.subselector["Memoria"] = default_memories[player.name].duplicate()
	for player in players.get_children():
		players_status[player.name] = {
			"hp": player.curr_hp,
			"mana": player.curr_mana,
			"memories": player.player_info.subselector.get("Memoria")
		}
	#print_debug(players_status)
	# Remove the players, data saved!
	remove_child(players)
	# Reset boss index
	index_boss = -1
	# Reset items, will be reset also the apparent_deletion
	itemlist = base_itemlist.duplicate()
	
	# Main menu ready
	current_scene = preload(main_menu).instantiate()
	add_child(current_scene)
	current_scene.menu_focus()
	# Initialize bosses
	var bosses_node = preload(bosses_route).instantiate()
	for boss_node in bosses_node.get_children():
		bosses.append(boss_node.boss_info)

func save():
	saver_loader.save_game(players_status, score, index_boss, itemlist)

# Returns true if save data found, else false
func load():
	var loaded_data = saver_loader.load_game()
	if loaded_data:
		score = loaded_data["score"]
		# I duplicate as it may cause errors not doing so
		players_status = loaded_data["players_status"].duplicate()
		#print_debug(players_status)
		index_boss = loaded_data["index_boss"]
		var itemlist_arrified = loaded_data["itemlist"]
		itemlist.itemlist = itemlist_arrified
		return true
	return false
