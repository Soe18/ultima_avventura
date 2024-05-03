extends Node

var current_scene = null
# Set your parameter here
var informer : String
var players : Node
var bosses : Array
var index_boss : int
var score := 0
var players_status = {}
var paused = false
@onready var menu = %Menu

const players_route := "res://scenes/editable/players.tscn"
const bosses_route := "res://data/bosses/"
const gameplay_route := "res://scenes/non_editable/gameplay.tscn"
const cutscenes_route := "res://scenes/non_editable/between_cutscenes.tscn"

func _ready():
	# Initialize players
	players = preload(players_route).instantiate()
	for player in players.get_children():
		players_status[player.name] = {
			"hp": player.curr_hp,
			"mana": player.curr_mana
		}
	# Initialize bosses
	var dir = DirAccess.open(bosses_route)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			bosses.append(file_name)
			file_name = dir.get_next()
	# Find random int
	current_scene = preload(gameplay_route).instantiate()
	current_scene.players_node = players
	var boss_tres = load(get_boss_tres_path())
	current_scene.boss_tres = boss_tres
	add_child(current_scene)
	move_child(current_scene, 0)

# Manage pause when playing
func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		if not paused:
			pause_game()
		else:
			continue_game()

# It's better to call signals for it
func load_between_cutscene():
	print_debug()
	current_scene.queue_free()
	players = preload(players_route).instantiate()
	current_scene = preload(cutscenes_route).instantiate()
	add_child(current_scene)
	move_child(current_scene, 0)

func load_next_game():
	print_debug()
	current_scene.queue_free()
	current_scene = preload(gameplay_route).instantiate()
	current_scene.players_node = players
	var boss_tres = load(get_boss_tres_path())
	current_scene.boss_tres = boss_tres
	add_child(current_scene)
	move_child(current_scene, 0)
	
	for p in current_scene.players_node.get_children():
		p.set_health(players_status[p.name]["hp"])
		p.set_mana(players_status[p.name]["mana"])

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
	print_debug()
	score = score + 1

func lose():
	print_debug()
	score = -1

func get_score() -> int:
	print_debug()
	return score

func update_player_status(players_node):
	self.players = players_node.duplicate()
	var index := 0
	for player in players_node.get_children():
		# Save on dictionary
		players_status[player.name]["hp"] = player.curr_hp
		players_status[player.name]["mana"] = player.curr_mana
		index = index + 1
	print_debug(self.players.get_children())

func get_boss_tres_path() -> String:
	var index = RandomNumberGenerator.new().randi_range(0, len(bosses)-1)
	return bosses_route+bosses[index]
