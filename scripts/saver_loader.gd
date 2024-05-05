extends Node
# Script which can be called everytime we need to save or load a save data
const save_file := "user://save_file.data"

func save_game(players_status, score, index_boss):
	var file = FileAccess.open(save_file, FileAccess.WRITE)
	# Let's save...
	var save_data = {}
	# Players status (hp and mana, for each)
	save_data["players_status"] = players_status
	# The score
	save_data["score"] = score
	# The current boss
	save_data["index_boss"] = index_boss
	file.store_var(save_data)
	file.close()

func load_game():
	var file = FileAccess.open(save_file, FileAccess.READ)
	var save_data = false
	if file:
		save_data = file.get_var()
		file.close()
	return save_data
