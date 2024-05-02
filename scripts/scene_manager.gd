extends Node

var current_scene = null
# Set your parameter here
var informer : String
var players : Node
var bosses
var index_boss : int
var score := 0
var players_status = {}

const players_route := "res://scenes/editable/players.tscn"
const bosses_route := "res://scenes/editable/bosses.tscn"
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
	""" Cosa posso fare?
	a. Prendi uno a caso dai nodi bosses
	b. Leggi nella dir data/bosses i tres e li assegni in un array poi random
	"""
	bosses = preload(bosses_route).instantiate()
	for boss in bosses.get_children():
		var boss_tres = boss.boss_info
		add_child(boss)
		print_debug(boss.name)
	current_scene = preload(gameplay_route).instantiate()
	current_scene.players_node = players
	current_scene.boss = bosses.get_child(0)
	add_child(current_scene)
	pass

# It's better to call signals for it
func load_between_cutscene():
	print_debug()
	current_scene.queue_free()
	players = preload(players_route).instantiate()
	current_scene = preload(gameplay_route).instantiate()
	add_child(current_scene)

func load_next_game():
	print_debug()
	current_scene.queue_free()
	current_scene = preload(gameplay_route).instantiate()
	current_scene.players_node = players
	add_child(current_scene)
	
	for p in current_scene.players_node.get_children():
		p.set_health(players_status[p.name]["hp"])
		p.set_mana(players_status[p.name]["mana"])

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
