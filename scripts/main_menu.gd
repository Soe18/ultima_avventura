extends Control

@onready var new_game_btn = %NewGame
@onready var scene_manager = get_tree().root.get_child(0)

func menu_focus():
	new_game_btn.grab_focus()

func _on_new_game_pressed():
	scene_manager.load_next_game()
	scene_manager.jukebox.sfx_confirm.play()

func _on_load_game_pressed():
	if scene_manager.load():
		scene_manager.load_next_game()
	scene_manager.jukebox.sfx_confirm.play()

func _on_quit_game_pressed():
	get_tree().quit()
