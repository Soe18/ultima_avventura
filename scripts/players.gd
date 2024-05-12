extends Node

func _ready():
	# Changes order or quits game if more than 4 players:
	var players = get_children()
	players.sort_custom(func(a,b): return a.player_info.card_position < b.player_info.card_position)
	for player in get_children():
		remove_child(player)
	for player in players:
		add_child(player)
	
	if len(players)>4:
		get_tree().quit()
